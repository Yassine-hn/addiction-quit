import 'package:flutter/material.dart';
import '../models/post_model.dart';

class CommunityPost extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onLike;
  final VoidCallback? onRefresh;

  const CommunityPost({
    super.key,
    required this.post,
    this.onLike,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          Text(
            post.content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInteractionButton(
                post.isLikedByUser ? Icons.thumb_up : Icons.thumb_up_outlined,
                post.likes,
                const Color(0xFF00A3E0),
                onTap: onLike,
              ),
              const SizedBox(width: 24),
              _buildInteractionButton(
                Icons.chat_bubble_outline,
                post.comments,
                Colors.grey[600]!,
                onTap: null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(post.authorImage),
          backgroundColor: Colors.grey[300],
          onBackgroundImageError: (exception, stackTrace) {},
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: Icon(Icons.person, color: Colors.grey[600], size: 24),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    post.authorName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (post.badge != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4F8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        post.badge!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00A3E0),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                post.timeAgo,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Icon(Icons.more_horiz, color: Colors.grey[600]),
      ],
    );
  }

  Widget _buildInteractionButton(
    IconData icon,
    int count,
    Color color, {
    VoidCallback? onTap,
  }) {
    final button = Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 6),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: button,
      );
    }

    return button;
  }
}
