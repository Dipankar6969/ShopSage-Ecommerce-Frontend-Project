import 'package:flutter/material.dart';

class UserDetailTable extends StatefulWidget {
  const UserDetailTable({super.key});

  @override
  State<UserDetailTable> createState() => _UserDetailTableState();
}

class _UserDetailTableState extends State<UserDetailTable> {
  String selectedStatus = "All Status";
  String selectedRole = "All Role";

  final List<Map<String, String>> users = [
    {
      "user": "Ram Sharma",
      "email": "ram@gmail.com",
      "role": "Customer",
      "joinDate": "2026-01-12",
      "status": "Active",
    },

    {
      "user": "Sita Thapa",
      "email": "sita@gmail.com",
      "role": "Vendor",
      "joinDate": "2026-02-05",
      "status": "Inactive",
    },

    {
      "user": "Admin User",
      "email": "admin@gmail.com",
      "role": "Admin",
      "joinDate": "2026-03-10",
      "status": "Active",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),

      child: Column(
        children: [
          // TOP ROW - ADD USER BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.end,

            children: [
              ElevatedButton.icon(
                onPressed: () {},

                icon: const Icon(Icons.add),

                label: const Text("Add User"),

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),

                  backgroundColor: Colors.red.shade600,

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // SEARCH AND FILTER ROW
          Row(
            children: [
              // SEARCH BAR
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search users...",

                    prefixIcon: const Icon(Icons.search),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // ROLE FILTER
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),

                  borderRadius: BorderRadius.circular(10),
                ),

                child: DropdownButton<String>(
                  underline: const SizedBox(),

                  value: selectedRole,

                  items: ["All Role", "Admin", "Vendor", "Customer"]
                      .map(
                        (role) =>
                            DropdownMenuItem(value: role, child: Text(role)),
                      )
                      .toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),
              ),

              const SizedBox(width: 15),

              // STATUS FILTER
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),

                  borderRadius: BorderRadius.circular(10),
                ),

                child: DropdownButton<String>(
                  underline: const SizedBox(),

                  value: selectedStatus,

                  items: ["All Status", "Active", "Inactive"]
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,

                          child: Text(status),
                        ),
                      )
                      .toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // TABLE
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),

                columns: const [
                  DataColumn(
                    label: Text(
                      "User",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      "Email",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      "Role",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      "Join Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      "Actions",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],

                rows: users.map((user) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          user["user"]!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      DataCell(Text(user["email"]!)),

                      DataCell(Chip(label: Text(user["role"]!))),

                      DataCell(Text(user["joinDate"]!)),

                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            color: user["status"] == "Active"
                                ? Colors.green.shade100
                                : Colors.red.shade100,

                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: Text(user["status"]!),
                        ),
                      ),

                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility),
                              onPressed: () {},
                            ),

                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {},
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete),
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
          ),
        ],
      ),
    );
  }
}
