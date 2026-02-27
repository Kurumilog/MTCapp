# Auth Flow: Dio Interceptor — JWT авторизация

## Откуда приходят токены

Бекенд возвращает токены **не в теле ответа**, а **в заголовках ответа**:

```
HTTP/1.1 201 Created
access_token: eyJhbGciOiJIUzI1NiIs...   ← JWT, живёт 15 минут
refresh_token: a3f7b2c9e8d1...           ← 64-символьный hex, одноразовый

Body: { "id": 42, "username": "johndoe", ... }  ← данные пользователя
```

Тело ответа при логине/регистрации содержит объект пользователя. Из него извлекается `id` и сохраняется в Secure Storage для будущего экрана профиля.

---

## Этап 1: `onRequest` — перехват КАЖДОГО исходящего запроса

Срабатывает **на каждый** `dio.get()`, `dio.post()` и т.д. — до того, как запрос уходит в сеть.

**Пример — запрос списка пользователей:**

```
Приложение вызывает:  dio.get('/users')
```

Интерсептор делает:

1. Смотрит путь запроса (`/users`)
2. Сверяет со списком **публичных** эндпоинтов: `/auth/register`, `/auth/login`
3. `/users` — **не публичный** → идём в `TokenStorage`
4. Читает `access_token` из Secure Storage (зашифрованное хранилище Android/iOS)
5. Если токен есть — **вставляет заголовок**:

```
До интерсептора:
  GET /users
  Headers: { Content-Type: application/json }

После интерсептора:
  GET /users
  Headers: { Content-Type: application/json, Authorization: Bearer eyJhbGciOi... }
```

**Пример — логин (публичный путь):**

```
Приложение вызывает:  dio.post('/auth/login', data: {...})
```

1. Путь `/auth/login` **совпадает** с `publicPaths`
2. Токен **не добавляется** → запрос уходит как есть
3. Правильно, потому что при логине у пользователя ещё нет токена

**Как часто:** На каждый HTTP-запрос. O(1) — одно чтение из storage, одна проверка строки.

---

## Этап 2: `onError` — перехват ответа с ошибкой

Срабатывает только когда бекенд **вернул ошибку**. Реагирует **только на 401**.

### Сценарий: accessToken истёк (живёт 15 минут)

Полная цепочка событий:

```
Шаг 1: Приложение → dio.get('/users')
Шаг 2: onRequest добавляет → Authorization: Bearer <старый_accessToken>
Шаг 3: Бекенд проверяет JWT → подпись валидна, но exp < now → 401 Unauthorized
Шаг 4: Dio получает 401 → вызывает onError
```

Внутри `onError`:

```
Шаг 5: Читаем refresh_token из Secure Storage
        → "a3f7b2c9e8d1...64символа" (hex-строка, не JWT)

Шаг 6: Отправляем POST /api/auth/refresh
        Headers: { Authorization: Bearer a3f7b2c9e8d1...64символа }
        Body: пустой
```

**Бекенд отвечает (201):**
```
HTTP/1.1 201 Created
access_token: eyJhbGciOiJIUzI1NiIs...<новый JWT, живёт 15 мин>
refresh_token: b8e2d4a6f1c3...<новые 64 символа>
```

Бекенд реализует **Refresh Token Rotation**: старый refreshToken **уничтожается** в базе, выдаётся новый. Если кто-то перехватит старый — он уже не сработает.

```
Шаг 7: Парсим из ЗАГОЛОВКОВ ответа:
        response.headers.value('access_token') → String (новый JWT)
        response.headers.value('refresh_token') → String (новый hex)

Шаг 8: Сохраняем ОБА в Secure Storage (перезаписываем старые)

Шаг 9: Берём ОРИГИНАЛЬНЫЙ запрос (GET /users), который упал,
        подставляем новый accessToken в его headers

Шаг 10: Повторяем запрос → dio.fetch(retryOptions)
         GET /users с новым Bearer → бекенд отвечает 200 → данные

Шаг 11: handler.resolve(retryResponse)
         → приложение получает ответ КАК БУДТО ошибки не было
```

**Для вызывающего кода это полностью прозрачно** — он вызвал `dio.get('/users')` и получил данные. Он даже не знает, что в середине был 401 и обновление токена.

### Сценарий: refreshToken тоже невалидный

```
Шаг 5: refresh_token = null (нечего отправлять)
        → handler.next(err) — просто прокидываем 401 наверх

ИЛИ

Шаг 6: POST /api/auth/refresh → бекенд отвечает 401
        (refreshToken удалён из базы / протух)

Шаг 7: Ловим DioException →
        clearAll() — удаляем access_token, refresh_token, user_id из storage
        handler.next(err) — прокидываем 401 наверх

Шаг 8: В UI AuthNotifier получает ошибку →
        состояние переходит в AuthError →
        пользователь видит экран логина
```

---

## Что хранится в Secure Storage

| Ключ | Тип | Когда записывается | Когда удаляется |
|---|---|---|---|
| `access_token` | String (JWT) | login / register / refresh | logout / failed refresh |
| `refresh_token` | String (hex 64) | login / register / refresh | logout / failed refresh |
| `user_id` | String (int as string) | login / register | logout / failed refresh |

---

## Визуальная схема

```
┌─────────────┐    onRequest     ┌──────────────┐    HTTP     ┌──────────┐
│ Приложение  │───────────────→ │ + Bearer JWT │──────────→ │  Бекенд  │
│ dio.get()   │                  │  (если не    │             │  NestJS  │
│             │                  │   публичный) │             │          │
└─────────────┘                  └──────────────┘             └──────────┘
       ↑                                                           │
       │                                                      200? │ 401?
       │                                                           │
       │    ┌──────────────────────────────────────────────────────┘
       │    │
       │    ▼ 401
       │  ┌────────────────────────────────────────────┐
       │  │ onError                                    │
       │  │ 1. читаем refresh_token из storage         │
       │  │ 2. POST /refresh (Bearer refresh_token)    │──→ бекенд: новые токены в headers или 401
       │  │ 3. парсим из response.headers              │
       │  │ 4. сохраняем в storage                     │
       │  │ 5. retry оригинального запроса             │
       │  └────────────────────────────────────────────┘
       │         │ успех                  │ неудача
       │         ▼                        ▼
       │    resolve(response)        clearAll() + next(err)
       │    ↓                        ↓
       └── получает данные           получает ошибку → logout
```

---

## Частота вызовов

| Событие | Когда | Частота |
|---|---|---|
| `onRequest` + добавление Bearer | Каждый API-запрос | Постоянно |
| `onError` + refresh | Когда accessToken истёк (15 мин) | ~4 раза в час при активном использовании |
| `clearAll` + разлогин | refreshToken тоже невалиден | Очень редко (logout / серверный сброс сессий) |


## Этап 1: `onRequest` — перехват КАЖДОГО исходящего запроса

Срабатывает **на каждый** `dio.get()`, `dio.post()` и т.д. — до того, как запрос уходит в сеть.

**Пример — запрос списка пользователей:**

```
Приложение вызывает:  dio.get('/users')
```

Интерсептор делает:

1. Смотрит путь запроса (`/users`)
2. Сверяет со списком **публичных** эндпоинтов: `/auth/register`, `/auth/login`
3. `/users` — **не публичный** → идём в `TokenStorage`
4. Читает `accessToken` из secure storage (зашифрованное хранилище Android/iOS)
5. Если токен есть — **вставляет заголовок**:

```
До интерсептора:
  GET /users
  Headers: { Content-Type: application/json }

После интерсептора:
  GET /users
  Headers: { Content-Type: application/json, Authorization: Bearer eyJhbGciOi... }
```

**Пример — логин (публичный путь):**

```
Приложение вызывает:  dio.post('/auth/login', data: {...})
```

1. Путь `/auth/login` **совпадает** с `publicPaths`
2. Токен **не добавляется** → запрос уходит как есть
3. Это правильно, потому что при логине у пользователя ещё нет токена

**Как часто:** Буквально на каждый HTTP-запрос. Вызвал `dio.get(...)` — сработал `onRequest`. Это O(1) операция — одно чтение из storage, одна проверка строки.

---

## Этап 2: `onError` — перехват ответа с ошибкой

Срабатывает только когда бекенд **вернул ошибку**. Интерсептор реагирует **только на 401**.

### Сценарий: accessToken истёк (живёт 15 минут)

Полная цепочка событий:

```
Шаг 1: Приложение → dio.get('/users')
Шаг 2: onRequest добавляет → Authorization: Bearer <старый_accessToken>
Шаг 3: Бекенд проверяет JWT → подпись валидна, но exp < now → 401 Unauthorized
Шаг 4: Dio получает 401 → вызывает onError
```

Внутри `onError`:

```
Шаг 5: Читаем refreshToken из storage
        → "a3f7b2c9e8d1...64символа" (hex-строка, не JWT)

Шаг 6: Отправляем POST /api/auth/refresh
        Headers: { Authorization: Bearer a3f7b2c9e8d1...64символа }
        Body: пустой
```

**Бекенд отвечает (200):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIs...<новый JWT, живёт 15 мин>",
  "refreshToken": "b8e2d4a6f1c3...<новые 64 символа>"
}
```

Бекенд реализует **Refresh Token Rotation**: старый refreshToken **уничтожается** в базе, выдаётся новый. Если кто-то перехватит старый — он уже не сработает.

```
Шаг 7: Парсим ответ:
        response.data['accessToken'] → String (новый JWT)
        response.data['refreshToken'] → String (новый hex)

Шаг 8: Сохраняем ОБА в SecureStorage (перезаписываем старые)

Шаг 9: Берём ОРИГИНАЛЬНЫЙ запрос (GET /users), который упал,
        подставляем новый accessToken в его headers

Шаг 10: Повторяем запрос → dio.fetch(retryOptions)
         GET /users с новым Bearer → бекенд отвечает 200 → данные

Шаг 11: handler.resolve(retryResponse)
         → приложение получает ответ КАК БУДТО ошибки не было
```

**Для вызывающего кода это полностью прозрачно** — он вызвал `dio.get('/users')` и получил список юзеров. Он даже не знает, что в середине был 401 и обновление токена.

### Сценарий: refreshToken тоже невалидный

```
Шаг 5: refreshToken = null (нечего отправлять)
        → handler.next(err) — просто прокидываем 401 наверх

ИЛИ

Шаг 6: POST /api/auth/refresh → бекенд отвечает 401
        (refreshToken удалён из базы / протух)

Шаг 7: Ловим DioException →
        clearAll() — удаляем ОБА токена из storage
        handler.next(err) — прокидываем 401 наверх

Шаг 8: В UI AuthNotifier получает ошибку →
        состояние переходит в AuthError →
        пользователь видит экран логина
```

---

## Визуальная схема

```
┌─────────────┐    onRequest     ┌──────────────┐    HTTP     ┌──────────┐
│ Приложение  │───────────────→ │ + Bearer JWT │──────────→ │  Бекенд  │
│ dio.get()   │                  │  (если не    │             │  NestJS  │
│             │                  │   публичный) │             │          │
└─────────────┘                  └──────────────┘             └──────────┘
       ↑                                                           │
       │                                                      200? │ 401?
       │                                                           │
       │    ┌──────────────────────────────────────────────────────┘
       │    │
       │    ▼ 401
       │  ┌────────────────────┐
       │  │ onError            │
       │  │ 1. читаем refresh  │
       │  │ 2. POST /refresh   │──→ бекенд: новые токены или 401
       │  │ 3. сохраняем       │
       │  │ 4. retry запрос    │
       │  └────────────────────┘
       │         │ успех              │ неудача
       │         ▼                    ▼
       │    resolve(response)    clearAll() + next(err)
       │    ↓                    ↓
       └── получает данные       получает ошибку → logout
```

---

## Частота вызовов

| Событие | Когда | Частота |
|---|---|---|
| `onRequest` + добавление Bearer | Каждый API-запрос | Постоянно |
| `onError` + refresh | Когда accessToken истёк (15 мин) | ~4 раза в час при активном использовании |
| `clearAll` + разлогин | refreshToken тоже невалиден | Очень редко (logout / серверный сброс сессий) |
