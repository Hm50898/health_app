import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/screens/auth/cubit/auth_cubit.dart';
import 'package:flutter_project/screens/auth/ui/login.dart';
import 'package:flutter_project/screens/auth/ui/verify.dart';
import 'package:intl/intl.dart';

class PatientInfo extends StatefulWidget {
  final String userId;
  final int selectedGender;
  final String email;

  const PatientInfo({
    required this.userId,
    required this.selectedGender,
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  State<PatientInfo> createState() => _RemainState();
}

class _RemainState extends State<PatientInfo> {
  String? selectedGovernorate;
  TextEditingController birthDateController = TextEditingController();
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  DateTime? selectedDate;

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
    'Beni Suef'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now()
          .subtract(const Duration(days: 365 * 18)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF036666),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF036666),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthPatientRegisterSuccessState) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Verify(email: widget.email)),
          );
        }
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
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
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          width: double.infinity,
                          height: 51,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0x2B000000)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  birthDateController.text.isEmpty
                                      ? 'Birth Date'
                                      : birthDateController.text,
                                  style: TextStyle(
                                    color: birthDateController.text.isEmpty
                                        ? const Color(0x80048581)
                                        : Colors.black,
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.calendar_today,
                                color: Color(0xFF036666),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      buildInputField('National ID', nationalIdController,
                          TextInputType.number),
                      const SizedBox(height: 15),
                      buildInputField(
                          'City', cityController, TextInputType.text),
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
                          context.read<AuthCubit>().registerPatient(
                                nationalId: nationalIdController.text.trim(),
                                nationalIdImageUrl:
                                    "img.png", // سيتم تغييرها لاحقاً
                                birthDate: birthDateController.text.trim(),
                                gender: widget.selectedGender,
                                governorate: selectedGovernorate!,
                                city: cityController.text.trim(),
                                applicationUserId: widget.userId,
                              );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 51,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF028887),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: state is AuthLoadingState
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
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
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
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
      },
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
