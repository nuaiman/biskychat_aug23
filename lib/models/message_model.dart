import 'dart:convert';

class MessageModel {
  final String id;
  final String key;
  final String sId;
  final String rId;
  final String text;
  final String type;
  final String sendDate;
  bool? read;

  MessageModel({
    required this.id,
    required this.key,
    required this.sId,
    required this.rId,
    required this.text,
    required this.type,
    required this.sendDate,
    this.read = false,
  });

  MessageModel copyWith({
    String? id,
    String? key,
    String? sId,
    String? rId,
    String? text,
    String? type,
    String? sendDate,
    bool? read,
  }) {
    return MessageModel(
      id: id ?? this.id,
      key: key ?? this.key,
      sId: sId ?? this.sId,
      rId: rId ?? this.rId,
      text: text ?? this.text,
      type: type ?? this.type,
      sendDate: sendDate ?? this.sendDate,
      read: read ?? this.read,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'key': key});
    result.addAll({'sId': sId});
    result.addAll({'rId': rId});
    result.addAll({'text': text});
    result.addAll({'type': type});
    result.addAll({'sendDate': sendDate});
    if (read != null) {
      result.addAll({'read': read});
    }

    return result;
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      key: map['key'] ?? '',
      sId: map['sId'] ?? '',
      rId: map['rId'] ?? '',
      text: map['text'] ?? '',
      type: map['type'] ?? '',
      sendDate: map['sendDate'] ?? '',
      read: map['read'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MessageModel(id: $id, key: $key, sId: $sId, rId: $rId, text: $text, type: $type, sendDate: $sendDate, read: $read)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModel &&
        other.id == id &&
        other.key == key &&
        other.sId == sId &&
        other.rId == rId &&
        other.text == text &&
        other.type == type &&
        other.sendDate == sendDate &&
        other.read == read;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        key.hashCode ^
        sId.hashCode ^
        rId.hashCode ^
        text.hashCode ^
        type.hashCode ^
        sendDate.hashCode ^
        read.hashCode;
  }
}
