library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/corporate_cloud_stub_provider.dart';

class AdminPanelPage extends ConsumerWidget {
  const AdminPanelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(corporateCloudProvider);
    final usagePercent = (state.storageUsedGb / state.storageTotalGb * 100).clamp(0, 100);

    return Scaffold(
      appBar: AppBar(title: const Text('Панель администратора')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Заполненность хранилища'),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: usagePercent / 100),
                  const SizedBox(height: 8),
                  Text('${state.storageUsedGb.toStringAsFixed(1)} GB / ${state.storageTotalGb.toStringAsFixed(0)} GB • ${usagePercent.toStringAsFixed(1)}%'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.analytics_outlined),
              title: const Text('Статистика использования'),
              subtitle: Text('Папок: ${state.folders.length}, файлов: ${state.files.length}'),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Пользователи и права',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...state.members.map(
            (member) => Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person_outline_rounded)),
                title: Text(member.fullName),
                subtitle: Text('Доступ: ${member.access}'),
                trailing: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Изменить'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
