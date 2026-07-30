import 'package:flutter/material.dart';

class AdminApplicationQueue extends StatelessWidget {
  const AdminApplicationQueue({super.key});

  final List<Map<String, String>> applications = const [
    {
      "business": "Tech World",
      "owner": "Ram Sharma",
      "date": "24 July 2026",
      "category": "Electronics",
      "status": "Pending",
    },

    {
      "business": "Fresh Mart",
      "owner": "Sita Rai",
      "date": "22 July 2026",
      "category": "Grocery",
      "status": "Approved",
    },

    {
      "business": "Fashion Hub",
      "owner": "Hari Thapa",
      "date": "20 July 2026",
      "category": "Clothing",
      "status": "Rejected",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(color: Colors.grey.shade300),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Application Queue",

              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: DataTable(
                columnSpacing: 30,

                headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),

                columns: const [
                  DataColumn(
                    label: Text(
                      "Business Name",
                      style: TextStyle(fontWeight:FontWeight.normal),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      "Owner",
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      "Date Applied",
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      "Category",
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      "Actions",
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ],

                rows: applications.map((app) {
                  return DataRow(
                    cells: [
                      DataCell(Text(app["business"]! ,style: const TextStyle(fontWeight: FontWeight.bold))),

                      DataCell(Text(app["owner"]!)),

                      DataCell(Text(app["date"]!)),

                      DataCell(Text(app["category"]!)),

                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            color: app["status"] == "Approved"
                                ? Colors.green.shade100
                                : app["status"] == "Rejected"
                                ? Colors.red.shade100
                                : Colors.orange.shade100,

                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Text(app["status"]!),
                        ),
                      ),

                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.visibility,
                                color: Colors.blue,
                              ),

                              onPressed: () {},
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),

                              onPressed: () {},
                            ),

                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),

                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
