import 'package:flutter/material.dart'; // this should be in community_widgets.dart
import '../widgets/useful_widgets.dart'; // this should be in community_screen.dart









// ============================================================================
// community_repository.dart
// ============================================================================

// Abstract class defining the contract
abstract class CommunityRepository {
  Future<List<Map<String, dynamic>>> fetchHeroesOfWeek();
  Future<List<Map<String, dynamic>>> fetchCommunityPosts();
  Future<bool> createPost({
    required String content,
    required bool isAnonymous,
  });
  Future<bool> likePost(String postId);
  Future<bool> commentOnPost({
    required String postId,
    required String comment,
  });
  Future<bool> deletePost(String postId);
  Future<bool> reportPost(String postId, String reason);
}

// Implementation with dummy data
class CommunityRepositoryImpl implements CommunityRepository {
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<Map<String, dynamic>>> fetchHeroesOfWeek() async {
    await _simulateDelay();
    return [
      {'name': 'Maria', 'days': 42, 'imageUrl': 'assets/images/maria.jpg'},
      {'name': 'David', 'days': 85, 'imageUrl': 'assets/images/david.jpg'},
      {'name': 'Sophie', 'days': 61, 'imageUrl': 'assets/images/sophie.jpg'},
      {'name': 'Chen', 'days': 76, 'imageUrl': 'assets/images/chen.jpg'},
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> fetchCommunityPosts() async {
    await _simulateDelay();
    return [
      {
        'authorName': 'Dr. Emily Carter',
        'authorImage': 'assets/images/emily.jpg',
        'timeAgo': '2 hours ago',
        'content': 'Remember that recovery is a journey, not a destination. Each step, no matter how small, is a victory. Be kind to yourself today. #Motivation #ExpertAdvice',
        'likes': 125,
        'comments': 18,
        'badge': 'Expert',
      },
      {
        'authorName': 'John S.',
        'authorImage': 'assets/images/john.jpg',
        'timeAgo': '7 hours ago',
        'content': 'Just hit my 30-day milestone. It\'s been tough, but this community has been a huge help. Thank you all for the support. We can do this!',
        'likes': 247,
        'comments': 42,
        'badge': null,
      },
      {
        'authorName': 'Sarah K.',
        'authorImage': 'assets/images/sarah.jpg',
        'timeAgo': '1 day ago',
        'content': 'Feeling a bit down today, but reading everyone\'s stories is really inspiring. Does anyone have tips for dealing with cravings in social situations?',
        'likes': 98,
        'comments': 27,
        'badge': null,
      },
    ];
  }

  @override
  Future<bool> createPost({required String content, required bool isAnonymous}) async {
    await _simulateDelay();
    return true;
  }

  @override
  Future<bool> likePost(String postId) async {
    await _simulateDelay();
    return true;
  }

  @override
  Future<bool> commentOnPost({required String postId, required String comment}) async {
    await _simulateDelay();
    return true;
  }

  @override
  Future<bool> deletePost(String postId) async {
    await _simulateDelay();
    return true;
  }

  @override
  Future<bool> reportPost(String postId, String reason) async {
    await _simulateDelay();
    return true;
  }
}

// ============================================================================
// community_backend_functions.dart
// ============================================================================

final CommunityRepository _communityRepository = CommunityRepositoryImpl();

Future<List<Map<String, dynamic>>> getHeroesOfWeek() async {
  try {
    return await _communityRepository.fetchHeroesOfWeek();
  } catch (e) {
    return getDefaultHeroes();
  }
}

Future<List<Map<String, dynamic>>> getCommunityPosts() async {
  try {
    return await _communityRepository.fetchCommunityPosts();
  } catch (e) {
    return getDefaultPosts();
  }
}

Future<bool> createPost({required String content, required bool isAnonymous}) async {
  try {
    return await _communityRepository.createPost(content: content, isAnonymous: isAnonymous);
  } catch (e) {
    return false;
  }
}

Future<bool> likePost(String postId) async {
  try {
    return await _communityRepository.likePost(postId);
  } catch (e) {
    return false;
  }
}

Future<bool> commentOnPost({required String postId, required String comment}) async {
  try {
    return await _communityRepository.commentOnPost(postId: postId, comment: comment);
  } catch (e) {
    return false;
  }
}

List<Map<String, dynamic>> getDefaultHeroes() {
  return [
    {'name': 'Maria', 'days': 42, 'imageUrl': 'assets/images/maria.jpg'},
    {'name': 'David', 'days': 85, 'imageUrl': 'assets/images/david.jpg'},
    {'name': 'Sophie', 'days': 61, 'imageUrl': 'assets/images/sophie.jpg'},
    {'name': 'Chen', 'days': 76, 'imageUrl': 'assets/images/chen.jpg'},
  ];
}

List<Map<String, dynamic>> getDefaultPosts() {
  return [
    {
      'authorName': 'Dr. Emily Carter',
      'authorImage': 'assets/images/emily.jpg',
      'timeAgo': '2 hours ago',
      'content': 'Remember that recovery is a journey, not a destination. Each step, no matter how small, is a victory. Be kind to yourself today. #Motivation #ExpertAdvice',
      'likes': 125,
      'comments': 18,
      'badge': 'Expert',
    },
    {
      'authorName': 'John S.',
      'authorImage': 'assets/images/john.jpg',
      'timeAgo': '7 hours ago',
      'content': 'Just hit my 30-day milestone. It\'s been tough, but this community has been a huge help. Thank you all for the support. We can do this!',
      'likes': 247,
      'comments': 42,
      'badge': null,
    },
    {
      'authorName': 'Sarah K.',
      'authorImage': 'assets/images/sarah.jpg',
      'timeAgo': '1 day ago',
      'content': 'Feeling a bit down today, but reading everyone\'s stories is really inspiring. Does anyone have tips for dealing with cravings in social situations?',
      'likes': 98,
      'comments': 27,
      'badge': null,
    },
  ];
}

// ============================================================================
// community_widgets.dart
// ============================================================================

// import 'package:flutter/material.dart';

class HeroCard extends StatelessWidget {
  final String name;
  final int days;
  final String imageUrl;

  const HeroCard({
    super.key,
    required this.name,
    required this.days,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF00A3E0), width: 3),
                ),
                child: ClipOval(
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.person, size: 32, color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFC107),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text('$days Days', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

class CommunityPost extends StatelessWidget {
  final String authorName;
  final String authorImage;
  final String timeAgo;
  final String content;
  final int likes;
  final int comments;
  final String? badge;

  const CommunityPost({
    super.key,
    required this.authorName,
    required this.authorImage,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
    this.badge,
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
          Text(content, style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInteractionButton(Icons.thumb_up_outlined, likes, const Color(0xFF00A3E0)),
              const SizedBox(width: 24),
              _buildInteractionButton(Icons.chat_bubble_outline, comments, Colors.grey[600]!),
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
          backgroundImage: AssetImage(authorImage),
          backgroundColor: Colors.grey[300],
          onBackgroundImageError: (exception, stackTrace) {},
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[300]),
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
                    authorName,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4F8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF00A3E0)),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(timeAgo, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            ],
          ),
        ),
        Icon(Icons.more_horiz, color: Colors.grey[600]),
      ],
    );
  }

  Widget _buildInteractionButton(IconData icon, int count, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 6),
        Text(count.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
      ],
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomFloatingActionButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed ?? () {},
      backgroundColor: const Color(0xFF00A3E0),
      elevation: 4,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}

// ============================================================================
// community_screen.dart
// ============================================================================

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroesSection(),
                    const SizedBox(height: 16),
                    _buildPostsList(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        activeIndex: 3
        ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          Icon(Icons.people, color: Colors.grey[800], size: 28),
          const SizedBox(width: 12),
          const Text(
            'Community',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroesSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getHeroesOfWeek(),
      builder: (context, snapshot) {
        final heroes = snapshot.data ?? getDefaultHeroes();

        return Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 20, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Heroes of the Week',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 115,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: heroes.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final hero = heroes[index];
                    return HeroCard(
                      name: hero['name'],
                      days: hero['days'],
                      imageUrl: hero['imageUrl'],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostsList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getCommunityPosts(),
      builder: (context, snapshot) {
        final posts = snapshot.data ?? getDefaultPosts();

        return Column(
          children: posts.map((post) {
            return Column(
              children: [
                CommunityPost(
                  authorName: post['authorName'],
                  authorImage: post['authorImage'],
                  timeAgo: post['timeAgo'],
                  content: post['content'],
                  likes: post['likes'],
                  comments: post['comments'],
                  badge: post['badge'],
                ),
                const SizedBox(height: 8),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

// ============================================================================
// create_post_screen.dart
// ============================================================================

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postController = TextEditingController();
  bool _isAnonymous = false;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Post',
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: _postController.text.isEmpty ? null : () => _publishPost(),
            child: Text(
              'Post',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _postController.text.isEmpty ? Colors.grey[400] : const Color(0xFF00A3E0),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Divider(height: 1, color: Colors.grey[300]),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserInfo(),
                    const SizedBox(height: 20),
                    _buildPostInput(),
                    const SizedBox(height: 24),
                    _buildAnonymousToggle(),
                    const SizedBox(height: 24),
                    _buildSuggestions(),
                  ],
                ),
              ),
            ),
            _buildBottomToolbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFFE8F4F8),
          child: Icon(
            _isAnonymous ? Icons.person_outline : Icons.person,
            color: const Color(0xFF00A3E0),
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isAnonymous ? 'Anonymous' : 'Alex',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            Text('Posting to Community', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }

  Widget _buildPostInput() {
    return TextField(
      controller: _postController,
      maxLines: null,
      minLines: 8,
      autofocus: true,
      onChanged: (value) => setState(() {}),
      style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
      decoration: InputDecoration(
        hintText: 'Share your thoughts, experiences, or ask for support...',
        hintStyle: TextStyle(fontSize: 16, color: Colors.grey[400], height: 1.5),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildAnonymousToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.visibility_off_outlined, color: Colors.grey[700], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Post anonymously',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Text('Your identity will be hidden', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
          Switch(
            value: _isAnonymous,
            onChanged: (value) => setState(() => _isAnonymous = value),
            activeColor: const Color(0xFF00A3E0),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular topics',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['#Motivation', '#Support', '#Milestone', '#Tips', '#Question']
              .map((topic) => _buildTopicChip(topic))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTopicChip(String topic) {
    return GestureDetector(
      onTap: () {
        _postController.text = '${_postController.text} $topic ';
        _postController.selection = TextSelection.fromPosition(
          TextPosition(offset: _postController.text.length),
        );
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F4F8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00A3E0).withOpacity(0.3)),
        ),
        child: Text(
          topic,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF00A3E0)),
        ),
      ),
    );
  }

  Widget _buildBottomToolbar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildToolbarButton(Icons.image_outlined, 'Photo'),
          const SizedBox(width: 20),
          _buildToolbarButton(Icons.poll_outlined, 'Poll'),
          const SizedBox(width: 20),
          _buildToolbarButton(Icons.emoji_emotions_outlined, 'Emoji'),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label feature coming soon!'),
            backgroundColor: const Color(0xFF00A3E0),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 22),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  void _publishPost() {
    if (_postController.text.trim().isEmpty) return;

    createPost(content: _postController.text.trim(), isAnonymous: _isAnonymous).then((success) {
      if (success) {
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 300), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post published successfully!'),
              backgroundColor: Color(0xFF00A3E0),
              duration: Duration(seconds: 2),
            ),
          );
        });
      }
    });
  }
}