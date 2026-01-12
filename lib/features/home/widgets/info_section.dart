import 'package:flutter/material.dart';


class InfoSection extends StatelessWidget {
    const InfoSection({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        final int notStarted = 55;
        final int onProgress = 25;
        final int onReview = 15;
        final int completed = 10;
        final int total = notStarted + onProgress + onReview + completed;

        final theme = Theme.of(context);

        return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                    ),
                ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                        children: [
                            Expanded(
                                child: Text(
                                    'Current total',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey[700],
                                    ),
                                ),
                            ),
                            TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                    padding:
                                            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('View detail'),
                            ),
                        ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                        '$total Tasks',
                        style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                        ),
                    ),
                    const SizedBox(height: 16),

                    // Segmented progress bar
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Row(
                            children: [
                                if (notStarted > 0)
                                    Expanded(
                                        flex: notStarted,
                                        child: Container(height: 12, color: const Color(0xFF4E9BEF)),
                                    ),
                                if (onProgress > 0)
                                    Expanded(
                                        flex: onProgress,
                                        child: Container(height: 12, color: const Color(0xFFB28CFF)),
                                    ),
                                if (onReview > 0)
                                    Expanded(
                                        flex: onReview,
                                        child: Container(height: 12, color: const Color(0xFFFFD36A)),
                                    ),
                                if (completed > 0)
                                    Expanded(
                                        flex: completed,
                                        child: Container(height: 12, color: const Color(0xFF7AD39A)),
                                    ),
                            ],
                        ),
                    ),

                    const SizedBox(height: 16),

                    // Legend
                    Column(
                        children: [
                            _LegendItem(
                                color: const Color(0xFF4E9BEF),
                                label: 'Not started',
                                count: notStarted,
                            ),
                            const SizedBox(height: 8),
                            _LegendItem(
                                color: const Color(0xFFB28CFF),
                                label: 'On progress',
                                count: onProgress,
                            ),
                            const SizedBox(height: 8),
                            _LegendItem(
                                color: const Color(0xFFFFD36A),
                                label: 'On Review',
                                count: onReview,
                            ),
                            const SizedBox(height: 8),
                            _LegendItem(
                                color: const Color(0xFF7AD39A),
                                label: 'Completed',
                                count: completed,
                            ),
                        ],
                    ),

                    const SizedBox(height: 18),

                    // Large CTA
                    SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                ),
                            ),
                            child: const Text('View detail'),
                        ),
                    ),
                ],
            ),
        );
    }
}

class _LegendItem extends StatelessWidget {
    final Color color;
    final String label;
    final int count;

    const _LegendItem(
            {Key? key, required this.color, required this.label, required this.count})
            : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Row(
            children: [
                Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                        label,
                        style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ),
                Text(
                    '$count tasks',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                            ),
                ),
            ],
        );
    }
}

