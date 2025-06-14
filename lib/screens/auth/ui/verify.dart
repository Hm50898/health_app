import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/screens/auth/cubit/auth_cubit.dart';
import 'package:flutter_project/screens/auth/ui/createNewPassword.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Verify extends StatefulWidget {
  final String email;

  const Verify({required this.email});

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final TextEditingController codeController = TextEditingController();
  bool hasError = false;
  String currentText = "";
  int resendAttempts = 0;
  bool canResend = true;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().sendVerificationCode(widget.email);
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  void _verifyCode() {
    if (currentText.length == 4) {
      context.read<AuthCubit>().verifyCode(widget.email, currentText);
    } else {
      setState(() {
        hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete verification code'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _resendCode() {
    if (canResend) {
      context.read<AuthCubit>().sendVerificationCode(widget.email);
      setState(() {
        resendAttempts++;
        canResend = false;
      });
      Future.delayed(const Duration(seconds: 60), () {
        if (mounted) {
          setState(() {
            canResend = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthVerifyCodeSuccessState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateNewPassword(email: widget.email),
            ),
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
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF028887),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF028887),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'Verify Your Email',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF048581),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0x1A048581),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Image(
                            image: AssetImage('images/mail.png'),
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        'Verification code sent to:\n${widget.email}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000000),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: const TextStyle(
                          color: Color(0xFF048581),
                          fontWeight: FontWeight.bold,
                        ),
                        length: 4,
                        obscureText: false,
                        obscuringCharacter: '*',
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: 50,
                          fieldWidth: 50,
                          activeFillColor: Colors.white,
                          activeColor: const Color(0xFF048581),
                          selectedColor: const Color(0xFF048581),
                          inactiveColor: const Color(0xFF048581),
                        ),
                        cursorColor: const Color(0xFF048581),
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: false,
                        errorAnimationController: null,
                        controller: codeController,
                        keyboardType: TextInputType.number,
                        onCompleted: (v) {
                          _verifyCode();
                        },
                        onChanged: (value) {
                          setState(() {
                            currentText = value;
                            hasError = false;
                          });
                        },
                        beforeTextPaste: (text) {
                          return true;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: canResend ? _resendCode : null,
                        child: Text(
                          canResend
                              ? 'Resend Code'
                              : 'Wait ${60 - (resendAttempts * 60)} seconds',
                          style: TextStyle(
                            color: canResend
                                ? const Color(0xFF048581)
                                : Colors.grey,
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              state is AuthLoadingState ? null : _verifyCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF048581),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                                  'Verify',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                        ),
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
}
