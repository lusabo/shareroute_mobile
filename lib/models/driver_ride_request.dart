class DriverRideRequest {
  const DriverRideRequest({
    required this.id,
    required this.passengerName,
    required this.time,
    required this.origin,
    required this.destination,
    required this.photoUrl,
    required this.notes,
    required this.rideType,
    required this.address,
    required this.mapsUrl,
  });

  factory DriverRideRequest.fromJson(Map<String, dynamic> json) {
    return DriverRideRequest(
      id: json['id'] as String? ?? '',
      passengerName: json['passengerName'] as String? ?? 'Passageiro',
      time: json['time'] as String? ?? '--:--',
      origin: json['origin'] as String? ?? 'Origem não informada',
      destination: json['destination'] as String? ?? 'Destino não informado',
      photoUrl: json['photoUrl'] as String? ?? 'https://i.pravatar.cc/100?img=1',
      notes: json['notes'] as String? ?? '',
      rideType: json['rideType'] as String? ?? '',
      address: json['address'] as String? ?? '',
      mapsUrl: json['mapsUrl'] as String? ?? 'https://maps.google.com',
    );
  }

  final String id;
  final String passengerName;
  final String time;
  final String origin;
  final String destination;
  final String photoUrl;
  final String notes;
  final String rideType;
  final String address;
  final String mapsUrl;
}
