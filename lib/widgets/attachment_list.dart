import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attachment.dart';
import '../providers/file_provider.dart';

class AttachmentList extends ConsumerWidget {
  const AttachmentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attachments = ref.watch(attachmentsProvider);

    if (attachments.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        itemBuilder: (context, index) {
          return AttachmentChip(attachment: attachments[index]);
        },
      ),
    );
  }
}

class AttachmentChip extends ConsumerWidget {
  final Attachment attachment;

  const AttachmentChip({
    super.key,
    required this.attachment,
  });

  IconData _getIcon() {
    switch (attachment.type) {
      case AttachmentType.image:
        return Icons.image;
      case AttachmentType.document:
        return Icons.description;
      case AttachmentType.text:
        return Icons.text_snippet;
      case AttachmentType.pdf:
        return Icons.picture_as_pdf;
      case AttachmentType.unknown:
        return Icons.attach_file;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        avatar: Icon(_getIcon(), size: 18),
        label: Text(attachment.name),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: () {
          ref.read(attachmentsProvider.notifier).removeAttachment(attachment.id);
        },
      ),
    );
  }
}