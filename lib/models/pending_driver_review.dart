enum RideType {
  homeToWork('Casa->Trabalho'),
  workToHome('Trabalho->Casa');

  const RideType(this.label);

  final String label;
}

class PendingDriverReview {
  const PendingDriverReview({
    required this.rideId,
    required this.driverId,
    required this.driverName,
    required this.avatarUrl,
    required this.rideDate,
    required this.rideType,
  });

  final String rideId;
  final String driverId;
  final String driverName;
  final String avatarUrl;
  final String rideDate;
  final RideType rideType;
}
