import 'package:flutter/material.dart';
import '../data/community_backend_functions.dart';
import '../widgets/hero_card.dart';
import '../widgets/community_post.dart';
import '../widgets/custom_floating_action_button.dart';
import '../models/hero_model.dart';
import '../models/post_model.dart';
import 'create_post_screen.dart';
import '../../../presentation/widgets/useful_widgets.dart';
import '../../../l10n/app_localizations.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  Future<({List<PostModel> data, String? error})>? _postsFuture;
  Future<({List<HeroModel> data, String? error})>? _heroesFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _postsFuture = getCommunityPosts();
      _heroesFuture = getHeroesOfWeek();
    });
  }

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
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );
          
          if (result == true && mounted) {
            // Refresh posts after creating a new one
            _loadData();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Post published successfully'),
                backgroundColor: Color(0xFF00A3E0),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(activeIndex: 3),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.white,
      child: Builder(
        builder: (context) => Row(
          children: [
            Icon(Icons.people, color: Colors.grey[800], size: 28),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context)!.community,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroesSection() {
    return FutureBuilder<({List<HeroModel> data, String? error})>(
      future: _heroesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocalizations.of(context)!.heroesOfTheWeek,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  height: 115,
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF00A3E0)),
                  ),
                ),
              ],
            ),
          );
        }

        final result = snapshot.data;
        final heroes = result?.data ?? [];
        final error = result?.error;

        if (error != null) {
          return Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocalizations.of(context)!.heroesOfTheWeek,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    error,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedButton(
                    onPressed: _loadData,
                    child: const Text('Refresh'),
                  ),
                ),
              ],
            ),
          );
        }

        if (heroes.isEmpty) {
          return Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocalizations.of(context)!.heroesOfTheWeek,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'No heroes yet for this month',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 20, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Builder(
                  builder: (context) => Text(
                    AppLocalizations.of(context)!.heroesOfTheWeek,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 115,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: heroes.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final hero = heroes[index];
                    return HeroCard(hero: hero);
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
    return FutureBuilder<({List<PostModel> data, String? error})>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final result = snapshot.data;
        final posts = result?.data ?? [];
        final error = result?.error;

        if (error != null) {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red[400], size: 48),
                  const SizedBox(height: 16),
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red[400], fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _loadData,
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            ),
          );
        }

        if (posts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.message_outlined, color: Colors.grey[400], size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'There are no posts yet',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: posts.map((post) {
            return Column(
              children: [
                CommunityPost(
                  post: post,
                  onLike: () => _handleLike(post),
                  onRefresh: _loadData,
                ),
                const SizedBox(height: 8),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _handleLike(PostModel post) async {
    if (post.id == null) return;
    
    final success = await likePost(post.id!);
    if (success && mounted) {
      _loadData();
    }
  }
}
