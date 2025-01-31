import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/itinerary_controller.dart';

class DaySelector extends GetView<ItineraryController> {
  const DaySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Obx(() {
        if (controller.days.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: controller.days.length,
          itemBuilder: (context, index) {
            final dayItinerary = controller.days[index];
            final date = DateTime.parse(dayItinerary.date.toString());
            final dayNumber = index + 1;

            return Obx(() {
              final isSelected = dayNumber == controller.currentDayIndex.value;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Material(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  elevation: isSelected ? 4 : 1,
                  child: InkWell(
                    onTap: () => controller.loadDayPlaces(dayNumber),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Day $dayNumber',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}/${date.month}',
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white70 : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
          },
        );
      }),
    );
  }
}
