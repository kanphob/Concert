import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking.dart';
import '../models/concert.dart';
import '../providers/api_providers.dart';
import 'concert_detail.dart';

class BookingListScreen extends ConsumerWidget {
  const BookingListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBookings = ref.watch(bookingListProvider);
    final asyncConcerts = ref.watch(concertListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: asyncBookings.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return const Center(child: Text('No bookings yet.'));
          }
          return asyncConcerts.when(
            data: (concerts) {
              // Map bookings to corresponding concert info
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final concert = concerts.firstWhere(
                    (c) => c.id == booking.concertId,
                    orElse: () => Concert(
                      id: 0,
                      name: 'Unknown',
                      description: '',
                      date: '',
                      location: '',
                    ),
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () {
                          // Navigate to concert detail if needed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ConcertDetailScreen(concertId: concert.id),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (concert.image != null)
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(
                                  concert.image!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              const SizedBox(height: 150, child: Icon(Icons.event_seat, size: 80)),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(concert.name,
                                      style: Theme.of(context).textTheme.titleLarge,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${concert.date ?? ''} • ${concert.location ?? ''}',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Quantity: ${booking.quantity}',
                                      style: Theme.of(context).textTheme.bodyMedium),
                                  if (booking.totalPrice != null)
                                    Text('Total Price: ${booking.totalPrice} THB',
                                        style: Theme.of(context).textTheme.bodyMedium),
                                  if (booking.createdAt != null)
                                    Text('Booked on: ${booking.createdAt}',
                                        style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error loading concerts: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
