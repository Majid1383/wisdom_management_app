

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wisdom_management_app/services/auth_service.dart';
// import '../../../models/new_student_model/new_student.dart' show Student;
// import '../../login/login_screen.dart';
//
// class ProfileScreen extends StatefulWidget {
//   final Student student;
//
//   const ProfileScreen({super.key, required this.student});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final AuthService _authService = AuthService();
//   String? _imagePath;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadImagePath();
//   }
//
//   Future<void> _loadImagePath() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonString = prefs.getString('profileImageMap');
//     if (jsonString != null) {
//       final imageMap = Map<String, String>.from(jsonDecode(jsonString));
//       setState(() {
//         _imagePath = imageMap[widget.student.uuid];
//       });
//     }
//   }
//
//   Future<void> _pickAndSaveImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       final prefs = await SharedPreferences.getInstance();
//
//       // Load existing map
//       final jsonString = prefs.getString('profileImageMap');
//       Map<String, String> imageMap = {};
//       if (jsonString != null) {
//         imageMap = Map<String, String>.from(jsonDecode(jsonString));
//       }
//
//       // Save/Update for current student uuid
//       imageMap[widget.student.uuid] = picked.path;
//
//       // Save back to shared prefs
//       await prefs.setString('profileImageMap', jsonEncode(imageMap));
//
//       setState(() {
//         _imagePath = picked.path;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final imageWidget = Container(
//       width: 180,
//       height: 180,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(color: Colors.grey.shade300, width: 3),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 3,
//             offset: const Offset(3, 3),
//           ),
//         ],
//         image: _imagePath != null
//             ? DecorationImage(
//           image: FileImage(File(_imagePath!)),
//           fit: BoxFit.cover,
//         )
//             : null,
//       ),
//       child: _imagePath == null
//           ? const Icon(Icons.person, size: 60, color: Colors.white)
//           : null,
//     );
//
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Center(
//               child: GestureDetector(
//                 onTap: _pickAndSaveImage,
//                 child: imageWidget,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Center(
//               child: Column(
//                 children: [
//                   Text(
//                     widget.student.name,
//                     style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepOrange),
//                   ),
//                   Text(
//                     'Class: ${widget.student.studentClass}',
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
//                 subtitle: Text(widget.student.school),
//               ),
//             ),
//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.calendar_today, color: Colors.deepPurple),
//                 title: const Text('Date of Birth'),
//                 subtitle: Text('${widget.student.dob.day}/${widget.student.dob.month}/${widget.student.dob.year}'),
//               ),
//             ),
//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.date_range, color: Colors.deepPurple),
//                 title: const Text('Joined Date'),
//                 subtitle: Text('${widget.student.joined.day}/${widget.student.joined.month}/${widget.student.joined.year}'),
//               ),
//             ),
//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.phone, color: Colors.deepPurple),
//                 title: const Text('Father\'s Phone'),
//                 subtitle: Text(widget.student.fatherPhone),
//               ),
//             ),
//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.phone, color: Colors.deepPurple),
//                 title: const Text('Mother\'s Phone'),
//                 subtitle: Text(widget.student.motherPhone),
//               ),
//             ),
//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.email, color: Colors.deepPurple),
//                 title: const Text('Parent Email'),
//                 subtitle: Text(widget.student.parentEmail ?? 'N/A'),
//               ),
//             ),
//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.home, color: Colors.deepPurple),
//                 title: const Text('Address'),
//                 subtitle: Text(widget.student.address),
//               ),
//             ),
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
//                     if (!mounted) return;
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
import 'package:wisdom_management_app/models/new_student_model/new_student.dart' show Student;
import 'package:wisdom_management_app/services/auth_service.dart';
import '../../login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final List<Student> students;

  const ProfileScreen({super.key, required this.students});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  Map<String, String?> _imagePaths = {}; // student.uuid -> image path
  late Student _selectedStudent;

  @override
  void initState() {
    super.initState();
    _selectedStudent = widget.students.first;
    _loadAllImagePaths();
  }

  Future<void> _loadAllImagePaths() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('profileImageMap');
    Map<String, String> imageMap = {};
    if (jsonString != null) {
      imageMap = Map<String, String>.from(jsonDecode(jsonString));
    }
    setState(() {
      _imagePaths = {
        for (var student in widget.students) student.uuid: imageMap[student.uuid]
      };
    });
  }

  Future<void> _pickAndSaveImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('profileImageMap');
      Map<String, String> imageMap = {};
      if (jsonString != null) {
        imageMap = Map<String, String>.from(jsonDecode(jsonString));
      }
      imageMap[_selectedStudent.uuid] = picked.path;
      await prefs.setString('profileImageMap', jsonEncode(imageMap));

      setState(() {
        _imagePaths[_selectedStudent.uuid] = picked.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detect screen width
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    final selectedImagePath = _imagePaths[_selectedStudent.uuid];

    // your custom shadowed image widget
    final imageWidget = GestureDetector(
      onTap: _pickAndSaveImage,
      child: Container(
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
          image: selectedImagePath != null
              ? DecorationImage(
            image: FileImage(File(selectedImagePath)),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: selectedImagePath == null
            ? const Icon(Icons.person, size: 60, color: Colors.white)
            : null,
      ),
    );

    // Build student profile details panel
    final profileDetails = Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(child: imageWidget),
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: [
                  Text(
                    _selectedStudent.fullName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  Text(
                    'Class: ${_selectedStudent.studentClass}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoCard(Icons.school, 'School', _selectedStudent.school),
            _buildInfoCard(Icons.calendar_today, 'Date of Birth',
                '${_selectedStudent.dob.day}/${_selectedStudent.dob.month}/${_selectedStudent.dob.year}'),
            _buildInfoCard(Icons.date_range, 'Joined Date',
                '${_selectedStudent.joined.day}/${_selectedStudent.joined.month}/${_selectedStudent.joined.year}'),
            _buildInfoCard(Icons.phone, 'Father\'s Phone', _selectedStudent.fatherPhone),
            _buildInfoCard(Icons.phone, 'Mother\'s Phone', _selectedStudent.motherPhone),
            _buildInfoCard(Icons.email, 'Parent Email', _selectedStudent.parentEmail ?? 'N/A'),
            _buildInfoCard(Icons.home, 'Address', _selectedStudent.address),
            const SizedBox(height: 10),
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
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout')),
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

    if (isWideScreen) {
      // Desktop/tablet view: row with side list & details
      return Row(
        children: [
          SizedBox(
            width: 60,
            child: ListView.builder(
              itemCount: widget.students.length,
              itemBuilder: (context, index) {
                final student = widget.students[index];
                final imgPath = _imagePaths[student.uuid];
                return GestureDetector(
                  onTap: () => setState(() => _selectedStudent = student),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.deepPurple,
                      backgroundImage: imgPath != null ? FileImage(File(imgPath)) : null,
                      child: imgPath == null
                          ? const Icon(Icons.person, color: Colors.white, size: 20)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          profileDetails,
        ],
      );
    } else {
      // Mobile view: column with top list & details
      return Column(
        children: [
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.students.length,
              itemBuilder: (context, index) {
                final student = widget.students[index];
                final imgPath = _imagePaths[student.uuid];
                return GestureDetector(
                  onTap: () => setState(() => _selectedStudent = student),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.deepPurple,
                      backgroundImage: imgPath != null ? FileImage(File(imgPath)) : null,
                      child: imgPath == null
                          ? const Icon(Icons.person, color: Colors.white, size: 22)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(child: profileDetails),
        ],
      );
    }
  }

  Widget _buildInfoCard(IconData icon, String title, String subtitle) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}








