import 'package:ai_malacca_tour_guide/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_malacca_tour_guide/routes/app_pages.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -64),
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/images/default_background.jpg'),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Traveler!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Start your journey with your first trip\nand plan your itinerary',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2196F3).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Get.toNamed(Routes.CHAT),
                        borderRadius: BorderRadius.circular(30),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'New Itinerary',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
