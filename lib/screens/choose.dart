import 'package:flutter/material.dart';

import 'auth/ui/register.dart';
import 'auth/ui/login.dart';

class ChoosePage extends StatefulWidget {
  @override
  _ChooseState createState() => _ChooseState();
}

class _ChooseState extends State<ChoosePage> {
  String selectedButton = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 47,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
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
                  size: 24,
                ),
              ),
            ),
          ),
          Positioned(
            top: 128,
            left: 0,
            child: Image.asset(
              'images/get.png',
              width: 400,
              height: 380,
            ),
          ),
          Positioned(
            top: 42,
            left: 109,
            child: Container(
              width: 175,
              height: 62,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                'Health Mate',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  height: 42 / 28,
                  color: Color(0xFF048581),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          Positioned(
            top: 520,
            left: 50,
            right: 50,
            child: Column(
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedButton = 'login';
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF036666), width: 2),
                    backgroundColor: selectedButton == 'login'
                        ? const Color(0xFF036666)
                        : Colors.transparent,
                    foregroundColor: selectedButton == 'login'
                        ? Colors.white
                        : const Color(0xFF036666),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedButton = 'register';
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF036666), width: 2),
                    backgroundColor: selectedButton == 'register'
                        ? const Color(0xFF036666)
                        : Colors.transparent,
                    foregroundColor: selectedButton == 'register'
                        ? Colors.white
                        : const Color(0xFF036666),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
