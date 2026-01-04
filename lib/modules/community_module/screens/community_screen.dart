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
    return FutureBuilder<List<HeroModel>>(
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
    return FutureBuilder<List<PostModel>>(
      future: getCommunityPosts(),
      builder: (context, snapshot) {
        final posts = snapshot.data ?? getDefaultPosts();

        return Column(
          children: posts.map((post) {
            return Column(
              children: [
                CommunityPost(post: post),
                const SizedBox(height: 8),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
