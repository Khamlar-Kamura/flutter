import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main_screen.dart'; // <-- เพิ่มบรรทัดนี้
// และลบ import user_dashboard.dart ที่ไม่ได้ใช้ออก

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String emailOrName = '', password = '';
  bool isLoading = false;

 Future<void> _login() async {
  setState(() => isLoading = true);
  final isEmail = emailOrName.contains('@');
  final body = isEmail
      ? {'email': emailOrName, 'password': password}
      : {'name': emailOrName, 'password': password};

  try {
  final response = await http.post(
  Uri.parse('https://9e49-154-222-4-193.ngrok-free.app/auth/login'), // ใช้ลิงก์ ngrok backend ที่ออนไลน์จริง
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode(body),
);
print('Login API response: ${response.body}'); 
    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // --- ส่วนที่แก้ไข ---
      // 1. ดึงข้อมูล user และ token ออกมา
      final user = data['user'];
      final token = data['token'];

      // 2. ตรวจสอบว่าได้ข้อมูลครบถ้วนหรือไม่
      if (user == null || token == null) {
        throw Exception('Invalid data from server');
      }
      
      final name = user['name'] ?? 'ผู้ใช้';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ยินดีต้อนรับ $name')),
      );

      // 3. นำทางไปหน้า UserDashboard เสมอ พร้อมส่งข้อมูลที่จำเป็นทั้งหมด
      // ในฟังก์ชัน _login ของ LoginPage
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => MainScreen(
      userData: user,
      token: token,
    ),
  ),
);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ເຂົ້າສຸ່ລະບົບບໍ່ສຳເລັດ: ${response.body}')),
      );
    }
  } catch (e) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ເກີດຂໍ້ຜິດພາດ: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    // Earth tone colors
    const background = Color(0xFFF5EFE6); // ครีม
    const primary = Color(0xFF8D7B68); // น้ำตาลกลาง
    const accent = Color(0xFFB5C99A); // เขียวอ่อน
    const text = Color(0xFF4E342E); // น้ำตาลเข้ม

    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Icon(Icons.eco, size: 64, color: primary),
                ),
                const SizedBox(height: 20),
                Text(
                  'ເຂົ້າສູ່ລະບົບ',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: text,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ອີເມລ ຫຼື ຊື່ຜູ້ໃຊ້',
                    prefixIcon: Icon(Icons.person, color: primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: accent),
                    ),
                  ),
                  onChanged: (val) => emailOrName = val,
                  validator: (val) => val == null || val.isEmpty ? 'ກະລຸນາປ້ອນອີເມລ ຫຼື ຊື່ຜູ້ໃຊ້' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ລະຫັດຜ່ານ',
                    prefixIcon: Icon(Icons.lock, color: primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: accent),
                    ),
                  ),
                  obscureText: true,
                  onChanged: (val) => password = val,
                  validator: (val) => val == null || val.isEmpty ? 'ກະລຸນາປ້ອນລະຫັດຜ່ານ' : null,
                  autofillHints: const [AutofillHints.newPassword], 
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('ເຂົ້າສຼ່ລະບົບ', style: TextStyle(fontSize: 18)),
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _login();
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}