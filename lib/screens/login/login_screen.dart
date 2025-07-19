// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wisdom_management_app/screens/tabs/profile/register_student_screen/register_student.dart';
// import 'package:wisdom_management_app/services/auth_service.dart';
// import '../../constants/admin_constans.dart';
// import '../../constants/teachers_constants.dart';
// import '../../models/new_student_model/new_student.dart';
// import '../../theme/color_manager.dart';
// import '../tabs/home/home_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final AuthService _authService = AuthService();
//
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _secretKeyController = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//
//   UserType selectedUserType = UserType.parent;
//   bool isLoading = false;
//
//   void _onLoginPressed() async {
//     if (_formKey.currentState!.validate()) {
//       final email = _emailController.text.trim().toLowerCase();
//       final password = _passwordController.text.trim();
//       final secretKey = _secretKeyController.text.trim();
//       final prefs = await SharedPreferences.getInstance();
//
//       setState(() => isLoading = true);
//
//       try {
//         if (selectedUserType == UserType.admin) {
//           if (email == AdminConstants.adminEmail && secretKey == AdminConstants.adminPassKey) {
//             final user = await _authService.login(email: email, password: password);
//             if (user != null) {
//               await prefs.setString('userType', 'admin');
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Admin Login Successful!'), backgroundColor: Colors.green),
//               );
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const HomeScreen(userType: UserType.admin)),
//               );
//             }
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Invalid admin credentials!'), backgroundColor: Colors.red),
//             );
//           }
//         } else if (selectedUserType == UserType.teacher) {
//           if (secretKey == TeacherConstants.secretKey) {
//             final user = await _authService.login(email: email, password: password);
//             if (user != null) {
//               await prefs.setString('userType', 'teacher');
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Teacher Login Successful!'), backgroundColor: Colors.green),
//               );
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const HomeScreen(userType: UserType.teacher)),
//               );
//             }
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Invalid teacher secret key!'), backgroundColor: Colors.red),
//             );
//           }
//         } else {
//           // Parent login
//           final user = await _authService.login(email: email, password: password);
//           if (user != null) {
//             await prefs.setString('userType', 'parent');
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Parent Login Successful!'), backgroundColor: Colors.green),
//             );
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const HomeScreen(userType: UserType.parent)),
//             );
//           }
//         }
//       } on FirebaseAuthException catch (e) {
//         String message = 'Login failed.';
//         switch (e.code) {
//           case 'wrong-password': message = 'Incorrect password.'; break;
//           case 'user-not-found': message = 'No user found with this email.'; break;
//           default: message = e.message ?? 'Something went wrong.';
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(message), backgroundColor: Colors.red),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Unexpected error: ${e.toString()}'), backgroundColor: Colors.red),
//         );
//       } finally {
//         setState(() => isLoading = false);
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _secretKeyController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorManager.lightCoolGrey,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 80),
//             // Big title with calligraphy feel
//             Text(
//               'WISDOM',
//               style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                 color: ColorManager.tealAccent,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Snell Roundhand', // replace with your calligraphy font
//                 fontSize: 42,
//               ),
//             ),
//             Text(
//               'TUTORIALS',
//               style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                 color: ColorManager.tealAccent,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Snell Roundhand', // replace with your calligraphy font
//                 fontSize: 42,
//               ),
//             ),
//             const SizedBox(height: 30),
//             // Segmented control
//             CupertinoSegmentedControl<UserType>(
//               children: const {
//                 UserType.parent: Padding(padding: EdgeInsets.all(8.0), child: Text('Parent')),
//                 UserType.teacher: Padding(padding: EdgeInsets.all(8.0), child: Text('Teacher')),
//                 UserType.admin: Padding(padding: EdgeInsets.all(8.0), child: Text('Admin')),
//               },
//               groupValue: selectedUserType,
//               onValueChanged: (UserType value) {
//                 setState(() {
//                   selectedUserType = value;
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: Center(
//                 child: isLoading
//                     ? const CircularProgressIndicator()
//                     : SingleChildScrollView(
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         // Email
//                         TextFormField(
//                           controller: _emailController,
//                           decoration: InputDecoration(
//                             labelText: 'Email',
//                             labelStyle: const TextStyle(color: ColorManager.charcoalGray),
//                             border: const OutlineInputBorder(),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: ColorManager.tealAccent),
//                             ),
//                           ),
//                           validator: (value) =>
//                           value != null && value.contains('@') ? null : 'Enter a valid email',
//                         ),
//                         const SizedBox(height: 20),
//                         // Password
//                         TextFormField(
//                           controller: _passwordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             labelText: 'Password',
//                             labelStyle: const TextStyle(color: ColorManager.charcoalGray),
//                             border: const OutlineInputBorder(),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: ColorManager.tealAccent),
//                             ),
//                           ),
//                           validator: (value) =>
//                           value != null && value.length >= 6 ? null : 'Password must be 6+ characters',
//                         ),
//                         const SizedBox(height: 20),
//                         // Secret key for admin/teacher
//                         if (selectedUserType == UserType.teacher || selectedUserType == UserType.admin)
//                           Column(
//                             children: [
//                               TextFormField(
//                                 controller: _secretKeyController,
//                                 obscureText: true,
//                                 decoration: InputDecoration(
//                                   labelText: 'Secret Key',
//                                   labelStyle: const TextStyle(color: ColorManager.charcoalGray),
//                                   border: const OutlineInputBorder(),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(color: ColorManager.tealAccent),
//                                   ),
//                                 ),
//                                 validator: (value) =>
//                                 value != null && value.isNotEmpty ? null : 'Enter secret key',
//                               ),
//                               const SizedBox(height: 20),
//                             ],
//                           ),
//                         // Login button
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton.icon(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: ColorManager.tealAccent,
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               textStyle: const TextStyle(fontWeight: FontWeight.bold),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               elevation: 4,
//                             ),
//                             onPressed: _onLoginPressed,
//                             icon: const Icon(Icons.login),
//                             label: const Text('Login'),
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (_) => const RegisterStudentScreen()),
//                             );
//                           },
//                           child: const Text('Don\'t have an account? Register'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisdom_management_app/screens/tabs/profile/register_student_screen/register_student.dart';
import 'package:wisdom_management_app/services/auth_service.dart';
import '../../constants/admin_constans.dart';
import '../../constants/teachers_constants.dart';
import '../../models/new_student_model/new_student.dart';
import '../../theme/color_manager.dart';
import '../../utils/UserType.dart';
import '../tabs/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _secretKeyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  UserType selectedUserType = UserType.parent;
  bool isLoading = false;

  void _onLoginPressed() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim().toLowerCase();
      final password = _passwordController.text.trim();
      final secretKey = _secretKeyController.text.trim();
      final prefs = await SharedPreferences.getInstance();

      setState(() => isLoading = true);

      try {
        if (selectedUserType == UserType.admin) {
          if (email == AdminConstants.adminEmail && secretKey == AdminConstants.adminPassKey) {
            final user = await _authService.login(email: email, password: password);
            if (user != null) {
              await prefs.setString('userType', 'admin');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Admin Login Successful!'), backgroundColor: Colors.green),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen(userType: UserType.admin)),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid admin credentials!'), backgroundColor: Colors.red),
            );
          }
        } else if (selectedUserType == UserType.teacher) {
          if (secretKey == TeacherConstants.secretKey) {
            final user = await _authService.login(email: email, password: password);
            if (user != null) {
              await prefs.setString('userType', 'teacher');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Teacher Login Successful!'), backgroundColor: Colors.green),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen(userType: UserType.teacher)),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid teacher secret key!'), backgroundColor: Colors.red),
            );
          }
        } else {
          // Parent login
          final user = await _authService.login(email: email, password: password);
          if (user != null) {
            await prefs.setString('userType', 'parent');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Parent Login Successful!'), backgroundColor: Colors.green),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen(userType: UserType.parent)),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String message = 'Login failed.';
        switch (e.code) {
          case 'wrong-password':
            message = 'Incorrect password.';
            break;
          case 'user-not-found':
            message = 'No user found with this email.';
            break;
          default:
            message = e.message ?? 'Something went wrong.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _secretKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightCoolGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Segmented Control row
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top-right segmented control
                  Center(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0, right: 0), // adjust as you like
                        child: CupertinoSegmentedControl<UserType>(
                          children: const {
                            UserType.parent: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('Parent'),
                            ),
                            UserType.teacher: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('Teacher'),
                            ),
                            UserType.admin: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('Admin'),
                            ),
                          },
                          groupValue: selectedUserType,
                          onValueChanged: (UserType value) {
                            setState(() => selectedUserType = value);
                          },
                          selectedColor: ColorManager.tealAccent,
                          unselectedColor: Colors.white,
                          borderColor: ColorManager.tealAccent,
                          pressedColor: ColorManager.tealAccent.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // App title below
                  Text(
                    'WISDOM',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: ColorManager.tealAccent,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Snell Roundhand',
                      fontSize: 42,
                    ),
                  ),
                  Text(
                    'TUTORIALS',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: ColorManager.tealAccent,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Snell Roundhand',
                      fontSize: 42,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              // Form
              Expanded(
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: ColorManager.charcoalGray),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ColorManager.tealAccent),
                              ),
                            ),
                            validator: (value) =>
                            value != null && value.contains('@') ? null : 'Enter a valid email',
                          ),
                          const SizedBox(height: 20),
                          // Password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: ColorManager.charcoalGray),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ColorManager.tealAccent),
                              ),
                            ),
                            validator: (value) =>
                            value != null && value.length >= 6 ? null : 'Password must be 6+ characters',
                          ),
                          const SizedBox(height: 20),
                          // Secret Key for admin or teacher
                          if (selectedUserType == UserType.teacher || selectedUserType == UserType.admin)
                            Column(
                              children: [
                                TextFormField(
                                  controller: _secretKeyController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Secret Key',
                                    labelStyle: const TextStyle(color: ColorManager.charcoalGray),
                                    border: const OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: ColorManager.tealAccent),
                                    ),
                                  ),
                                  validator: (value) =>
                                  value != null && value.isNotEmpty ? null : 'Enter secret key',
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          // Login button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.tealAccent,
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
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const RegisterStudentScreen()),
                              );
                            },
                            child: const Text('Don\'t have an account? Register'),
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
      ),
    );
  }
}

