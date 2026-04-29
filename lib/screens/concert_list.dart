import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:concert/models/concert.dart';
import 'package:concert/providers/api_providers.dart';
import 'booking_list.dart';
import 'concert_detail.dart';

class ConcertListScreen extends ConsumerWidget {
  const ConcertListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncConcerts = ref.watch(concertListProvider);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Concerts'),
          // Navigate back to the host app when Home is pressed
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst),
          ),
          actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookingListScreen()),
              );
            },
            child: const Text('My Bookings', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: asyncConcerts.when(
        data: (concerts) => ListView.builder(
          itemCount: concerts.length,
          itemBuilder: (context, index) {
            final concert = concerts[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConcertDetailScreen(concertId: concert.id),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (concert.image != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            concert.image!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        const SizedBox(height: 180, child: Icon(Icons.music_note, size: 80)),
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
                            if (concert.artist != null) ...[
                              const SizedBox(height: 4),
                              Text('Artist: ${concert.artist!}',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                            if (concert.venue != null) ...[
                              const SizedBox(height: 4),
                              Text('Venue: ${concert.venue!}',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                            if (concert.time != null) ...[
                              const SizedBox(height: 4),
                              Text('Time: ${concert.time!}',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                            if (concert.price != null) ...[
                              const SizedBox(height: 4),
                              Text('Price: ${concert.price} THB',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                            if (concert.totalSeats != null && concert.availableSeats != null) ...[
                              const SizedBox(height: 4),
                              Text('Seats: ${concert.availableSeats}/${concert.totalSeats} available',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
