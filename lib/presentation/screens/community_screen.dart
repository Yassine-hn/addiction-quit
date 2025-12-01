import 'package:flutter/material.dart';
import '../../modules/community_module/community_exports.dart'; // Import entire module
import '../widgets/useful_widgets.dart'; // Your existing widgets

class CommunityScreenFromModule extends StatelessWidget {
  const CommunityScreenFromModule({super.key});

  @override
  Widget build(BuildContext context) {
    // Simply return the CommunityScreen from your module
    return const CommunityScreen();
  }
}
