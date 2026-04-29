class Booking {
  final int id;
  final int userId;
  final int concertId;
  final int quantity;
  final int? totalPrice;
  final DateTime? createdAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.concertId,
    required this.quantity,
    this.totalPrice,
    this.createdAt,
  });

  // Safely parse JSON, handling nullable fields
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      userId: json['userId'] is int ? json['userId'] as int : int.tryParse('${json['userId']}') ?? 0,
      concertId: json['concertId'] is int ? json['concertId'] as int : int.tryParse('${json['concertId']}') ?? 0,
      quantity: json['quantity'] is int ? json['quantity'] as int : int.tryParse('${json['quantity']}') ?? 0,
      totalPrice: json['totalPrice'] != null
          ? (json['totalPrice'] is int ? json['totalPrice'] as int : int.tryParse('${json['totalPrice']}'))
          : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
    );
  }
}
