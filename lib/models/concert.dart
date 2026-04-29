class Concert {
  final int id;
  final String name;
  final String? description;
  final String? date;
  final String? location;
  final String? artist;
  final String? venue;
  final String? time;
  final int? price;
  final int? totalSeats;
  final int? availableSeats;
  final String? image;

  const Concert({
    required this.id,
    required this.name,
    this.description,
    this.date,
    this.location,
    this.artist,
    this.venue,
    this.time,
    this.price,
    this.totalSeats,
    this.availableSeats,
    this.image,
  });

  // Safely parse JSON, accommodating new fields and providing defaults for missing values
  factory Concert.fromJson(Map<String, dynamic> json) {
    return Concert(
      id: (json['id'] ?? 0) is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      date: json['date']?.toString(),
      location: json['location']?.toString(),
      artist: json['artist']?.toString(),
      venue: json['venue']?.toString(),
      time: json['time']?.toString(),
      price: json['price'] is int ? json['price'] as int : int.tryParse('${json['price']}'),
      totalSeats: json['totalSeats'] is int ? json['totalSeats'] as int : int.tryParse('${json['totalSeats']}'),
      availableSeats: json['availableSeats'] is int ? json['availableSeats'] as int : int.tryParse('${json['availableSeats']}'),
      image: json['image']?.toString(),
    );
  }
}
