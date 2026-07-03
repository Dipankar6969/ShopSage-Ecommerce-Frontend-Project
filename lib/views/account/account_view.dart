import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/auth_controller.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  String _formatJoinedDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Flexible(
            child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Obx(() {
      final user = authController.currentUser.value;
      if (user == null) {
        return const Center(child: Text('No user information available.'));
      }

      final location = user.address != null
          ? '${user.address!.city ?? '-'}, ${user.address!.country ?? '-'}'
          : '-';
      final roles = user.roles.isNotEmpty ? user.roles.join(', ') : 'Customer';

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green.shade100,
                    backgroundImage: user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                        ? NetworkImage(user.profileImageUrl!) as ImageProvider
                        : null,
                    child: user.profileImageUrl == null || user.profileImageUrl!.isEmpty
                        ? Text(
                            user.name?.substring(0, 1).toUpperCase() ?? 'U',
                            style: const TextStyle(fontSize: 32, color: Colors.green),
                          )
                        : null,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) {
                        await authController.updateProfileImage(image.path);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha((0.15 * 255).round()), blurRadius: 6, offset: const Offset(0, 2)),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.camera_alt, size: 18, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                user.name ?? 'Guest User',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            Center(child: Text(user.email ?? '', style: const TextStyle(color: Colors.black54))),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () async {
                  final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
                  if (image != null) {
                    await authController.updateProfileImage(image.path);
                  }
                },
                child: const Text('Change profile picture'),
              ),
            ),
            if (authController.errorMessage.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(authController.errorMessage.value, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Profile details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Divider(height: 24),
                    _infoRow('Phone', user.phone ?? '-'),
                    _infoRow('Location', location),
                    _infoRow('Joined', _formatJoinedDate(user.createdAt)),
                    _infoRow('Status', user.isActive == true ? 'Active' : 'Inactive'),
                    _infoRow('Role', roles),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                await authController.logout();
                Get.offAllNamed('/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.redAccent,
              ),
            ),
          ],
        ),
      );
    });
  }
}
