// lib/screens/home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'booking_cleaning.dart';
import 'booking_ac.dart';
import 'booking_sofa.dart';
import 'booking_threeman.dart';
import 'booking_toilet.dart';
import 'booking_iron.dart';
import 'booking_monthly.dart';


// --- Mock Data สำหรับทดสอบ UI ---
class Promotion {
  final String imageUrl;
  Promotion(this.imageUrl);
}

class Service {
  final String imageUrl;
  final String name;
  Service(this.imageUrl, this.name);
}

class Servicee {
  final String imageUrl;
  final String name;
  Servicee(this.imageUrl, this.name);
}
// -----------------------------

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;

  // --- ข้อมูลจำลอง ---
  final List<Promotion> _promotions = [
    Promotion('assets/banner1.png'),
    Promotion('assets/banner2.png'),
  ];

  final List<Service> _services = [
    Service('assets/service_cleaning.png', 'ບໍລິການທຳຄວາມສະອາດ'),
    Service('assets/service_ac.png', 'ບໍລິການລ້າງແອ'),
    Service('assets/service_sofa.png', 'ບໍລິການຊັກໂຊຟາ'),
    Service('assets/service_team.png', 'ທຳຄວາມສະອາດແບບ 3 ຄົນ'),
    Service('assets/service_bathroom.png', 'ບໍລິການລ້າງຫ້ອງນ້ຳ'),
    Service('assets/service_iron.png', 'ບໍລິການລີດເຄື່ອງ'),
  ];
  final List<Service> monthlyServices = [
    Service('assets/service_monthly.png', 'ບໍລິການແມ່ບ້ານລາຍເດືອນ'),
  ];

  // --------------------

  @override
  void initState() {
    super.initState();
    // ตั้งค่า Timer ให้ Banner เลื่อนอัตโนมัติ
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage >= _promotions.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPromotionCarousel(),
            _buildSectionHeader('ບໍລິການທີ່ນິຍົມ'),
            _buildServicesGrid(),
            _buildMonthlyMaidSection('ແພັກເກັດລາຍເດືອນ'),
            // คุณสามารถเพิ่ม Section อื่นๆ ต่อที่นี่ได้
          ],
        ),
      ),
    );
  }

  // --- Widget ย่อยๆ ---
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Container(
        height: 40,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'ຄົ້ນຫາຜຸ້ໃຫ້ບໍລິການ',
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications_none_outlined,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionCarousel() {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _promotions.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(_promotions[index].imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ...existing code...

  Widget _buildServicesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return GestureDetector(
          onTap: () {
      if (service.imageUrl == 'assets/service_cleaning.png') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingCleaningScreen(service: service),
          ),
        );
          } else if (service.imageUrl == 'assets/service_ac.png') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingAcScreen(service: service),
              ),
            );
          } else if (service.imageUrl == 'assets/service_sofa.png') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingSofaScreen(service: service),
              ),
            );
             } else if (service.imageUrl == 'assets/service_team.png') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingThreemanScreen(service: service),
              ),
            );
          } else if (service.imageUrl == 'assets/service_bathroom.png') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingToiletScreen(service: service),
              ),
            );
          } else if (service.imageUrl == 'assets/service_iron.png') {
            Navigator.push(
               context,
              MaterialPageRoute(
                builder: (context) => BookingIronScreen(service: service),
              ),
            );
          }
        },
          child: Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(service.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                service.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4A4A),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  // เพิ่มฟังก์ชันนี้อยู่นอก _buildServicesGrid()
 Widget _buildMonthlyMaidSection(String title) {
  final List<Service> monthlyServices = [
    Service('assets/service_monthly.png', 'ບໍລິການແມ່ບ້ານລາຍເດືອນ'),
    // เพิ่มได้ตามต้องการ
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildSectionHeader(title),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: monthlyServices.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final service = monthlyServices[index];
            return GestureDetector(
               onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingMonthlyScreen(service: service),
            ),
          );
        },
              child: Column(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(service.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4A4A),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}

  // --------------------
}