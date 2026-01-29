import 'package:flutter/material.dart';
import 'payment_page.dart';

class CheckoutPage extends StatelessWidget {
  final String therapistName;
  final DateTime date;
  final String time;
  final int price;
  final String urgency;

  const CheckoutPage({
    super.key,
    required this.therapistName,
    required this.date,
    required this.time,
    required this.price,
    required this.urgency,
  });

  int get _urgencyFee {
    switch (urgency) {
      case 'urgent':
        return 20;
      case 'emergency':
        return 50;
      default:
        return 0;
    }
  }

  int get _totalPrice => price + _urgencyFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Summary',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _SummaryRow(label: 'Therapist', value: therapistName),
                    const Divider(),
                    _SummaryRow(
                      label: 'Date',
                      value: '${date.day}/${date.month}/${date.year}',
                    ),
                    const Divider(),
                    _SummaryRow(label: 'Time', value: time),
                    const Divider(),
                    _SummaryRow(
                      label: 'Urgency',
                      value: urgency[0].toUpperCase() + urgency.substring(1),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Price Breakdown
            Text(
              'Price Breakdown',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _PriceRow(label: 'Session Fee', amount: price),
                    if (_urgencyFee > 0) ...[
                      const SizedBox(height: 8),
                      _PriceRow(label: 'Urgency Fee', amount: _urgencyFee),
                    ],
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$$_totalPrice',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Cancellation Policy
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Free cancellation up to 24 hours before your session.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentPage(
                        amount: _totalPrice,
                        therapistName: therapistName,
                      ),
                    ),
                  );
                },
                child: Text('Pay \$$_totalPrice'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final int amount;

  const _PriceRow({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label), Text('\$$amount')],
    );
  }
}
