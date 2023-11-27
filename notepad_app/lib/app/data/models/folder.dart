class MFolder {
  int? id;
  String title;
  int userId;
  int? parentId;

  MFolder({
    required this.id,
    required this.title,
    required this.parentId,
    required this.userId,
  });

  factory MFolder.fromMap(Map<String, dynamic> map) => MFolder(
        id: map['id'],
        title: map['title'],
        parentId: map['parentId'],
        userId: map['userId'],
      );

  @override
  int get hashCode {
    int prime = 31;
    int result = 1;
    result = prime * result + id.hashCode;
    result = prime * result + title.hashCode;
    result = prime * result + userId.hashCode;
    result = prime * result + (parentId?.hashCode ?? 0);
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MFolder && other.id == id;
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'userId': userId,
      if (parentId != null) 'parentId': parentId,
    };
  }
}
