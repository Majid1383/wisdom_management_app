import 'package:flutter/material.dart';

// class GlobalDrawer extends StatelessWidget {
//   const GlobalDrawer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero, // remove default top padding
//         children: [
//           DrawerHeader(
//             decoration: const BoxDecoration(
//               color: Colors.deepPurple,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text('Wisdom App',
//                     style: TextStyle(color: Colors.white, fontSize: 24)),
//                 SizedBox(height: 8),
//                 Text('Manage your students',
//                     style: TextStyle(color: Colors.white70)),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text('Add Attendance'),
//             onTap: () {
//               // Navigate to profile screen or close drawer
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.person_add),
//             title: const Text('Add New Student'),
//             onTap: () async {
//               Navigator.pop(context); // close drawer first
//
//               final newStudent = await Navigator.pushNamed(context, '/registerStudent');
//             },
//           ),
//
//           ListTile(
//             leading: const Icon(Icons.list),
//             title: const Text('Add Leaves'),
//             onTap: () {
//               Navigator.pop(context);
//               // navigate if needed
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings),
//             title: const Text('Settings'),
//             onTap: () {
//               Navigator.pop(context);
//               // navigate if needed
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title: const Text('Logout'),
//             onTap: () {
//               Navigator.pop(context);
//               // perform logout if needed
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }


class GlobalDrawer extends StatelessWidget {
  final Future<void> Function()? onAddStudent;

  const GlobalDrawer({super.key, this.onAddStudent});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepPurple),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Wisdom App', style: TextStyle(color: Colors.white, fontSize: 24)),
                SizedBox(height: 8),
                Text('Manage your students', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Add Attendance'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Add New Student'),
            onTap: () async {
              Navigator.pop(context); // close drawer
              if (onAddStudent != null) {
                await onAddStudent!(); // trigger callback
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Add Leaves'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
