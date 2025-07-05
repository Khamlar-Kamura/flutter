// lib/models/booking_model.dart

class Booking {
  final String id; // _id ของการจอง
  final String maidName;
  final String? maidProfileImage;
  final DateTime bookingDate;
  final String status;

  Booking({
    required this.id,
    required this.maidName,
    this.maidProfileImage,
    required this.bookingDate,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    // Backend ใช้ .populate() เพื่อส่งข้อมูล maid ซ้อนมาใน maid_id
    final maidData = json['maid_id'] as Map<String, dynamic>?;

    return Booking(
      id: json['_id'],
      // ดึงข้อมูลจาก object ของแม่บ้านที่ซ้อนกันอยู่
      maidName: maidData?['full_name'] ?? 'ไม่มีชื่อ',
      maidProfileImage: maidData?['profile_image'],
      bookingDate: DateTime.parse(json['booking_date']),
      status: json['status'],
    );
  }
}
