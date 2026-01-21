
class UserBooking {
  final int id;
  final String doctorName;
  final String serviceName;
  final String date;
  final String time;
  final String status; // 'upcoming' or 'completed'
  final String doctorInitials;

  UserBooking({
    required this.id,
    required this.doctorName,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.status,
    required this.doctorInitials,
  });
}
