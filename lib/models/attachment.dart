import 'dart:typed_data';

enum AttachmentType {
  image,
  document,
  text,
  pdf,
  unknown
}

class Attachment {
  final String id;
  final String name;
  final AttachmentType type;
  final int size;
  final Uint8List? data;
  final String? textContent;

  Attachment({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    this.data,
    this.textContent,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'size': size,
      'data': data,
      'textContent': textContent,
    };
  }

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      name: json['name'],
      type: AttachmentType.values.firstWhere((e) => e.toString() == json['type']),
      size: json['size'],
      data: json['data'],
      textContent: json['textContent'],
    );
  }
}