class PassengerReviewSubmission {
  const PassengerReviewSubmission({
    required this.driverId,
    required this.rideId,
    required this.rating,
    required this.strengths,
    required this.comment,
    required this.shareWithRh,
  });

  final String driverId;
  final String rideId;
  final double rating;
  final List<String> strengths;
  final String comment;
  final bool shareWithRh;

  Map<String, dynamic> toJson() => {
        'driverId': driverId,
        'rideId': rideId,
        'rating': rating,
        'strengths': strengths,
        'comment': comment,
        'shareWithRh': shareWithRh,
      };
}
