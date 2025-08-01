import 'package:flutter/material.dart';
import 'home_screen.dart';

class BookingMonthlyScreen extends StatelessWidget {
  final Service service;
  const BookingMonthlyScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(service.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(service.imageUrl, height: 180),
            const SizedBox(height: 16),
            const Text(
              'เลือกวัน/เวลา/ขนาดห้อง สำหรับบริการแม่บ้านรายเดือน',
              style: TextStyle(fontSize: 16),
            ),
            // เพิ่ม widget เลือกวัน เลือกขนาดห้อง เลือกเวลา ฯลฯ ที่นี่
          ],
        ),
      ),
    );  
  }
}