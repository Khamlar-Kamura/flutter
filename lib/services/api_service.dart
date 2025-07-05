import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking_model.dart';
import '../models/user_model.dart'; // ตอนนี้จะถูกใช้งานแล้ว
import '../models/maid_model.dart';

class ApiService {
  final String baseUrl = "http://172.20.10.2:5000/api";

  Future<List<Booking>> fetchMyBookings(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings/my-bookings'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  // ใน ApiService
Future<List<Maid>> fetchAllMaids() async {
  final response = await http.get(Uri.parse('$baseUrl/maids'));
  if (response.statusCode == 200) {
    // API ของคุณส่งข้อมูลแม่บ้านมาใน key 'maids'
    final data = json.decode(response.body);
    final List<dynamic> maidList = data['maids'];
    return maidList.map((json) => Maid.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load maids');
  }
}

  // --- เพิ่มฟังก์ชันนี้เข้าไป ---
  Future<User> fetchMyProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/me'), // สมมติว่ามี Endpoint นี้
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Class User จะถูกเรียกใช้งานที่นี่
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}
