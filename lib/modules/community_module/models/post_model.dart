class PostModel {
  final String authorName;
  final String authorImage;
  final String timeAgo;
  final String content;
  final int likes;
  final int comments;
  final String? badge;

  const PostModel({
    required this.authorName,
    required this.authorImage,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
    this.badge,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      authorName: map['authorName'] ?? '',
      authorImage: map['authorImage'] ?? '',
      timeAgo: map['timeAgo'] ?? '',
      content: map['content'] ?? '',
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
      badge: map['badge'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorName': authorName,
      'authorImage': authorImage,
      'timeAgo': timeAgo,
      'content': content,
      'likes': likes,
      'comments': comments,
      'badge': badge,
    };
  }
}
