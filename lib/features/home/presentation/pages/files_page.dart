library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/corporate_cloud_stub_provider.dart';

class FilesPage extends ConsumerWidget {
  const FilesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(corporateCloudProvider);
    final folders = state.folders;
    final files = state.files;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        const SizedBox(height: 4),
        Text(
          'Файлы',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          state.organizationName,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 14),
        ...folders.map((folder) {
          final folderFiles = files.where((f) => f.folderId == folder.id).toList();
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              initiallyExpanded: folder.isPrivate,
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: Icon(folder.isPrivate ? Icons.lock_rounded : Icons.folder_rounded),
              title: Text(folder.name),
              subtitle: Text('${folderFiles.length} файлов'),
              children: [
                const Divider(height: 1),
                if (folderFiles.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Папка пока пустая'),
                  )
                else
                  ...folderFiles.map(
                    (file) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      leading: const Icon(
                        Icons.insert_drive_file_outlined,
                        size: 20,
                      ),
                      title: Text(file.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                        '${file.sizeLabel} • ${_formatDate(file.updatedAt)}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hour:$minute';
  }
}
