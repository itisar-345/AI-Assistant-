import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attachment.dart';
import '../services/file_service.dart';

final fileServiceProvider = Provider((ref) => FileService());

final attachmentsProvider = StateNotifierProvider<AttachmentsNotifier, List<Attachment>>((ref) {
  return AttachmentsNotifier();
});

class AttachmentsNotifier extends StateNotifier<List<Attachment>> {
  AttachmentsNotifier() : super([]);

  void addAttachments(List<Attachment> attachments) {
    state = [...state, ...attachments];
  }

  void removeAttachment(String id) {
    state = state.where((attachment) => attachment.id != id).toList();
  }

  void clearAttachments() {
    state = [];
  }
}