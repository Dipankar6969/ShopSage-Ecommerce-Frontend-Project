import 'package:flutter/material.dart';
import 'package:shopsage_frontend/widgets/admin/admin_top_bar.dart';
import 'package:shopsage_frontend/widgets/admin/admin_status_cards.dart';
import 'package:shopsage_frontend/widgets/admin/admin_application_queue.dart';

class BusinessesView extends StatelessWidget {

  const BusinessesView({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              'Vendor Applications',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),


            const Text(
              'Review and manage pending business approvals.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

          ],
        ),

      ),


      body: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: const [

          AdminTopBar(),

          SizedBox(height: 20),

          AdminStatusCards(),

          SizedBox(height: 30),

          AdminApplicationQueue(),

        ],

      ),

    );

  }

}