import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project/screens/auth/ui/login.dart';
import 'package:flutter_project/screens/verify.dart';

class Remain extends StatefulWidget {
  final String userId;
  final int selectedGender;

  const Remain({required this.userId, required this.selectedGender, Key? key})
      : super(key: key);

  @override
  State<Remain> createState() => _RemainState();
}

class _RemainState extends State<Remain> {
  String? selectedGovernorate;
  TextEditingController birthDateController = TextEditingController();
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  List<String> governorates = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Aswan',
    'Sharqia',
    'Gharbia',
    'Monufia',
    'Qena',
    'Minya',
    'Sohag',
    'Port Said',
    'Damietta',
    'Fayoum',
    'Red Sea',
    'Asyut',
    'Dakahlia',
    'Kafr El Sheikh',
    'Beni Suef',
    'North Sinai',
    'South Sinai',
    'Luxor',
    'Matrouh',
    'New Valley',
    'Sharqiyah',
    'Suez',
    'Beni Suef',
    'Damietta',
  ];

  Future<void> submitPatientData() async {
    final url = Uri.parse('http://healthmate.runasp.net/api/Patient');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nationalId': nationalIdController.text.trim(),
        'nationalIdImageUrl': 'string', // يمكنك تعديلها لاحقًا عند رفع صورة
        'birthDate': birthDateController.text.trim(),
        'gender': widget.selectedGender,
        'governorate': selectedGovernorate ?? '',
        'city': cityController.text.trim(),
        'userId': widget.userId,
        'isVerified': false,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Data submitted successfully');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Verify()));
    } else {
      print('Failed to submit data. Status: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 700,
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              margin: const EdgeInsets.only(top: 90),
            ),
            Positioned(
              top: -40,
              left: 269,
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: Color(0x3F048581),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: -20,
              left: 289,
              child: Container(
                width: 160,
                height: 160,
                decoration: const BoxDecoration(
                  color: Color(0xFF048581),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 45),
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF028887), width: 2),
                        ),
                        child: const Icon(Icons.arrow_back,
                            color: Color(0xFF028887), size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'images/Mobile login-amico 1.png',
                          height: 250,
                          width: 600,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildInputField('Birth Date', birthDateController,
                      TextInputType.datetime),
                  const SizedBox(height: 15),
                  buildInputField('National ID', nationalIdController,
                      TextInputType.number),
                  const SizedBox(height: 15),
                  buildInputField('City', cityController, TextInputType.text),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x2B000000)),
                    ),
                    child: DropdownButton<String>(
                      value: selectedGovernorate,
                      hint: const Text(
                        'Select Governorate',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0x80048581),
                        ),
                      ),
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: governorates.map((String governorate) {
                        return DropdownMenuItem<String>(
                          value: governorate,
                          child: Text(governorate),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGovernorate = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      if (birthDateController.text.isEmpty ||
                          nationalIdController.text.isEmpty ||
                          cityController.text.isEmpty ||
                          selectedGovernorate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please fill all fields')),
                        );
                        return;
                      }
                      submitPatientData();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 51,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF028887),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 51,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                color: Color(0xFF028887),
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(
      String hint, TextEditingController controller, TextInputType type) {
    return Container(
      width: double.infinity,
      height: 51,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x2B000000)),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0x80048581),
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        keyboardType: type,
      ),
    );
  }
}
