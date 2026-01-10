class PostModel {
  final int? id;
  final String authorName;
  final String authorImage;
  final String timeAgo;
  final String content;
  final int likes;
  final int comments;
  final String? badge;
  final bool isLikedByUser;

  const PostModel({
    this.id,
    required this.authorName,
    required this.authorImage,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
    this.badge,
    this.isLikedByUser = false,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      authorName: map['authorName'] ?? map['author_name'] ?? '',
      authorImage: map['authorImage'] ?? map['author_image'] ?? '',
      timeAgo: map['timeAgo'] ?? map['time_ago'] ?? '',
      content: map['content'] ?? '',
      likes: map['likes'] ?? map['reaction_count'] ?? 0,
      comments: map['comments'] ?? map['comment_count'] ?? 0,
      badge: map['badge'],
      isLikedByUser: map['isLikedByUser'] == 1 || map['isLikedByUser'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'authorName': authorName,
      'authorImage': authorImage,
      'timeAgo': timeAgo,
      'content': content,
      'likes': likes,
      'comments': comments,
      'badge': badge,
      'isLikedByUser': isLikedByUser ? 1 : 0,
    };
  }

  PostModel copyWith({
    int? id,
    String? authorName,
    String? authorImage,
    String? timeAgo,
    String? content,
    int? likes,
    int? comments,
    String? badge,
    bool? isLikedByUser,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorImage: authorImage ?? this.authorImage,
      timeAgo: timeAgo ?? this.timeAgo,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      badge: badge ?? this.badge,
      isLikedByUser: isLikedByUser ?? this.isLikedByUser,
    );
  }
}
