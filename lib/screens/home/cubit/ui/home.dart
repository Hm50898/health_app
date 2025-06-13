import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/cosntants.dart';
import 'package:flutter_project/screens/home/cubit/home_states.dart';
import 'package:flutter_project/screens/home/cubit/ui/components/actionButton.dart';
import 'package:flutter_project/screens/home/cubit/ui/components/homeDrawer.dart';
import 'package:flutter_project/screens/home/cubit/ui/components/serviceItem.dart';
import 'package:flutter_project/screens/privacy.dart';
import 'package:flutter_project/screens/profile.dart';
import 'package:flutter_project/screens/recommendation.dart';
import 'package:flutter_project/screens/services.dart';
import 'package:flutter_project/screens/medicine.dart';
import 'package:flutter_project/screens/document.dart';
import 'package:flutter_project/screens/setting.dart';
import 'package:flutter_project/screens/home/cubit/home_cubit.dart';
import '../../../family.dart';
import '../../../general.dart';
import '../../../help.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();

          return Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.white.withOpacity(0.2),
              leading: IconButton(
                icon: const Icon(Icons.menu, color: mainColor),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      _buildTransformedImage('images/Primary.png', 40),
                      const SizedBox(width: 10),
                      _buildStackedImages(),
                    ],
                  ),
                ),
              ],
            ),
            drawer: const Homedrawer(),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 41),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hello, Ali',
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: mainColor)),
                        const SizedBox(height: 4),
                        const Text(
                          'Save time and money, get the best medical service.',
                          style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: mainColor),
                        ),
                        const SizedBox(height: 8),
                        _buildSearchBar(),
                        const SizedBox(height: 20),
                        _buildPromoCard(context),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Health Record',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: mainColor),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Services()),
                                );
                              },
                              child: Text(
                                'See all',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: mainColor.withOpacity(0.52),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ignore: prefer_const_constructors
                            ServiceItem(
                              imagePath: 'images/Primary(2).png',
                              label: 'Medicine',
                            ),
                            ServiceItem(
                                imagePath: 'images/Primary (3).png',
                                label: 'BMI'),
                            ServiceItem(
                                imagePath: 'images/Primary (4).png',
                                label: 'Disease'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSecondPromoCard(context, cubit),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
                if (cubit.showButtons)
                  Positioned(
                    right: 16,
                    bottom: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ActionButton(
                          text: 'Add Medicine',
                          imagePath: 'images/medicine+.png',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Medicine()),
                            );
                          },
                          topPadding: 10,
                        ),
                        ActionButton(
                          text: 'Add Document',
                          imagePath: 'images/document.png',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Document()),
                            );
                          },
                          topPadding: 10,
                        ),
                        ActionButton(
                          text: 'Add family member',
                          imagePath: 'images/medicine+.png',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Family()),
                            );
                          },
                          topPadding: 10,
                        ),
                      ],
                    ),
                  )
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color(0xFF036666),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              currentIndex: cubit.selectedIndex,
              onTap: (index) {
                cubit.changeSelectedIndex(index);
                if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RecommendationPage()),
                  );
                }
                if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('images/preview.png',
                            width: 30, height: 30),
                        Image.asset('images/home.png', width: 24, height: 24),
                      ],
                    ),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('images/report.png', width: 24, height: 24),
                  label: 'Report',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('images/recommendation.png',
                      width: 24, height: 24),
                  label: 'Recommendation',
                ),
                BottomNavigationBarItem(
                  icon:
                      Image.asset('images/profile.png', width: 24, height: 24),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // باقي الدوال المساعدة تبقى كما هي بدون تغيير
  Widget _buildSearchBar() {
    return Container(
      width: 349,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x2B000000)),
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
              color: Color(0x80048581),
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          suffixIcon: Icon(Icons.search, color: Color(0xFF036666), size: 25),
        ),
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 194,
      decoration: BoxDecoration(
        color: const Color(0xFFA3DAF2),
        borderRadius: borderRadius,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GeneralHealth()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA3DAF2),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'General',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Text(
                  'Health',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your medical record',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const Spacer(),
          Image.asset('images/homeone.png', width: 161, height: 161),
        ],
      ),
    );
  }

  Widget _buildSecondPromoCard(BuildContext context, HomeCubit cubit) {
    return Container(
      width: double.infinity,
      height: 194,
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: const Color(0xFFA3DAF2),
        borderRadius: borderRadius,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('Your Doctor',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('Get simple consultaion.',
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const Spacer(),
              Image.asset('images/Online Doctor-rafiki 1.png',
                  width: 161, height: 171),
            ],
          ),
          Positioned(
            top: 160,
            left: 280,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: mainColor,
              onPressed: () {
                cubit.toggleButtonsVisibility();
              },
              child: Icon(cubit.showButtons ? Icons.close : Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransformedImage(String imagePath, double size) {
    return Transform.rotate(
      angle: 5 * 3.1415927 / 180,
      child: Image.asset(imagePath, width: size, height: size),
    );
  }

  Widget _buildStackedImages() {
    return Stack(
      children: [
        _buildTransformedImage('images/Primary(1).png', 40),
        Positioned(
          top: 3,
          left: 14,
          child: Image.asset('images/Ellipse216.png', width: 30, height: 30),
        ),
      ],
    );
  }
}
