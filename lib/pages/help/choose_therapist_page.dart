import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../utils/responsive.dart';
import 'booking_page.dart';
import 'therapist_detail_page.dart';

class ChooseTherapistPage extends StatefulWidget {
  const ChooseTherapistPage({super.key});

  @override
  State<ChooseTherapistPage> createState() => _ChooseTherapistPageState();
}

class _ChooseTherapistPageState extends State<ChooseTherapistPage> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<String> _filters = [
    'All',
    'Anxiety',
    'Depression',
    'Stress',
    'Trauma',
    'Relationships',
    'Addiction',
    'Grief',
  ];

  final List<_Therapist> _therapists = [
    _Therapist(
      name: 'Dr. Sarah Johnson',
      specialty: 'Anxiety & Depression',
      bio:
          'Specializing in cognitive behavioral therapy with 12 years of experience helping patients overcome anxiety and depression.',
      rating: 4.9,
      reviews: 127,
      price: 100,
      available: true,
      tags: ['Anxiety', 'Depression', 'Stress'],
      languages: ['English', 'Spanish'],
      nextAvailable: 'Today, 3:00 PM',
    ),
    _Therapist(
      name: 'Dr. Michael Chen',
      specialty: 'Stress Management',
      bio:
          'Expert in mindfulness-based stress reduction and work-life balance coaching.',
      rating: 4.8,
      reviews: 94,
      price: 90,
      available: true,
      tags: ['Stress', 'Anxiety'],
      languages: ['English', 'Mandarin'],
      nextAvailable: 'Tomorrow, 10:00 AM',
    ),
    _Therapist(
      name: 'Dr. Emily Williams',
      specialty: 'Trauma & PTSD',
      bio:
          'Trauma-informed therapist specializing in EMDR and somatic experiencing.',
      rating: 4.9,
      reviews: 156,
      price: 120,
      available: false,
      tags: ['Trauma', 'Anxiety', 'Depression'],
      languages: ['English'],
      nextAvailable: 'Next week',
    ),
    _Therapist(
      name: 'Dr. James Brown',
      specialty: 'Relationships & Family',
      bio:
          'Licensed marriage and family therapist helping couples and families build stronger connections.',
      rating: 4.7,
      reviews: 82,
      price: 95,
      available: true,
      tags: ['Relationships'],
      languages: ['English'],
      nextAvailable: 'Today, 5:00 PM',
    ),
    _Therapist(
      name: 'Dr. Maria Garcia',
      specialty: 'Addiction Recovery',
      bio:
          'Certified addiction counselor with expertise in substance abuse and behavioral addictions.',
      rating: 4.8,
      reviews: 68,
      price: 110,
      available: true,
      tags: ['Addiction', 'Depression', 'Anxiety'],
      languages: ['English', 'Spanish'],
      nextAvailable: 'Tomorrow, 2:00 PM',
    ),
    _Therapist(
      name: 'Dr. David Kim',
      specialty: 'Grief & Loss',
      bio:
          'Compassionate therapist specializing in bereavement counseling and life transitions.',
      rating: 4.9,
      reviews: 73,
      price: 95,
      available: true,
      tags: ['Grief', 'Depression', 'Anxiety'],
      languages: ['English', 'Korean'],
      nextAvailable: 'Today, 4:00 PM',
    ),
  ];

  List<_Therapist> get _filteredTherapists {
    return _therapists.where((t) {
      final matchesFilter =
          _selectedFilter == 'All' || t.tags.contains(_selectedFilter);
      final matchesSearch =
          _searchQuery.isEmpty ||
          t.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.specialty.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(l10n.findTherapist),
      ),
      body: Column(
        children: [
          // Search and filters
          Padding(
            padding: Responsive.pagePadding(context).copyWith(bottom: 0),
            child: ResponsiveCenter(
              maxWidth: 600,
              child: Column(
                children: [
                  TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: l10n.searchByNameOrSpecialty,
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () =>
                                  setState(() => _searchQuery = ''),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final filter = _filters[index];
                        final isSelected = _selectedFilter == filter;
                        return FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (_) =>
                              setState(() => _selectedFilter = filter),
                          showCheckmark: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Results count
          Padding(
            padding: Responsive.pagePadding(
              context,
            ).copyWith(top: 8, bottom: 8),
            child: ResponsiveCenter(
              maxWidth: 600,
              child: Row(
                children: [
                  Text(
                    l10n.therapistsAvailable(_filteredTherapists.length),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Therapist list
          Expanded(
            child: ListView.builder(
              padding: Responsive.pagePadding(context).copyWith(top: 0),
              itemCount: _filteredTherapists.length,
              itemBuilder: (context, index) {
                final therapist = _filteredTherapists[index];
                return ResponsiveCenter(
                  maxWidth: 600,
                  child: _TherapistCard(
                    therapist: therapist,
                    onTap: () => _showTherapistDetails(therapist),
                    onBook: () => _bookTherapist(therapist),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTherapistDetails(_Therapist therapist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TherapistDetailPage(
          name: therapist.name,
          specialty: therapist.specialty,
          bio: therapist.bio,
          rating: therapist.rating,
          reviews: therapist.reviews,
          price: therapist.price,
          available: therapist.available,
          tags: therapist.tags,
          languages: therapist.languages,
          nextAvailable: therapist.nextAvailable,
        ),
      ),
    );
  }

  void _bookTherapist(_Therapist therapist) {
    if (therapist.available) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingPage(
            therapistName: therapist.name,
            price: therapist.price,
          ),
        ),
      );
    }
  }
}

class _Therapist {
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

  _Therapist({
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
}

class _TherapistCard extends StatelessWidget {
  final _Therapist therapist;
  final VoidCallback onTap;
  final VoidCallback onBook;

  const _TherapistCard({
    required this.therapist,
    required this.onTap,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      child: Text(
                        therapist.name
                            .split(' ')
                            .map((e) => e[0])
                            .take(2)
                            .join(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  therapist.name,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              if (therapist.available)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            therapist.specialty,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: Colors.amber[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${therapist.rating}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                ' (${therapist.reviews})',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                              const Spacer(),
                              Text(
                                '\$${therapist.price}',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                              Text(
                                l10n.perSession,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Tags and availability
                Row(
                  children: [
                    // Languages
                    Icon(
                      Icons.translate_rounded,
                      size: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      therapist.languages.join(', '),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    // Next available
                    if (therapist.available)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              size: 12,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              therapist.nextAvailable,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          l10n.unavailable,
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

                const SizedBox(height: 12),

                // Book button
                SizedBox(
                  width: double.infinity,
                  child: therapist.available
                      ? FilledButton(
                          onPressed: onBook,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 44),
                          ),
                          child: Text(l10n.bookSession),
                        )
                      : OutlinedButton(
                          onPressed: onTap,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 44),
                          ),
                          child: Text(l10n.viewProfile),
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
