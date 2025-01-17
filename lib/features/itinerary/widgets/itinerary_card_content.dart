import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/itinerary_model.dart';
import '../../../routes/app_pages.dart';
import 'status_badge.dart';
import '../utils/date_formatter.dart';

class ItineraryCardContent extends StatelessWidget {
  final ItineraryModel itinerary;

  const ItineraryCardContent({
    Key? key,
    required this.itinerary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          _buildDateInfo(context),
          const SizedBox(height: 16),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            itinerary.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        StatusBadge(status: itinerary.status),
      ],
    );
  }

  Widget _buildDateInfo(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 16),
        const SizedBox(width: 8),
        Text(
          '${DateFormatter.formatDate(itinerary.startDate)} - ${DateFormatter.formatDate(itinerary.endDate)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBudgetInfo(context),
        _buildViewDetailsButton(),
      ],
    );
  }

  Widget _buildBudgetInfo(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.attach_money, size: 16),
        Text(
          'Budget: RM${itinerary.totalBudget}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildViewDetailsButton() {
    return TextButton.icon(
      onPressed: () => Get.toNamed(
        Routes.ITINERARY_DETAILS,
        arguments: {'itineraryId': itinerary.id},
      ),
      icon: const Icon(Icons.arrow_forward, size: 16),
      label: const Text('View Details'),
    );
  }
}
