// import 'package:flutter/material.dart';
// import 'package:wisdom_management_app/services/auth_service.dart';
// import '../../../models/new_student_model/new_student.dart' show Student;
// import '../../login/login_screen.dart';
//
// class ProfileScreen extends StatelessWidget {
//   final Student student;
//   final AuthService _authService = AuthService();
//
//   ProfileScreen({super.key, required this.student});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             // Avatar & name
//             Center(
//               child: Column(
//                 children: [
//                   const CircleAvatar(
//                     radius: 60,
//                     backgroundColor: Colors.deepPurple,
//                     child: Icon(Icons.person, size: 40, color: Colors.white),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     student.name,
//                     style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
//                   ),
//                   Text(
//                     'Class: ${student.studentClass}',
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // Profile details
//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.school, color: Colors.deepPurple),
//                 title: const Text('School'),
//                 subtitle: Text(student.school),
//               ),
//             ),
//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.calendar_today, color: Colors.deepPurple),
//                 title: const Text('Date of Birth'),
//                 subtitle: Text('${student.dob.day}/${student.dob.month}/${student.dob.year}'),
//               ),
//             ),
//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.date_range, color: Colors.deepPurple),
//                 title: const Text('Joined Date'),
//                 subtitle: Text('${student.joined.day}/${student.joined.month}/${student.joined.year}'),
//               ),
//             ),
//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.phone, color: Colors.deepPurple),
//                 title: const Text('Father\'s Phone'),
//                 subtitle: Text(student.fatherPhone),
//               ),
//             ),
//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.phone, color: Colors.deepPurple),
//                 title: const Text('Mother\'s Phone'),
//                 subtitle: Text(student.motherPhone),
//               ),
//             ),
//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.email, color: Colors.deepPurple),
//                 title: const Text('Parent Email'),
//                 subtitle: Text(student.parentEmail ?? 'N/A'),
//               ),
//             ),
//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.home, color: Colors.deepPurple),
//                 title: const Text('Address'),
//                 subtitle: Text(student.address),
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // Logout
//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.logout, color: Colors.deepPurple),
//                 title: const Text('Logout'),
//                 onTap: () async {
//                   final shouldLogout = await showDialog<bool>(
//                     context: context,
//                     builder: (_) => AlertDialog(
//                       title: const Text('Logout'),
//                       content: const Text('Are you sure you want to logout?', style: TextStyle(color: Colors.black)),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context, false),
//                           child: const Text('Cancel'),
//                         ),
//                         TextButton(
//                           onPressed: () => Navigator.pop(context, true),
//                           child: const Text('Logout'),
//                         ),
//                       ],
//                     ),
//                   );
//                   if (shouldLogout == true) {
//                     await _authService.logout();
//                     Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(builder: (_) => const LoginScreen()),
//                           (route) => false,
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisdom_management_app/services/auth_service.dart';
import '../../../models/new_student_model/new_student.dart' show Student;
import '../../login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Student student;

  const ProfileScreen({super.key, required this.student});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadImagePath();
  }

  Future<void> _loadImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('profileImageMap');
    if (jsonString != null) {
      final imageMap = Map<String, String>.from(jsonDecode(jsonString));
      setState(() {
        _imagePath = imageMap[widget.student.uuid];
      });
    }
  }

  Future<void> _pickAndSaveImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();

      // Load existing map
      final jsonString = prefs.getString('profileImageMap');
      Map<String, String> imageMap = {};
      if (jsonString != null) {
        imageMap = Map<String, String>.from(jsonDecode(jsonString));
      }

      // Save/Update for current student uuid
      imageMap[widget.student.uuid] = picked.path;

      // Save back to shared prefs
      await prefs.setString('profileImageMap', jsonEncode(imageMap));

      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 3,
            offset: const Offset(3, 3),
          ),
        ],
        image: _imagePath != null
            ? DecorationImage(
          image: FileImage(File(_imagePath!)),
          fit: BoxFit.cover,
        )
            : null,
      ),
      child: _imagePath == null
          ? const Icon(Icons.person, size: 60, color: Colors.white)
          : null,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickAndSaveImage,
                child: imageWidget,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: [
                  Text(
                    widget.student.name,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                  ),
                  Text(
                    'Class: ${widget.student.studentClass}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Profile details
            Card(
              child: ListTile(
                leading: const Icon(Icons.school, color: Colors.deepPurple),
                title: const Text('School'),
                subtitle: Text(widget.student.school),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.deepPurple),
                title: const Text('Date of Birth'),
                subtitle: Text('${widget.student.dob.day}/${widget.student.dob.month}/${widget.student.dob.year}'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.date_range, color: Colors.deepPurple),
                title: const Text('Joined Date'),
                subtitle: Text('${widget.student.joined.day}/${widget.student.joined.month}/${widget.student.joined.year}'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.deepPurple),
                title: const Text('Father\'s Phone'),
                subtitle: Text(widget.student.fatherPhone),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.deepPurple),
                title: const Text('Mother\'s Phone'),
                subtitle: Text(widget.student.motherPhone),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.deepPurple),
                title: const Text('Parent Email'),
                subtitle: Text(widget.student.parentEmail ?? 'N/A'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.home, color: Colors.deepPurple),
                title: const Text('Address'),
                subtitle: Text(widget.student.address),
              ),
            ),
            const SizedBox(height: 10),

            // Logout
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.deepPurple),
                title: const Text('Logout'),
                onTap: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?', style: TextStyle(color: Colors.black)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                  if (shouldLogout == true) {
                    await _authService.logout();
                    if (!mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}






