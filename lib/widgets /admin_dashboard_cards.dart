import 'package:flutter/material.dart';
import '../theme/color_manager.dart';

class AdminDashboardCards extends StatelessWidget {
  const AdminDashboardCards({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      padding: const EdgeInsets.all(16),
      children: [
        const _DashboardCard(
          title: 'Total Students',
          value: '24',
          icon: Icons.people,
          color: ColorManager.tealAccent,
        ),
        const _DashboardCard(
          title: 'Fees Collected',
          value: '₹18,500',
          icon: Icons.attach_money,
          color: ColorManager.charcoalGray,
        ),
        _DashboardCard(
          title: 'Pending Fees',
          value: '₹4,000',
          icon: Icons.money_off,
          color: ColorManager.darkCharcoal,
        ),
        const _DashboardCard(
          title: 'Lectures Today',
          value: '4',
          icon: Icons.book,
          color: ColorManager.mintGreen,
        ),
      ],
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
