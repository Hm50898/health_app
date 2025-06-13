import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/screens/auth/cubit/auth_cubit.dart';
import '../../gender.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  // متغيرات لتتبع حالة الخطأ لكل حقل
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _phoneNumberError;
  String? _imageError;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccessState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GenderSelection(userId: state.userId),
            ),
          );
        }
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final authCubit = context.read<AuthCubit>();

        // دالة للتحقق من صحة البريد الإلكتروني
        bool _isValidEmail(String email) {
          return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
        }

        // دالة للتحقق من صحة كلمة المرور
        bool _isValidPassword(String password) {
          return RegExp(
                  r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
              .hasMatch(password);
        }

        // دالة للتحقق من الحقول قبل الإرسال
        bool _validateFields() {
          bool isValid = true;

          setState(() {
            // التحقق من الحقول المطلوبة
            _firstNameError = _firstNameController.text.isEmpty
                ? 'First name is required'
                : null;
            _lastNameError = _lastNameController.text.isEmpty
                ? 'Last name is required'
                : null;
            _emailError = _emailController.text.isEmpty
                ? 'Email is required'
                : !_isValidEmail(_emailController.text)
                    ? 'Invalid email format'
                    : null;
            _passwordError = _passwordController.text.isEmpty
                ? 'Password is required'
                : !_isValidPassword(_passwordController.text)
                    ? 'Password must be at least 8 characters with one letter, one number and one special character'
                    : null;
            _confirmPasswordError = _confirmPasswordController.text.isEmpty
                ? 'Please confirm your password'
                : _passwordController.text != _confirmPasswordController.text
                    ? 'Passwords do not match'
                    : null;
            _phoneNumberError = _phoneNumberController.text.isEmpty
                ? 'Phone number is required'
                : null;
            _imageError = authCubit.profileImage == null
                ? 'Profile image is required'
                : null;

            // التحقق من وجود أي أخطاء
            if (_firstNameError != null ||
                _lastNameError != null ||
                _emailError != null ||
                _passwordError != null ||
                _confirmPasswordError != null ||
                _phoneNumberError != null ||
                _imageError != null) {
              isValid = false;
            }
          });

          return isValid;
        }

        // دالة للإرسال بعد التحقق
        void _validateAndSubmit() {
          if (_validateFields()) {
            authCubit.register(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              email: _emailController.text,
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
              phoneNumber: _phoneNumberController.text,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please fix all errors')),
            );
          }
        }

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    // ... (بقية عناصر الواجهة كما هي) ...

                    Positioned(
                      top: 120,
                      left: MediaQuery.of(context).size.width / 2 - 50,
                      child: GestureDetector(
                        onTap: () {
                          authCubit.pickProfileImage().then((_) {
                            setState(() {
                              _imageError = authCubit.profileImage == null
                                  ? 'Profile image is required'
                                  : null;
                            });
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            BlocBuilder<AuthCubit, AuthState>(
                              buildWhen: (previous, current) =>
                                  current is AuthInitialState,
                              builder: (context, state) {
                                return CircleAvatar(
                                  radius: 50,
                                  backgroundColor: _imageError != null
                                      ? Colors.red[100]
                                      : Colors.grey[300],
                                  backgroundImage: authCubit.profileImage !=
                                          null
                                      ? FileImage(authCubit.profileImage!)
                                      : const AssetImage(
                                              'images/add personal photo.png')
                                          as ImageProvider,
                                );
                              },
                            ),
                            if (_imageError != null)
                              Positioned(
                                bottom: 0,
                                child: Text(
                                  _imageError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            // ... (بقية عناصر الصورة) ...
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 240,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _firstNameController,
                                  decoration: _inputDecoration(
                                    'First name',
                                    _firstNameError,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _firstNameError = value.isEmpty
                                          ? 'First name is required'
                                          : null;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _lastNameController,
                                  decoration: _inputDecoration(
                                    'Last name',
                                    _lastNameError,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _lastNameError = value.isEmpty
                                          ? 'Last name is required'
                                          : null;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          TextField(
                            controller: _emailController,
                            decoration: _inputDecoration(
                              'Email',
                              _emailError,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              setState(() {
                                _emailError = value.isEmpty
                                    ? 'Email is required'
                                    : !_isValidEmail(value)
                                        ? 'Invalid email format'
                                        : null;
                              });
                            },
                          ),
                          const SizedBox(height: 25),
                          TextField(
                            controller: _passwordController,
                            decoration: _inputDecoration(
                              'Password',
                              _passwordError,
                            ),
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                _passwordError = value.isEmpty
                                    ? 'Password is required'
                                    : !_isValidPassword(value)
                                        ? 'Password must be at least 8 characters with one letter, one number and one special character'
                                        : null;
                              });
                            },
                          ),
                          const SizedBox(height: 25),
                          TextField(
                            controller: _confirmPasswordController,
                            decoration: _inputDecoration(
                              'Confirm Password',
                              _confirmPasswordError,
                            ),
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                _confirmPasswordError = value.isEmpty
                                    ? 'Please confirm your password'
                                    : _passwordController.text != value
                                        ? 'Passwords do not match'
                                        : null;
                              });
                            },
                          ),
                          const SizedBox(height: 25),
                          TextField(
                            controller: _phoneNumberController,
                            decoration: _inputDecoration(
                              'Phone Number',
                              _phoneNumberError,
                            ),
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              setState(() {
                                _phoneNumberError = value.isEmpty
                                    ? 'Phone number is required'
                                    : null;
                              });
                            },
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: ElevatedButton(
                              onPressed: state is AuthLoadingState
                                  ? null
                                  : _validateAndSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF036666),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 150, vertical: 20),
                              ),
                              child: state is AuthLoadingState
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      'Next',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // دالة معدلة لإضافة لون الحدود الأحمر عند وجود خطأ
  InputDecoration _inputDecoration(String hint, String? errorText) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0x80048581)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: errorText != null ? Colors.red : const Color(0x1A000000),
          width: 3,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: errorText != null ? Colors.red : const Color(0x1A000000),
          width: 3,
        ),
      ),
      errorText: errorText,
      errorStyle: const TextStyle(color: Colors.red),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 3,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 3,
        ),
      ),
    );
  }
}
