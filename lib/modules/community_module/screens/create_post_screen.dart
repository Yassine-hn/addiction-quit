import 'package:flutter/material.dart';
import '../data/community_backend_functions.dart';
import '../../../l10n/app_localizations.dart';

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
        title: Text(
          AppLocalizations.of(context)!.createPost,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _postController.text.isEmpty
                ? null
                : () => _publishPost(),
            child: Text(
              AppLocalizations.of(context)!.post,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _postController.text.isEmpty
                    ? Colors.grey[400]
                    : const Color(0xFF00A3E0),
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
              _isAnonymous ? AppLocalizations.of(context)!.anonymous : 'Alex',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.postingToCommunity,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
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
        hintText: AppLocalizations.of(context)!.shareYourThoughts,
        hintStyle: TextStyle(
          fontSize: 16,
          color: Colors.grey[400],
          height: 1.5,
        ),
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
          Icon(
            Icons.visibility_off_outlined,
            color: Colors.grey[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.postAnonymously,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppLocalizations.of(context)!.yourIdentityHidden,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: _isAnonymous,
            onChanged: (value) => setState(() => _isAnonymous = value),
            activeThumbColor: const Color(0xFF00A3E0),
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
          AppLocalizations.of(context)!.popularTopics,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            '#Motivation',
            '#Support',
            '#Milestone',
            '#Tips',
            '#Question',
          ].map((topic) => _buildTopicChip(topic)).toList(),
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
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF00A3E0),
          ),
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
          _buildToolbarButton(Icons.image_outlined, AppLocalizations.of(context)!.photo),
          const SizedBox(width: 20),
          _buildToolbarButton(Icons.poll_outlined, AppLocalizations.of(context)!.poll),
          const SizedBox(width: 20),
          _buildToolbarButton(Icons.emoji_emotions_outlined, AppLocalizations.of(context)!.emoji),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.featureComingSoon(label)),
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

    createPost(
      content: _postController.text.trim(),
      isAnonymous: _isAnonymous,
    ).then((success) {
      if (success) {
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 300), () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.postPublishedSuccessfully),
              backgroundColor: const Color(0xFF00A3E0),
              duration: const Duration(seconds: 2),
            ),
          );
        });
      }
    });
  }
}
