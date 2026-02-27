# Server Configuration Summary (as of Feb 26, 2026)

This document provides a comprehensive overview of the current server setup. It is intended for AI agents to understand the infrastructure context for deployment and automation.

---

## 1. General Info

- **Provider:** DigitalOcean Droplet (FRA1 - Frankfurt).
- **IP:** 159.89.30.73.
- **Hostname:** `kurumisoft`.
- **OS:** Ubuntu 24.04.4 LTS (x86_64).
- **Specs:** 2 GB RAM, 2 vCPU, 60 GB SSD.
- **Access:** Root access via SSH (ID_ED25519 key with passphrase).

## 2. Domain & DNS

- **Domain:** `kurumi.software` (via name.com).
- **Nameservers:** Standard name.com NS.
- **Records:**
  - `A` record for `kurumi.software` points to `159.89.30.73`.
  - `A` record for `www.kurumi.software` points to `159.89.30.73`.

## 3. SSL/TLS

- **Provider:** Let's Encrypt (Certbot).
- **Status:** Active for `kurumi.software` and `www.kurumi.software`.
- **Paths:**
  - Cert: `/etc/letsencrypt/live/kurumi.software/fullchain.pem`
  - Key: `/etc/letsencrypt/live/kurumi.software/privkey.pem`
- **Auto-renewal:** Configured via cron.

## 4. Software Stack

- **Nginx:** v1.24.0 (Active, serves as a Reverse Proxy).
- **Docker:** v29.2.1 (Active).
- **Docker Compose:** v5.1.0.
- **Node.js Environment:** Ready for NestJS deployment via Docker.

## 5. Firewall (UFW)

- **Status:** Active.
- **Open Ports:**
  - `22/tcp` (SSH)
  - `80/tcp` (HTTP -> HTTPS Redirect)
  - `443/tcp` (HTTPS / HTTP2)

## 6. Nginx Reverse Proxy Logic

- **Root (`/`)**: Currently serves a Frontend placeholder.
- **API (`/api/`)**: Currently serves an API placeholder.
- **Target Configuration:** Planned to `proxy_pass` to `http://127.0.0.1:3000` (NestJS container).

## 7. Current Workflow

1. Request arrives at `https://kurumi.software`.
2. Nginx terminates SSL.
3. Nginx routes traffic to the appropriate container or placeholder.
4. Docker Compose manages the lifecycle of the Backend and Database.

Полное подытоживание конфигурации сервера на 26 февраля 2026 года
Вот полный и детальный обзор текущей настройки твоего сервера на основе всех шагов, которые мы прошли. Это включает домен, DNS, ОС, установленные пакеты, firewall, SSL, nginx-конфиг, Docker и другие аспекты. Сервер настроен для базового деплоя веб-приложения (фронт + бек на /api) с HTTPS, но пока с placeholder'ами — готов к реальному NestJS + PostgreSQL в Docker. Я структурировал для удобства, чтобы ты мог скопировать и передать другой ИИ (например, для автоматизации деплоя).

1. Общая информация о сервере

Провайдер: DigitalOcean Droplet (регион FRA1 — Frankfurt, Германия).
IP-адрес: 159.89.30.73 (публичный IPv4).
Hostname: kurumisoft (можно изменить в /etc/hostname и /etc/hosts).
ОС: Ubuntu 24.04.4 LTS (x86_64, kernel 6.8.0-71-generic, требуется reboot для обновлений — см. "System restart required").
Ресурсы: 2 GB RAM, 1 vCPU (или 2 — уточни в панели DO), 60 GB SSD.
Доступ: SSH как root (по ключу или паролю — ты использовал passphrase для id_ed25519). Нет отдельного non-root пользователя (рекомендую добавить для безопасности).
Статус: Активен, нагрузка низкая (System load: 0.0, Memory: ~17%, нет контейнеров/процессов в нагрузке).
Мониторинг: Включён в DO (бесплатно), смотри в панели.

2. Домен и DNS

Домен: kurumi.software (зарегистрирован в name.com, renews 26 Feb 2027, WHOIS Privacy ON, Transfer Locked).
Nameservers: Дефолтные name.com (ns1.name.com, ns2.name.com, ns3.name.com, ns4.name.com) — управляются в name.com.
Ты добавил домен в DigitalOcean Networking, но NS не изменил, так что DO DNS не активен (только placeholder NS-записи в DO, не применяются). Если хочешь перейти — смени NS в name.com на ns1/2/3.digitalocean.com.

DNS-записи (в name.com Manage DNS Records):
Type: A, Host: kurumi.software (или @), Answer: 159.89.30.73, TTL: 300.
Type: A, Host: www.kurumi.software, Answer: 159.89.30.73, TTL: 300.
Нет поддоменов (например, api.) — всё через /api на основном домене.

Работа домена:
https://kurumi.software и https://www.kurumi.software перенаправляют на сервер (HTTP → HTTPS редирект).
Propagation: Полное (проверено dig/nmap), но если меняешь — жди 5–60 мин.

Дополнительно в DO: Домен добавлен в Networking, но без активных записей (только NS на DO, не используются). Можно удалить, если не планируешь переход.

3. SSL-сертификат

Провайдер: Let's Encrypt (бесплатный DV сертификат).
Действует для: kurumi.software и www.kurumi.software.
Expires: 2026-05-27 (автообновление через certbot каждые 60–90 дней, cron настроен).
Файлы:
Fullchain: /etc/letsencrypt/live/kurumi.software/fullchain.pem
Privkey: /etc/letsencrypt/live/kurumi.software/privkey.pem
Опции: /etc/letsencrypt/options-ssl-nginx.conf, ssl-dhparams.pem

Настройка: Certbot интегрирован с nginx, редирект HTTP → HTTPS автоматический.
Логи: /var/log/letsencrypt/letsencrypt.log (если проблемы — смотри там).

4. Установленные пакеты и сервисы

Базовые: apt update/upgrade выполнено, 153 пакета обновлены (включая kernel 6.8.0-101-generic — reboot required).
Nginx: v1.24.0-2ubuntu7.6 (active, enabled).
Certbot: v2.9.0-1 (с python3-certbot-nginx).
Docker: v29.2.1 (official repo, active после reset-failed), с containerd.io, buildx-plugin, compose-plugin v5.1.0.
Логи: journalctl -u docker — нормальные (warnings по nftables не критичны).
Группа: root добавлен в docker (newgrp применён).

Другие: ufw (firewall), fail2ban не установлен (рекомендую для SSH-защиты), htop/glances не установлены.
Обновления: unattended-upgrades не настроен, но можно добавить.
Нет: Separate user (всё под root), pm2 (если NestJS не в Docker), PostgreSQL standalone (будет в Docker).

5. Firewall (UFW)

Статус: Active (logging on low, default: deny incoming, allow outgoing, routed disabled).
Разрешённые порты (ufw status verbose):
22/tcp (OpenSSH): ALLOW IN Anywhere (и v6).
80/tcp (HTTP): ALLOW IN Anywhere (и v6).
443/tcp (HTTPS): ALLOW IN Anywhere (и v6).

Дополнительно: DigitalOcean Cloud Firewall — проверь в панели Networking → Firewalls (если включён — добавь SSH/HTTP/HTTPS отовсюду; по умолчанию выключен).
Рекомендация: Для Docker-портов (например, 3000 для NestJS, 5432 для Postgres) — не открывай снаружи, используй localhost или nginx proxy. Если нужно — ufw allow PORT/tcp && ufw reload.

6. Nginx конфигурация

Версия: 1.24.0.
Статус: Active, listens on 80/443 (HTTP2 on).
Конфиг файлы:
Основной: /etc/nginx/nginx.conf (стандартный).
Sites: /etc/nginx/sites-available/kurumi (активен через symlink в sites-enabled).
Default удалён.

Ключевой конфиг (/etc/nginx/sites-available/kurumi):text# HTTP → HTTPS редирект
server {
listen 80;
listen [::]:80;
server_name kurumi.software www.kurumi.software;
return 301 https://$host$request_uri;
}

# HTTPS сервер

server {
listen 443 ssl http2;
listen [::]:443 ssl http2;
server_name kurumi.software www.kurumi.software;

    ssl_certificate /etc/letsencrypt/live/kurumi.software/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/kurumi.software/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    if ($host = 'www.kurumi.software') {
        return 301 https://kurumi.software$request_uri;
    }

    location / {
        return 200 "Frontend placeholder — скоро будет сайт!\n";
        add_header Content-Type text/plain;
        # Для реального фронта: root /var/www/kurumi/frontend/dist; try_files $uri $uri/ /index.html;
    }

    location /api/ {
        return 200 "API placeholder — бекенд готов к подключению!\n";
        add_header Content-Type text/plain;
        # Для реального NestJS: proxy_pass http://127.0.0.1:3000/; + headers (Upgrade, Host, X-Real-IP и т.д.)
    }

    location ~ /\. {
        deny all;
    }

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options SAMEORIGIN;
    add_header X-XSS-Protection "1; mode=block";
    add_header Referrer-Policy strict-origin-when-cross-origin;

}
Работа:
/ → Frontend placeholder (замени на статический build).
/api/ → API placeholder (замени на proxy к NestJS:3000).
Безопасные заголовки включены.

Проверка: nginx -t (OK), reload через systemctl.
Логи: /var/log/nginx/access.log и error.log.

7. Docker и контейнеры

Версия: Docker 29.2.1, Compose v5.1.0 (плагин).
Статус: Active, daemon running, /run/docker.sock слушает.
Контейнеры: Нет активных (docker ps пустой).
Рекомендация: Создай docker-compose.yml в ~/myproject (пример выше), up -d --build. Открой порты только если нужно (например, 3000 для теста: ufw allow 3000/tcp).
Volumes/Networks: Стандартные, нет кастомных.

8. Безопасность и улучшения

SSH: Разрешён (22), но под root — риски (добавь user + ключи).
Fail2Ban: Не установлен (рекомендую: apt install fail2ban -y, enable).
Бэкапы: Нет (настрой cron для /etc, /var/www, Docker volumes).
Мониторинг: htop не установлен (apt install htop -y).
Обновления: Требуется reboot (kernel update), после — apt upgrade.

9. Как работает весь стек сейчас

Запрос на https://kurumi.software → Nginx → HTTPS → Placeholder для фронта.
https://kurumi.software/api/ → Placeholder для бека.
Docker готов для NestJS + Postgres: build из Dockerfile, proxy в nginx на localhost:3000.
Всё на одном домене (без поддоменов), масштабируемо (добавь порты/контейнеры по мере нужды).
