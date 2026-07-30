import 'package:flutter/material.dart';

class AdminDashboardCards extends StatelessWidget {
  const AdminDashboardCards({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,

      child: ListView(
        scrollDirection: Axis.horizontal,

        padding: const EdgeInsets.symmetric(horizontal: 24),

        children: const [
          AdminCard(
            title: "Total Users",
            value: "+300",
            icon: Icons.people,
            color: Colors.blue,
          ),

          SizedBox(width: 20),

          AdminCard(
            title: "Active Vendors",
            value: "85",
            icon: Icons.store,
            color: Colors.green,
          ),

          SizedBox(width: 20),

          AdminCard(
            title: "Pending Applications",
            value: "12",
            icon: Icons.pending_actions,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class AdminCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const AdminCard({
    super.key,

    required this.title,

    required this.value,

    required this.icon,

    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),

            blurRadius: 10,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            height: 55,

            width: 55,

            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: color, size: 30),
          ),

          const SizedBox(width: 18),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text(
                title,

                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 8),

              Text(
                value,

                style: const TextStyle(
                  fontSize: 28,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
