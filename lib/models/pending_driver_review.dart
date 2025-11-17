class PendingDriverReview {
  const PendingDriverReview({
    required this.rideId,
    required this.driverId,
    required this.driverName,
    required this.avatarUrl,
    required this.rideSummary,
  });

  final String rideId;
  final String driverId;
  final String driverName;
  final String avatarUrl;
  final String rideSummary;
}
