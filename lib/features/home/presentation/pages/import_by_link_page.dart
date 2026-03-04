/// 1) Общее назначение:
///    Экран подключения к корпоративному облаку по ссылке и ключу доступа.
///    Является обязательным шлюзом после авторизации до перехода на HomePage.
/// 2) С какими файлами связан:
///    - corporate_cloud_stub_provider.dart (вызов connectByLink(), чтение hasCorporateAccess).
///    - home_page.dart (переход после успешного подключения).
///    - Инициируется из main.dart (AuthGate) и more_page.dart.
/// 3) Описание функций:
///    - _submit(): валидирует поля, вызывает connectByLink(), переходит на HomePage или показывает SnackBar с ошибкой.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/corporate_cloud_stub_provider.dart';
import 'home_page.dart';

class ImportByLinkPage extends ConsumerStatefulWidget {
  const ImportByLinkPage({super.key});

  @override
  ConsumerState<ImportByLinkPage> createState() => _ImportByLinkPageState();
}

class _ImportByLinkPageState extends ConsumerState<ImportByLinkPage> {
  final _linkController = TextEditingController();
  final _keyController = TextEditingController();

  @override
  void dispose() {
    _linkController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  void _submit() {
    final error = ref
        .read(corporateCloudProvider.notifier)
        .connectByLink(link: _linkController.text, accessKey: _keyController.text);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red.shade700),
      );
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.link_rounded, color: colorScheme.primary, size: 28),
                          const SizedBox(height: 8),
                          Text(
                            'Импорт в корпоративное облако',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _linkController,
                        decoration: const InputDecoration(
                          labelText: 'Уникальная ссылка',
                          hintText: 'https://corp.mtc.cloud/invite/abc',
                        ),
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _keyController,
                        decoration: const InputDecoration(
                          labelText: 'Ключ доступа',
                          hintText: 'Введите ключ',
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 18),
                      FilledButton(
                        onPressed: _submit,
                        child: const Text('Подключиться'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Если ключ не подходит, запросите новый у менеджера.',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
