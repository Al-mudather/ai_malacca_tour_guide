import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/itinerary_controller.dart';

class TripInfoSection extends GetView<ItineraryController> {
  const TripInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusBadge(status: controller.currentItinerary.value!.status),
          const SizedBox(height: 16),
          const DateRangeInfo(),
          const SizedBox(height: 8),
          const BudgetInfo(),
          const SizedBox(height: 24),
          Text(
            'Daily Schedule',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({Key? key, required this.status}) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return Colors.orange;
      case 'generated':
        return Colors.blue;
      case 'finalized':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class DateRangeInfo extends GetView<ItineraryController> {
  const DateRangeInfo({Key? key}) : super(key: key);

  String _formatDate(String date) {
    if (date.isEmpty) return '';
    final dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 20),
        const SizedBox(width: 8),
        Text(
          '${_formatDate(controller.startDate)} - ${_formatDate(controller.endDate)}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class BudgetInfo extends GetView<ItineraryController> {
  const BudgetInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.attach_money, size: 20),
        const SizedBox(width: 8),
        Text(
          'Budget: RM ${controller.currentItinerary.value!.totalBudget}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
