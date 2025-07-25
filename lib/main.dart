import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/screens/auth/cubit/auth_cubit.dart';
import 'package:flutter_project/screens/home/cubit/home_cubit.dart';
import 'package:flutter_project/screens/auth/ui/forget.dart';
import 'package:flutter_project/screens/auth/ui/login.dart';
import 'package:flutter_project/screens/auth/ui/register.dart';
import 'package:flutter_project/screens/home/ui/components/gad.dart';
import 'package:flutter_project/screens/home/ui/home.dart';
import 'screens/home/ui/components/phq.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()..initialize()),
        BlocProvider(create: (context) => HomeCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'helthy',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return LoginPage();
            } else if (state is AuthLoginSuccessState) {
              return HomePage();
            } else {
              return LoginPage();
            }
          },
        ),
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/forget': (context) => ForgetPassword(),
          '/home': (context) => HomePage(),
          '/phd': (context) => const PhqScreen(),
          '/gad': (context) => const GadScreen(),
        },
      ),
    );
  }
}
