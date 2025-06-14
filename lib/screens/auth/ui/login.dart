import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/screens/auth/cubit/auth_cubit.dart';

import 'forget.dart';
import '../../home/ui/home.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          if (state is AuthLoginSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 700,
                    decoration: const BoxDecoration(
                      color: const Color(0xFFF0F0F0),
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
                  // Positioned(
                  //   top: 45,
                  //   left: 20,
                  //   child: Align(
                  //     alignment: Alignment.topLeft,
                  //     child: GestureDetector(
                  //       onTap: () => Navigator.pop(context),
                  //       child: Container(
                  //         width: 40,
                  //         height: 40,
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           shape: BoxShape.circle,
                  //           border: Border.all(
                  //               color: const Color(0xFF028887), width: 2),
                  //         ),
                  //         child: const Icon(Icons.arrow_back,
                  //             color: Color(0xFF028887), size: 20),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                    top: 90,
                    left: 130,
                    child: Container(
                      width: 175,
                      height: 62,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        'Welcome Back !',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 42 / 28,
                          color: Color(0xFF000000),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 0,
                    child: Image.asset(
                      'images/preview 1.png',
                      width: 400,
                      height: 380,
                    ),
                  ),
                  Positioned(
                    top: 400,
                    left: 18,
                    child: Container(
                      width: 353,
                      height: 51,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0x1A000000),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Your Email',
                          hintStyle: TextStyle(
                            color: Color(0x80048581),
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!_isValidEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 470,
                    left: 18,
                    child: Container(
                      width: 353,
                      height: 51,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0x1A000000),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Enter Your Password',
                          hintStyle: const TextStyle(
                            color: Color(0x80048581),
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 560,
                    left: 120,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetPassword()),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF0F0F0),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Forget Password',
                        style: TextStyle(
                          color: Color(0xCC048581),
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 650,
                    left: 40,
                    child: SizedBox(
                      width: 320,
                      height: 50,
                      child: GestureDetector(
                        onTap: state is AuthLoadingState
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().login(
                                        emailController.text.trim(),
                                        passwordController.text,
                                      );
                                }
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
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 700,
                    left: 80,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF0F0F0),
                        padding: EdgeInsets.zero,
                      ),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Don’t have an account? ',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: 'Sign Up',
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
