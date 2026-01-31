import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../utils/responsive.dart';
import 'booking_page.dart';

class TherapistDetailPage extends StatelessWidget {
  final String name;
  final String specialty;
  final String bio;
  final double rating;
  final int reviews;
  final int price;
  final bool available;
  final List<String> tags;
  final List<String> languages;
  final String nextAvailable;

  const TherapistDetailPage({
    super.key,
    required this.name,
    required this.specialty,
    required this.bio,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.available,
    required this.tags,
    required this.languages,
    required this.nextAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(
                          name.split(' ').map((e) => e[0]).take(2).join(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        specialty,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: ResponsiveCenter(
              maxWidth: 600,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _StatItem(
                        icon: Icons.star_rounded,
                        value: rating.toString(),
                        label: l10n.reviewsCount(reviews),
                        color: Colors.amber[700]!,
                      ),
                      const SizedBox(width: 24),
                      _StatItem(
                        icon: Icons.attach_money_rounded,
                        value: '\$$price',
                        label: l10n.perSessionLabel,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 24),
                      _StatItem(
                        icon: Icons.schedule_rounded,
                        value: '50',
                        label: l10n.minutes,
                        color: Colors.blue,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Availability
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: available
                          ? Colors.green.withOpacity(0.1)
                          : Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          available
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: available
                              ? Colors.green
                              : Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                available
                                    ? l10n.available
                                    : l10n.currentlyUnavailable,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: available
                                          ? Colors.green
                                          : Theme.of(context).colorScheme.error,
                                    ),
                              ),
                              if (available)
                                Text(
                                  l10n.nextSlot(nextAvailable),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.green),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // About
                  Text(
                    l10n.about,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bio,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Specializations
                  Text(
                    l10n.specializations,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Languages
                  Text(
                    l10n.languages,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: languages.map((lang) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.translate_rounded, size: 16),
                          const SizedBox(width: 6),
                          Text(lang),
                        ],
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Reviews preview
                  Row(
                    children: [
                      Text(
                        l10n.reviews,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      TextButton(onPressed: () {}, child: Text(l10n.seeAll)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _ReviewCard(
                    name: 'Anonymous',
                    date: '2 weeks ago',
                    rating: 5,
                    text:
                        'Very helpful and understanding. Made me feel comfortable from the first session.',
                  ),
                  _ReviewCard(
                    name: 'Anonymous',
                    date: '1 month ago',
                    rating: 5,
                    text: 'Excellent therapist! Highly recommend.',
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
              ),
            ),
          ),
          child: ResponsiveCenter(
            maxWidth: 600,
            child: FilledButton(
              onPressed: available
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BookingPage(therapistName: name, price: price),
                        ),
                      );
                    }
                  : null,
              child: Text(
                available
                    ? l10n.bookSessionWithPrice(price)
                    : l10n.currentlyUnavailable,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final String date;
  final int rating;
  final String text;

  const _ReviewCard({
    required this.name,
    required this.date,
    required this.rating,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.person_rounded, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 16,
                    color: Colors.amber[700],
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}
