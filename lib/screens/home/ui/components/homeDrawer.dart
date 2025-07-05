import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/cosntants.dart';
import 'package:flutter_project/screens/auth/cubit/auth_cubit.dart';
import 'package:flutter_project/screens/auth/ui/login.dart';
import 'package:flutter_project/screens/help.dart';
import 'package:flutter_project/screens/privacy.dart';
import 'package:flutter_project/screens/setting/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homedrawer extends StatelessWidget {
  const Homedrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildDrawerItem(Icons.person, 'My Profile', context),
          _buildDrawerItemWithImage(
            'images/uil_setting.png',
            'Setting',
            context,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          _buildDrawerItemWithImage(
            'images/material-symbols-light_security (1).png',
            'Privacy & Policy',
            context,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPage()),
              );
            },
          ),
          _buildDrawerItemWithImage(
            'images/material-symbols_help-outline.png',
            'Help & Support',
            context,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpScreen()),
              );
            },
          ),
          _buildDrawerItemWithImage(
            'images/share.png',
            'Share',
            context,
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Share',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildShareIcon(
                                'images/logos_whatsapp-icon.png', 'WhatsApp'),
                            _buildShareIcon(
                                'images/logos_facebook.png', 'Facebook'),
                            _buildShareIcon(
                                'images/logos_telegram.png', 'Telegram'),
                            _buildShareIcon(
                                'images/icon-park_message-one.png', 'Chat'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFEFEF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'https://yourapp.link/share',
                                  style: TextStyle(color: Colors.black54),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy,
                                    color: Color(0xFF036666)),
                                onPressed: () {
                                  Clipboard.setData(const ClipboardData(
                                      text: 'https://yourapp.link/share'));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Link copied to clipboard!')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const Divider(),
          _buildDrawerItemWithImage(
            'images/material-symbols_logout.png',
            'Log out',
            context,
            onTap: () async {
              // إظهار تحميل
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );

              try {
                await context.read<AuthCubit>().logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              } catch (e) {
                Navigator.of(context).pop(); // إغلاق dialog التحميل
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: ${e.toString()}')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Center(child: Text('Error loading user data')),
          );
        }

        final prefs = snapshot.data!;
        final userName = prefs.getString(userNameKey) ?? 'UserName';
        final email = prefs.getString(emailKey) ?? 'user@example.com';

        return DrawerHeader(
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('images/Rectangle 1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 22),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF048581)),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      email,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF048581)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF048581))),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
      onTap: () => Navigator.pop(context),
    );
  }

  Widget _buildDrawerItemWithImage(
      String imagePath, String title, BuildContext context,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Image.asset(imagePath, width: 24, height: 24),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
      onTap: onTap ?? () => Navigator.pop(context),
    );
  }

  Widget _buildShareIcon(String imagePath, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Color(0xFFE0F2F1),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
          child: Image.asset(imagePath),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
