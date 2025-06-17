import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/cosntants.dart';
import 'package:flutter_project/screens/home/cubit/home_states.dart';
import 'package:flutter_project/screens/home/ui/components/actionButton.dart';
import 'package:flutter_project/screens/home/ui/components/homeDrawer.dart';
import 'package:flutter_project/screens/home/ui/components/serviceItem.dart';
import 'package:flutter_project/screens/privacy.dart';
import 'package:flutter_project/screens/profile.dart';
import 'package:flutter_project/screens/recommendation.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/services.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/medicine.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/ibm.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/disease_list.dart';
import 'package:flutter_project/screens/home/models/health_record_model.dart';
import 'package:flutter_project/screens/document.dart';
import 'package:flutter_project/screens/home/cubit/home_cubit.dart';
import '../../family.dart';
import 'generalHealth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Calculate dynamic sizes based on screen dimensions
    const horizontalPadding = 22.0;
    final verticalPadding = screenHeight * 0.02;
    final iconSize = screenWidth * 0.1;
    final badgeSize = screenWidth * 0.08;
    final cardHeight = screenHeight * 0.25;
    final imageSize = screenWidth * 0.3;
    const fontSize = 25.0;
    const smallFontSize = 18.0;
    final buttonSize = screenWidth * 0.12;

    return BlocProvider(
      create: (context) => HomeCubit()..getHealthRecordSummary(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();

          return Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.white.withOpacity(0.2),
              leading: IconButton(
                icon: Icon(Icons.menu,
                    color: const Color(0xFF036666), size: screenWidth * 0.06),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              elevation: 0,
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: horizontalPadding),
                  child: Row(
                    children: [
                      _buildTransformedImage('images/Primary.png', iconSize),
                      SizedBox(width: screenWidth * 0.02),
                      _buildStackedImages(iconSize, badgeSize),
                    ],
                  ),
                ),
              ],
            ),
            drawer: const Homedrawer(),
            floatingActionButton: FloatingActionButton(
              mini: true,
              backgroundColor: const Color(0xFF036666),
              onPressed: () {
                cubit.toggleButtonsVisibility();
              },
              child: Icon(cubit.isButtonsVisible ? Icons.close : Icons.add),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hello, Ali',
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF036666))),
                        SizedBox(height: verticalPadding * 0.5),
                        const Text(
                          'Save time and money, get the best medical service.',
                          style: TextStyle(
                              fontSize: smallFontSize,
                              height: 1.5,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF036666)),
                        ),
                        SizedBox(height: verticalPadding),
                        _buildSearchBar(screenWidth),
                        SizedBox(height: verticalPadding),
                        _buildPromoCard(context, cardHeight, imageSize,
                            fontSize, smallFontSize),
                        SizedBox(height: verticalPadding),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Health Record',
                              style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF036666)),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.03,
                                    vertical: verticalPadding * 0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.03),
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
                                    fontSize: smallFontSize,
                                    color:
                                        const Color(0xFF036666).withAlpha(133),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: verticalPadding * 0.6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ServiceItem(
                              imagePath: 'images/Primary(2).png',
                              label: 'Medicine',
                              onTap: () {
                                if (state is HealthRecordSummaryLoaded) {
                                  final healthRecord =
                                      HealthRecordModel.fromJson(state.data);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MedicinePage(
                                        medicinesSummary:
                                            healthRecord.medicinesSummary,
                                      ),
                                    ),
                                  );
                                } else {
                                  cubit.getHealthRecordSummary();
                                }
                              },
                            ),
                            ServiceItem(
                              imagePath: 'images/Primary (3).png',
                              label: 'IBM',
                              onTap: () {
                                if (state is HealthRecordSummaryLoaded) {
                                  final healthRecord =
                                      HealthRecordModel.fromJson(state.data);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => IBMPage(
                                        encountersSummary:
                                            healthRecord.encountersSummary,
                                      ),
                                    ),
                                  );
                                } else {
                                  cubit.getHealthRecordSummary();
                                }
                              },
                            ),
                            ServiceItem(
                              imagePath: 'images/Primary (4).png',
                              label: 'Disease',
                              onTap: () {
                                if (state is HealthRecordSummaryLoaded) {
                                  final healthRecord =
                                      HealthRecordModel.fromJson(state.data);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DiseaseListScreen(
                                        conditionsSummary:
                                            healthRecord.conditionsSummary,
                                      ),
                                    ),
                                  );
                                } else {
                                  cubit.getHealthRecordSummary();
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: verticalPadding),
                        _buildSecondPromoCard(context, cubit, cardHeight,
                            imageSize, fontSize, smallFontSize, buttonSize),
                        SizedBox(height: screenHeight * 0.12),
                      ],
                    ),
                  ),
                ),
                if (cubit.isButtonsVisible)
                  Positioned(
                    right: horizontalPadding,
                    bottom: screenHeight * 0.15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ActionButton(
                          text: 'Add Medicine',
                          imagePath: 'images/medicine+.png',
                          onPressed: () {
                            if (state is HealthRecordSummaryLoaded) {
                              final healthRecord =
                                  HealthRecordModel.fromJson(state.data);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MedicinePage(
                                    medicinesSummary:
                                        healthRecord.medicinesSummary,
                                  ),
                                ),
                              );
                            } else {
                              cubit.getHealthRecordSummary();
                            }
                          },
                          topPadding: verticalPadding,
                        ),
                        ActionButton(
                          text: 'Add Document',
                          imagePath: 'images/document.png',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DocumentPage()),
                            );
                          },
                          topPadding: verticalPadding,
                        ),
                        ActionButton(
                          text: 'Add family member',
                          imagePath: 'images/medicine+.png',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FamilyPage()),
                            );
                          },
                          topPadding: verticalPadding,
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
              selectedFontSize: smallFontSize,
              unselectedFontSize: smallFontSize,
              onTap: (index) {
                cubit.changeIndex(index);
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
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: verticalPadding * 0.5),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('images/preview.png',
                            width: buttonSize, height: buttonSize),
                        Image.asset('images/home.png',
                            width: buttonSize * 0.8, height: buttonSize * 0.8),
                      ],
                    ),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('images/report.png',
                      width: buttonSize * 0.8, height: buttonSize * 0.8),
                  label: 'Report',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('images/recommendation.png',
                      width: buttonSize * 0.8, height: buttonSize * 0.8),
                  label: 'Recommendation',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('images/profile.png',
                      width: buttonSize * 0.8, height: buttonSize * 0.8),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(double screenWidth) {
    return Container(
      width: double.infinity,
      height: screenWidth * 0.12,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        border: Border.all(color: const Color(0x2B000000)),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
              color: const Color(0x80048581),
              fontSize: screenWidth * 0.045,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.02, horizontal: screenWidth * 0.04),
          suffixIcon: Icon(Icons.search,
              color: const Color(0xFF036666), size: screenWidth * 0.06),
        ),
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context, double cardHeight,
      double imageSize, double fontSize, double smallFontSize) {
    return Container(
      width: double.infinity,
      height: cardHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFA3DAF2),
        borderRadius: BorderRadius.circular(cardHeight * 0.12),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: cardHeight * 0.05),
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
                    padding: EdgeInsets.symmetric(
                        horizontal: 0, vertical: cardHeight * 0.04),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(cardHeight * 0.04),
                    ),
                  ),
                  child: Text(
                    'General',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  'Health',
                  style: TextStyle(
                      fontSize: fontSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: cardHeight * 0.05),
                Text(
                  'Your medical record',
                  style: TextStyle(fontSize: smallFontSize),
                ),
              ],
            ),
          ),
          const Spacer(),
          Image.asset('images/homeone.png',
              width: imageSize, height: imageSize),
        ],
      ),
    );
  }

  Widget _buildSecondPromoCard(
      BuildContext context,
      HomeCubit cubit,
      double cardHeight,
      double imageSize,
      double fontSize,
      double smallFontSize,
      double buttonSize) {
    return Container(
      width: double.infinity,
      height: cardHeight,
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: const Color(0xFFA3DAF2),
        borderRadius: BorderRadius.circular(cardHeight * 0.12),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: cardHeight * 0.01),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact',
                        style: TextStyle(
                            fontSize: fontSize * 1.2,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: cardHeight * 0.05),
                    Text('Your Doctor',
                        style: TextStyle(
                            fontSize: fontSize, fontWeight: FontWeight.bold)),
                    SizedBox(height: cardHeight * 0.05),
                    Text('Get simple consultaion.',
                        style: TextStyle(fontSize: smallFontSize)),
                  ],
                ),
              ),
              const Spacer(),
              Image.asset('images/Online Doctor-rafiki 1.png',
                  width: imageSize, height: imageSize * 1.05),
            ],
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

  Widget _buildStackedImages(double iconSize, double badgeSize) {
    return Stack(
      children: [
        _buildTransformedImage('images/Primary(1).png', iconSize),
        Positioned(
          top: iconSize * 0.1,
          left: iconSize * 0.35,
          child: Image.asset('images/Ellipse216.png',
              width: badgeSize, height: badgeSize),
        ),
      ],
    );
  }
}
