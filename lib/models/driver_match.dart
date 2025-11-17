class DriverMatch {
  const DriverMatch({
    required this.id,
    required this.driverName,
    required this.driverPhoto,
    required this.rating,
    required this.car,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.detourKm,
    required this.availableSeats,
    required this.tags,
    required this.direction,
    this.notes,
  });

  factory DriverMatch.fromJson(Map<String, dynamic> json) {
    return DriverMatch(
      id: json['id'] as String,
      driverName: json['driverName'] as String,
      driverPhoto: json['driverPhoto'] as String,
      rating: (json['rating'] as num).toDouble(),
      car: json['car'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      departureTime: json['departureTime'] as String,
      arrivalTime: json['arrivalTime'] as String,
      detourKm: (json['detourKm'] as num).toDouble(),
      availableSeats: json['availableSeats'] as int,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      notes: json['notes'] as String?,
      direction: json['direction'] as String? ?? 'home_to_work',
    );
  }

  final String id;
  final String driverName;
  final String driverPhoto;
  final double rating;
  final String car;
  final String origin;
  final String destination;
  final String departureTime;
  final String arrivalTime;
  final double detourKm;
  final int availableSeats;
  final List<String> tags;
  final String direction;
  final String? notes;
}
