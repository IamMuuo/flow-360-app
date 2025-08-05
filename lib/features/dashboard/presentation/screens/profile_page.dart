import 'package:flow_360/config/router/routes.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = authController.currentUser.value?.user;

    if (user == null) {
      return const Center(child: Text("No user info available."));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar & Username
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.profilePicture != null
                        ? NetworkImage(user.profilePicture!)
                        : null,
                    child: user.profilePicture == null
                        ? Text(
                            user.username.substring(0, 1).toUpperCase(),
                            style: Theme.of(context).textTheme.headlineLarge,
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.username,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.role,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // User Info
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ProfileTile(
                      title: "Organization ID",
                      value:
                          user.organization?.split("-").first ??
                          "No organization yet",
                    ),
                    const Divider(),
                    ProfileTile(
                      title: "Station",
                      value: user.firstName ?? "Anonymous",
                    ),
                    const Divider(),
                    ProfileTile(
                      title: "Station ID",
                      value: user.station?.split("-").first ?? "Unkown station",
                    ),
                    const Divider(),
                    ProfileTile(
                      title: "Phone Number",
                      value: user.phoneNumber ?? "N/A",
                    ),
                    const Divider(),
                    ProfileTile(
                      title: "Email",
                      value: user.email ?? "No email",
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Logout button
            FilledButton.icon(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await authController.logoutCurrentUser();
                if (context.mounted) AuthRoute().go(context);
              },
              label: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String title;
  final String value;

  const ProfileTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$title:", style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
