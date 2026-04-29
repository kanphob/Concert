import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/concert.dart';
import '../models/booking.dart';
import '../services/api_service.dart';

// Provider for the list of concerts
final concertListProvider = FutureProvider<List<Concert>>((ref) async {
  return await ApiService.fetchConcerts();
});

// Provider for concert detail by ID
final concertDetailProvider = FutureProvider.family<Concert, int>((ref, id) async {
  return await ApiService.fetchConcertDetail(id);
});

// Provider for the list of bookings
final bookingListProvider = FutureProvider<List<Booking>>((ref) async {
  return await ApiService.fetchBookings();
});

// Provider for creating a booking (returns a Future<Booking>)
final createBookingProvider = Provider<Future<Booking> Function(int concertId, int quantity)>((ref) {
  return (int concertId, int quantity) async {
    return await ApiService.createBooking(concertId, quantity);
  };
});
