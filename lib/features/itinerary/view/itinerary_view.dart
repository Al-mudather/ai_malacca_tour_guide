import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/itinerary_controller.dart';
import '../widgets/itinerary_app_bar.dart';
import '../widgets/empty_itinerary_view.dart';
import '../widgets/itinerary_list_item.dart';

class ItineraryView extends GetView<ItineraryController> {
  ItineraryView({super.key}) {
    controller.loadUserItineraries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: RefreshIndicator(
        onRefresh: () => controller.loadUserItineraries(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            ItineraryAppBar(onAddPressed: () {}),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Itineraries',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover and explore your planned trips',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (controller.userItineraries.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text('No itineraries found'),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final itinerary = controller.userItineraries[index];
                      return AnimatedOpacity(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        opacity: 1.0,
                        child: ItineraryListItem(itinerary: itinerary),
                      );
                    },
                    childCount: controller.userItineraries.length,
                  ),
                ),
              );
            }),
            const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
          ],
        ),
      ),
    );
  }
}
