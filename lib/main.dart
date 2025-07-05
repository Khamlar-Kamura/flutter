import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'screens/register_page.dart'; // เพิ่มบรรทัดนี้
import 'screens/login_page.dart'; // เพิ่มบรรทัดนี้

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// filepath: c:\maid\maid_app\lib\main.dart
Future<String> fetchStatus() async {
  final response = await http.get(
    Uri.parse('http://172.20.10.2:5000/status'), // ใช้ลิงก์ ngrok backend จริง
  );
  print('API response: ${response.body}');
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['status'] ?? 'No status';
  } else {
    throw Exception('Failed to connect to backend');
  }
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage(fetchStatus: fetchStatus));
  }
}

class HomePage extends StatelessWidget {
  final Future<String> Function() fetchStatus;
  const HomePage({Key? key, required this.fetchStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ແອພຈ້າງແມ່ບ້ານ'),
        centerTitle: true,
        backgroundColor: Colors.white, // สีม่วงอ่อน
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF232526), // ดำเทา
              Color(0xFF414345), // เทาเข้ม
              Color(0xFFb993d6), // ม่วงอ่อน
              Color(0xFF8ca6db), // น้ำเงินอ่อน
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset(
                'assets/maid.png',
                width: 200,
                height: 220,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              FutureBuilder<String>(
                future: fetchStatus(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // ...existing code...
                    return Text(
                      (snapshot.data?.toLowerCase().contains(
                                'welcome to maid app',
                              ) ??
                              false)
                          ? 'Welcome to MAID APP'
                          : 'Connected failed',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    );
                    // ...existing code...
                  }
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                child: const Text('ສະໝັກສະມາຊິກ'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('ເຂົ້າສູ່ລະບົບ'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
