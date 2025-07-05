import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Import service
import '../models/user_model.dart'; // Import model
import '../models/booking_model.dart'; // Import model
// import 'package:intl/intl.dart';    // สำหรับจัดรูปแบบวันที่

class UserDashboard extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String token;

  const UserDashboard({super.key, required this.userData, required this.token});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final ApiService _apiService = ApiService();
  late User _user;
  Future<List<Booking>>? _bookingsFuture;

  @override
  void initState() {
    super.initState();
    // 1. แปลงข้อมูล user ที่ได้รับจากหน้า Login
    _user = User.fromJson(widget.userData);

    // 2. เริ่มดึงข้อมูลการจอง โดยส่ง token ไปด้วย
    _bookingsFuture = _apiService.fetchMyBookings(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard ของ ${_user.fullName}'),
        backgroundColor: const Color(0xFF8D7B68),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5EFE6),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 24),
          Text(
            'การจองของฉัน',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4E342E),
            ),
          ),
          const SizedBox(height: 12),
          _buildBookingList(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFFB5C99A),
              child: Text(
                _user.fullName.isNotEmpty
                    ? _user.fullName[0].toUpperCase()
                    : 'U',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ยินดีต้อนรับ,'),
                Text(
                  _user.fullName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4E342E),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList() {
    return FutureBuilder<List<Booking>>(
      future: _bookingsFuture,
      builder: (context, snapshot) {
        // สถานะ: กำลังโหลด
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // สถานะ: เกิด Error
        if (snapshot.hasError) {
          return Center(
            child: Text('เกิดข้อผิดพลาดในการดึงข้อมูล: ${snapshot.error}'),
          );
        }
        // สถานะ: ไม่มีข้อมูล หรือข้อมูลว่าง
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('คุณยังไม่มีรายการจอง'),
            ),
          );
        }

        final bookings = snapshot.data!;

        // แสดงผลรายการจอง
        return Column(
          children: bookings
              .map((booking) => _buildBookingCard(booking))
              .toList(),
        );
      },
    );
  }

  Widget _buildBookingCard(Booking booking) {
    Color statusColor;
    switch (booking.status) {
      case 'ยืนยันแล้ว':
        statusColor = Colors.green;
        break;
      case 'รอดำเนินการ':
        statusColor = Colors.orange;
        break;
      case 'ยกเลิก':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            // สมมติว่า profileImage เป็น path เต็มจาก server
            "http://YOUR_COMPUTER_IP:5000${booking.maidProfileImage}",
          ),
        ),
        title: Text(
          "แม่บ้าน: ${booking.maidName}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          // "วันที่: ${DateFormat('d MMM yyyy', 'th').format(booking.bookingDate)}"
          "วันที่: ${booking.bookingDate.toLocal().toString().split(' ')[0]}",
        ),
        trailing: Chip(
          label: Text(
            booking.status,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: statusColor,
        ),
      ),
    );
  }
}
