import 'package:ai_malacca_tour_guide/config/app_colors.dart';
import 'package:ai_malacca_tour_guide/database/crud/users_crud.dart';
import 'package:ai_malacca_tour_guide/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome_bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black26,
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15.0,
                            color: Colors.black54,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.travel_explore,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'AI TRAVEL',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 15.0,
                                  color: Colors.black54,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Discover Your Perfect Trip with\nAI-Powered Planning',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: 15.0,
                        color: Colors.black54,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Effortlessly create personalized itineraries tailored to your preferences. Let our intelligent assistant handle the details, so you can focus on exploring the world.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.secondary,
                    height: 1.7,
                    shadows: [
                      Shadow(
                        blurRadius: 15.0,
                        color: Colors.black54,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Center(
                  child: GestureDetector(
                    onTap: () => Get.toNamed(Routes.SIGN_IN),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
