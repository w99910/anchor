import 'package:flutter/material.dart';
import 'booking_page.dart';

class ChooseTherapistPage extends StatelessWidget {
  const ChooseTherapistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a Therapist')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Filter/Search
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by name or specialty',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Filter Chips
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('All'),
                selected: true,
                onSelected: (_) {},
              ),
              FilterChip(
                label: const Text('Anxiety'),
                selected: false,
                onSelected: (_) {},
              ),
              FilterChip(
                label: const Text('Depression'),
                selected: false,
                onSelected: (_) {},
              ),
              FilterChip(
                label: const Text('Stress'),
                selected: false,
                onSelected: (_) {},
              ),
              FilterChip(
                label: const Text('Relationships'),
                selected: false,
                onSelected: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Therapist List
          _TherapistCard(
            name: 'Dr. Sarah Johnson',
            specialty: 'Anxiety & Depression',
            rating: 4.9,
            reviews: 127,
            price: '\$100/session',
            imageUrl: null,
            available: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BookingPage(
                    therapistName: 'Dr. Sarah Johnson',
                    price: 100,
                  ),
                ),
              );
            },
          ),
          _TherapistCard(
            name: 'Dr. Michael Chen',
            specialty: 'Stress Management',
            rating: 4.8,
            reviews: 94,
            price: '\$90/session',
            imageUrl: null,
            available: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BookingPage(
                    therapistName: 'Dr. Michael Chen',
                    price: 90,
                  ),
                ),
              );
            },
          ),
          _TherapistCard(
            name: 'Dr. Emily Williams',
            specialty: 'Trauma & PTSD',
            rating: 4.9,
            reviews: 156,
            price: '\$120/session',
            imageUrl: null,
            available: false,
            onTap: () {},
          ),
          _TherapistCard(
            name: 'Dr. James Brown',
            specialty: 'Relationships & Family',
            rating: 4.7,
            reviews: 82,
            price: '\$95/session',
            imageUrl: null,
            available: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BookingPage(
                    therapistName: 'Dr. James Brown',
                    price: 95,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TherapistCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final String price;
  final String? imageUrl;
  final bool available;
  final VoidCallback onTap;

  const _TherapistCard({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.imageUrl,
    required this.available,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: available ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: available ? 1.0 : 0.6,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Text(
                    name.split(' ').map((e) => e[0]).take(2).join(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (!available)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Unavailable',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onErrorContainer,
                                    ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        specialty,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' ($reviews reviews)',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const Spacer(),
                          Text(
                            price,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ],
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
