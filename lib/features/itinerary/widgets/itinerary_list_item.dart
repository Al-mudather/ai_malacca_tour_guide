import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/itinerary_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/itinerary_controller.dart';
import 'itinerary_card_content.dart';

class ItineraryListItem extends StatelessWidget {
  final ItineraryModel itinerary;

  const ItineraryListItem({
    super.key,
    required this.itinerary,
  });

  void _handleDelete() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Itinerary'),
        content: const Text(
            'Are you sure you want to delete this itinerary? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.find<ItineraryController>().deleteItinerary(itinerary.id!);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => Get.toNamed(
          Routes.ITINERARY_DETAILS,
          arguments: {'itineraryId': itinerary.id},
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _buildCoverImage(),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: _handleDelete,
                    icon: const Icon(Icons.delete),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            ItineraryCardContent(itinerary: itinerary),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1527838832700-5059252407fa?q=80&w=1000',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
