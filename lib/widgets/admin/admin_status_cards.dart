import 'package:flutter/material.dart';

class AdminStatusCards extends StatelessWidget {
  const AdminStatusCards({super.key});

  @override
  Widget build(BuildContext context) {
   return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: SizedBox(
    height: 120,
    child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),

        child: Row(
          children: const [

            SizedBox(
              width: 250,
              child: StatusCard(
                title: 'Pending',
                count: '12',
                color: Colors.orange,
                icon: Icons.hourglass_top_rounded,
              ),
            ),

            SizedBox(width: 16),

            SizedBox(
              width: 250,
              child: StatusCard(
                title: 'Approved',
                count: '45',
                color: Colors.green,
                icon: Icons.check_circle,
              ),
            ),

            SizedBox(width: 16),

            SizedBox(
              width: 250,
              child: StatusCard(
                title: 'Rejected',
                count: '8',
                color: Colors.red,
                icon: Icons.cancel,
              ),
            ),

          ],
        ),
      ),
  ),
    );
  }
}


class StatusCard extends StatelessWidget {

  final String title;
  final String count;
  final Color color;
  final IconData icon;


  const StatusCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });


  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: Colors.grey.shade300,
        ),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0,2),
          )
        ],
      ),


      child: Row(
        children: [

          CircleAvatar(
            radius: 22,

            backgroundColor: color.withOpacity(0.15),

            child: Icon(
              icon,
              color: color,
              size: 26,
            ),
          ),


          const SizedBox(width:14),


          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                count,

                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),


              const SizedBox(height:3),


              Text(
                title,

                style: const TextStyle(
                  fontSize:14,
                  color:Colors.grey,
                ),
              ),

            ],
          )

        ],
      ),
    );
  }
}