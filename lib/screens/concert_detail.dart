import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/concert.dart';
import '../providers/api_providers.dart';
import 'booking_list.dart';

class ConcertDetailScreen extends ConsumerStatefulWidget {
  final int concertId;

  const ConcertDetailScreen({Key? key, required this.concertId}) : super(key: key);

  @override
  ConsumerState<ConcertDetailScreen> createState() => _ConcertDetailScreenState();
}

class _ConcertDetailScreenState extends ConsumerState<ConcertDetailScreen> {
  final TextEditingController _quantityController = TextEditingController(text: '1');

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _bookConcert() async {
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    try {
      await ref.read(createBookingProvider)(widget.concertId, quantity);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking successful')));
      Navigator.push(context, MaterialPageRoute(builder: (_) => const BookingListScreen()));
    } catch (e) {
      // Error handling without user-facing dialog.
      // Log the error silently; UI will remain unchanged.
      debugPrint('Booking failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncConcert = ref.watch(concertDetailProvider(widget.concertId));

    return Scaffold(
      appBar: AppBar(title: const Text('Concert Detail')),
      body: asyncConcert.when(
        data: (concert) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (concert.image != null)
                Center(
                  child: Image.network(
                    concert.image!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 12),
              Text(concert.name, style: Theme.of(context).textTheme.headlineSmall),
              if (concert.artist != null) Text('Artist: ${concert.artist}'),
              if (concert.venue != null) Text('Venue: ${concert.venue}'),
              const SizedBox(height: 8),
              if (concert.date != null) Text('Date: ${concert.date}'),
              if (concert.time != null) Text('Time: ${concert.time}'),
              if (concert.location != null) Text('Location: ${concert.location}'),
              const SizedBox(height: 12),
              if (concert.description != null) Text(concert.description!),
              const SizedBox(height: 12),
              if (concert.price != null) Text('Price: ${concert.price} THB'),
              if (concert.totalSeats != null && concert.availableSeats != null)
                Text('Seats: ${concert.availableSeats}/${concert.totalSeats} available'),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text('Quantity:'),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 60,
                    child: TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(onPressed: _bookConcert, child: const Text('Book Now')),
                ],
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
