library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CorporateFolder {
  final String id;
  final String name;
  final bool isPrivate;

  const CorporateFolder({
    required this.id,
    required this.name,
    required this.isPrivate,
  });
}

class CorporateFileItem {
  final String id;
  final String folderId;
  final String name;
  final String sizeLabel;
  final DateTime updatedAt;

  const CorporateFileItem({
    required this.id,
    required this.folderId,
    required this.name,
    required this.sizeLabel,
    required this.updatedAt,
  });
}

class CorporateMember {
  final String id;
  final String fullName;
  final String access;

  const CorporateMember({
    required this.id,
    required this.fullName,
    required this.access,
  });
}

class CorporateCloudState {
  final bool hasCorporateAccess;
  final bool isAdmin;
  final String? username;
  final String organizationName;
  final List<CorporateFolder> folders;
  final List<CorporateFileItem> files;
  final List<CorporateMember> members;
  final double storageUsedGb;
  final double storageTotalGb;
  final bool isUploading;
  final double uploadProgress;
  final String? uploadError;

  const CorporateCloudState({
    required this.hasCorporateAccess,
    required this.isAdmin,
    required this.username,
    required this.organizationName,
    required this.folders,
    required this.files,
    required this.members,
    required this.storageUsedGb,
    required this.storageTotalGb,
    required this.isUploading,
    required this.uploadProgress,
    required this.uploadError,
  });

  factory CorporateCloudState.initial() {
    return CorporateCloudState(
      hasCorporateAccess: false,
      isAdmin: false,
      username: null,
      organizationName: 'MTC Demo Company',
      folders: const [
        CorporateFolder(id: 'private', name: 'Private', isPrivate: true),
        CorporateFolder(id: 'corp_docs', name: 'Документы компании', isPrivate: false),
        CorporateFolder(id: 'corp_hr', name: 'HR', isPrivate: false),
      ],
      files: [
        CorporateFileItem(
          id: 'f1',
          folderId: 'private',
          name: 'notes.txt',
          sizeLabel: '24 KB',
          updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        CorporateFileItem(
          id: 'f2',
          folderId: 'corp_docs',
          name: 'onboarding.pdf',
          sizeLabel: '1.2 MB',
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        CorporateFileItem(
          id: 'f3',
          folderId: 'corp_hr',
          name: 'vacation_policy.docx',
          sizeLabel: '670 KB',
          updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
      members: const [
        CorporateMember(id: 'u1', fullName: 'Ирина Смирнова', access: 'read/write'),
        CorporateMember(id: 'u2', fullName: 'Павел Иванов', access: 'read'),
        CorporateMember(id: 'u3', fullName: 'Екатерина Петрова', access: 'read/write/manage'),
      ],
      storageUsedGb: 124.5,
      storageTotalGb: 500,
      isUploading: false,
      uploadProgress: 0,
      uploadError: null,
    );
  }

  CorporateCloudState copyWith({
    bool? hasCorporateAccess,
    bool? isAdmin,
    String? username,
    String? organizationName,
    List<CorporateFolder>? folders,
    List<CorporateFileItem>? files,
    List<CorporateMember>? members,
    double? storageUsedGb,
    double? storageTotalGb,
    bool? isUploading,
    double? uploadProgress,
    String? uploadError,
    bool clearUploadError = false,
  }) {
    return CorporateCloudState(
      hasCorporateAccess: hasCorporateAccess ?? this.hasCorporateAccess,
      isAdmin: isAdmin ?? this.isAdmin,
      username: username ?? this.username,
      organizationName: organizationName ?? this.organizationName,
      folders: folders ?? this.folders,
      files: files ?? this.files,
      members: members ?? this.members,
      storageUsedGb: storageUsedGb ?? this.storageUsedGb,
      storageTotalGb: storageTotalGb ?? this.storageTotalGb,
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      uploadError: clearUploadError ? null : (uploadError ?? this.uploadError),
    );
  }
}

class CorporateCloudNotifier extends StateNotifier<CorporateCloudState> {
  CorporateCloudNotifier() : super(CorporateCloudState.initial());

  void setAuthenticatedUsername(String username) {
    final value = username.toLowerCase();
    final isAdmin = value.contains('admin') || value.contains('manager');
    state = state.copyWith(username: username, isAdmin: isAdmin);
  }

  String? connectByLink({required String link, required String accessKey}) {
    final normalizedLink = link.trim();
    final normalizedKey = accessKey.trim();

    if (normalizedLink.isEmpty || normalizedKey.isEmpty) {
      return 'Заполните ссылку и ключ доступа';
    }

    if (!normalizedLink.startsWith('https://')) {
      return 'Ссылка должна начинаться с https://';
    }

    if (normalizedKey.length < 4) {
      return 'Ключ доступа слишком короткий';
    }

    state = state.copyWith(hasCorporateAccess: true);
    return null;
  }

  Future<void> uploadFiles(List<String> fileNames) async {
    if (fileNames.isEmpty) return;

    state = state.copyWith(
      isUploading: true,
      uploadProgress: 0,
      clearUploadError: true,
    );

    for (int i = 1; i <= 10; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      state = state.copyWith(uploadProgress: i / 10);
    }

    final now = DateTime.now();
    final addedFiles = fileNames
        .asMap()
        .entries
        .map(
          (entry) => CorporateFileItem(
            id: 'new_${now.microsecondsSinceEpoch}_${entry.key}',
            folderId: 'private',
            name: entry.value,
            sizeLabel: '—',
            updatedAt: now,
          ),
        )
        .toList();

    state = state.copyWith(
      files: [...addedFiles, ...state.files],
      isUploading: false,
      uploadProgress: 1,
      storageUsedGb: state.storageUsedGb + (0.01 * fileNames.length),
    );
  }

  void setUploadError(String message) {
    state = state.copyWith(isUploading: false, uploadProgress: 0, uploadError: message);
  }

  void clearUploadError() {
    state = state.copyWith(clearUploadError: true);
  }

  Future<void> retryLastUpload() async {
    if (state.uploadError == null) return;
    state = state.copyWith(clearUploadError: true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }

  void logoutCleanup() {
    state = CorporateCloudState.initial();
  }
}

final corporateCloudProvider =
    StateNotifierProvider<CorporateCloudNotifier, CorporateCloudState>((ref) {
      return CorporateCloudNotifier();
    });
