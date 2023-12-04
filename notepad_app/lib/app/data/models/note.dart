import 'package:get/get.dart';

class Note {
  int? id;
  final RxString _title;
  final RxString _content;
  int? folderId;

  Note({
    required this.id,
    required String title,
    String content = '',
    this.folderId,
  })  : _title = RxString(title),
        _content = RxString(content);

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      folderId: map['folderId'],
    );
  }

  String get content => _content.value;

  set content(String value) => _content.value = value;

  @override
  int get hashCode => id.hashCode;

  String get title => _title.value;

  set title(String value) => _title.value = value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note && other.id == id;
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'folderId': folderId,
    };
  }
}
