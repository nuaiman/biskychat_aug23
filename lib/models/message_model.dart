import 'dart:convert';

class MessageModel {
  final String key;
  final String sId;
  final String rId;
  final String text;
  final String type;
  final String sendDate;
  bool? read;

  MessageModel({
    required this.key,
    required this.sId,
    required this.rId,
    required this.text,
    required this.type,
    required this.sendDate,
    this.read = false,
  });

  MessageModel copyWith({
    String? key,
    String? sId,
    String? rId,
    String? text,
    String? type,
    String? sendDate,
    bool? read,
  }) {
    return MessageModel(
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
    return 'MessageModel(key: $key, sId: $sId, rId: $rId, text: $text, type: $type, sendDate: $sendDate, read: $read)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModel &&
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
    return key.hashCode ^
        sId.hashCode ^
        rId.hashCode ^
        text.hashCode ^
        type.hashCode ^
        sendDate.hashCode ^
        read.hashCode;
  }
}
