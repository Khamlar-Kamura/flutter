import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '', email = '', password = '', address = '', phone = '';
  int age = 0;
  bool isLoading = false;

  Future<void> _register() async {
    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse(
        'http://172.20.10.2:5000/auth/register',
      ), // เปลี่ยนเป็น /auth/register
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'age': age,
        'address': address,
        'phone': phone,
        'email': email,
        'password': password,
      }),
    );
    setState(() => isLoading = false);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ສະໝັກສະມາຊິກສຳເລັດ!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ສະໝັກສະມາຊິກສຳເລັດ!: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Earth tone colors
    const background = Color(0xFFF5EFE6);
    const primary = Color(0xFF8D7B68);
    const accent = Color(0xFFB5C99A);
    const text = Color(0xFF4E342E);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('ສະໝັກສະມາຊິກ'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Icon(Icons.person_add_alt_1, size: 60, color: primary),
                ),
                const SizedBox(height: 18),
                Text(
                  'ສ້າງບັນຊີໃໝ່',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: text,
                  ),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ຊື່ ແລະ ນາມສະກຸນ',
                    prefixIcon: Icon(Icons.person, color: primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: accent),
                    ),
                  ),
                  onChanged: (val) => name = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'ກະລຸນາປ້ອນຊື່ຂອເຕັມຂອງທ່ານ' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ອາຍຸ',
                    prefixIcon: Icon(Icons.cake, color: primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: accent),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => age = int.tryParse(val) ?? 0,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'ກະລຸນາປ້ອນອາຍຸຂອງທ່ານ' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ບ້ານທີ່ຢູ່',
                    prefixIcon: Icon(Icons.home, color: primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: accent),
                    ),
                  ),
                  onChanged: (val) => address = val,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ເບີໂທ',
                    prefixIcon: Icon(Icons.phone, color: primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: accent),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (val) => phone = val,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ອີເມລ',
                    prefixIcon: Icon(Icons.email, color: primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: accent),
                    ),
                  ),
                  onChanged: (val) => email = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'ກະລຸນາປ້ອນອີເມລຂອງທ່ານ' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ລະຫັດຜ່ານ',
                    prefixIcon: Icon(Icons.lock, color: primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: accent),
                    ),
                  ),
                  obscureText: true,
                  onChanged: (val) => password = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'ກະລຸນາປ້ອນລະຫັດຜ່ານ' : null,
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'ສະໝັກສະມາຊິກ',
                            style: TextStyle(fontSize: 18),
                          ),
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _register();
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
