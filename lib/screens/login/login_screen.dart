import 'package:flutter/material.dart';
import 'package:wisdom_management_app/constants/user_type.dart';
import '../../constants/admin_constans.dart';
import '../../theme/color_manager.dart';
import '../tabs/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _adminKeyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool get _isAdmin =>
      _emailController.text.trim().toLowerCase() == AdminConstants.adminEmail;

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim().toLowerCase();
      final password = _passwordController.text.trim();

      if (email == AdminConstants.adminEmail) {
        // Check admin key
        final adminKey = _adminKeyController.text.trim();
        if (adminKey == AdminConstants.adminPassKey) {
          // Admin login successful
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Admin Login Successful!'), backgroundColor: Colors.green),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen(userType: UserType.admin)),
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid admin key!'), backgroundColor: Colors.red),
          );
        }
      } else {
        // Normal student login (demo)
        const demoEmail = 'demo@user.com';
        const demoPassword = '123456';

        if (email == demoEmail && password == demoPassword) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Successful!'), backgroundColor: Colors.green),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen(userType: UserType.student)),
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid credentials.'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _adminKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightCoolGrey,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 120),
            Text(
              'WISDOM',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: ColorManager.burntOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'TUTORIALS',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: ColorManager.burntOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(color: ColorManager.goldenSand),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: ColorManager.burntOrange),
                            ),
                          ),
                          validator: (value) => value != null && value.contains('@')
                              ? null
                              : 'Enter a valid email',
                          onChanged: (_) => setState(() {}), // refresh UI
                        ),
                        const SizedBox(height: 20),
                        // Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: ColorManager.goldenSand),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: ColorManager.burntOrange),
                            ),
                          ),
                          validator: (value) => value != null && value.length >= 6
                              ? null
                              : 'Password must be 6+ characters',
                        ),
                        const SizedBox(height: 20),

                        // Only show admin key if email matches admin
                        if (_isAdmin)
                          Column(
                            children: [
                              TextFormField(
                                controller: _adminKeyController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Admin Key',
                                  labelStyle: const TextStyle(color: ColorManager.goldenSand),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: ColorManager.burntOrange),
                                  ),
                                ),
                                validator: (value) => value != null && value.isNotEmpty
                                    ? null
                                    : 'Enter admin key',
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.burntOrange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            onPressed: _onLoginPressed,
                            icon: const Icon(Icons.login),
                            label: const Text('Login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
