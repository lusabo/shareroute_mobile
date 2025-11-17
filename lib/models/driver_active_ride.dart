import 'ride_direction.dart';

class DriverActiveRide {
  DriverActiveRide({
    required this.direction,
    required this.passengers,
  });

  final RideDirection direction;
  final List<ActiveRidePassenger> passengers;

  factory DriverActiveRide.fromJson(Map<String, dynamic> json) {
    final directionValue = json['direction'] as String? ?? 'home_to_work';
    final direction = RideDirection.values.firstWhere(
      (d) => d.apiValue == directionValue,
      orElse: () => RideDirection.homeToWork,
    );

    final passengersJson = json['passengers'] as List<dynamic>? ?? [];
    final passengers = passengersJson
        .whereType<Map<String, dynamic>>()
        .map(ActiveRidePassenger.fromJson)
        .toList();

    return DriverActiveRide(
      direction: direction,
      passengers: passengers,
    );
  }
}

class ActiveRidePassenger {
  ActiveRidePassenger({
    required this.id,
    required this.name,
    required this.address,
    required this.googleMapsUrl,
    required this.avatarUrl,
    required this.chatHistory,
  });

  final String id;
  final String name;
  final String address;
  final String googleMapsUrl;
  final String avatarUrl;
  final List<PassengerChatMessage> chatHistory;

  factory ActiveRidePassenger.fromJson(Map<String, dynamic> json) {
    final chatHistoryJson = json['chatHistory'] as List<dynamic>? ?? [];
    final chatHistory = chatHistoryJson
        .whereType<Map<String, dynamic>>()
        .map(PassengerChatMessage.fromJson)
        .toList();

    return ActiveRidePassenger(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Passageiro',
      address: json['address'] as String? ?? 'Endereço não informado',
      googleMapsUrl: json['googleMapsUrl'] as String? ?? 'https://maps.google.com',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      chatHistory: chatHistory,
    );
  }
}

class PassengerChatMessage {
  PassengerChatMessage({
    required this.content,
    required this.fromDriver,
  });

  final String content;
  final bool fromDriver;

  factory PassengerChatMessage.fromJson(Map<String, dynamic> json) {
    return PassengerChatMessage(
      content: json['content'] as String? ?? '',
      fromDriver: json['fromDriver'] as bool? ?? false,
    );
  }
}
