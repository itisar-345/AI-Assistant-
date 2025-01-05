import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:uuid/uuid.dart';
import '../models/attachment.dart';

class FileService {
  final _uuid = const Uuid();

  Future<List<Attachment>> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
      withData: true,
    );

    if (result == null) return [];

    List<Attachment> attachments = [];
    for (var file in result.files) {
      if (file.bytes == null) continue;

      final attachment = await _processFile(file);
      if (attachment != null) {
        attachments.add(attachment);
      }
    }

    return attachments;
  }

  Future<Attachment?> _processFile(PlatformFile file) async {
    final mimeType = lookupMimeType(file.name, headerBytes: file.bytes);
    final type = _getAttachmentType(mimeType);
    
    String? textContent;
    
    if (type == AttachmentType.pdf) {
      try {
        final pdfDoc = await PDFDoc.fromFile(file.bytes! as File);
        textContent = await pdfDoc.text;
      } catch (e) {
        return null;
      }
    } else if (type == AttachmentType.text) {
      textContent = String.fromCharCodes(file.bytes!);
    }

    return Attachment(
      id: _uuid.v4(),
      name: file.name,
      type: type,
      size: file.size,
      data: file.bytes,
      textContent: textContent,
    );
  }

  AttachmentType _getAttachmentType(String? mimeType) {
    if (mimeType == null) return AttachmentType.unknown;
    
    if (mimeType.startsWith('image/')) {
      return AttachmentType.image;
    } else if (mimeType.startsWith('text/')) {
      return AttachmentType.text;
    } else if (mimeType == 'application/pdf') {
      return AttachmentType.pdf;
    } else if (mimeType.contains('document') || 
              mimeType.contains('sheet') ||
              mimeType.contains('presentation')) {
      return AttachmentType.document;
    }
    
    return AttachmentType.unknown;
  }
}