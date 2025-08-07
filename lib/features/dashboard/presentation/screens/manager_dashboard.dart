import 'package:flow_360/config/router/routes.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 180,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Hi ${controller.currentUser.value?.user.firstName ?? "Anonymous"}',
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                ProfileRoute().push(context);
              },
              icon: Icon(Icons.person),
            ),
          ],
        ),

        SliverPadding(
          padding: EdgeInsetsGeometry.all(12),
          sliver: SliverFillRemaining(
            child: Column(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Image.asset("assets/icons/oops.png", height: 200),
                Text(
                  "Seems you're a manager. Managers can only access the app via the web portal",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                FilledButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Logging out..."),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    await controller.logoutCurrentUser();

                    if (!context.mounted) return;
                    AuthRoute().go(context);
                  },
                  child: Text("Logout"),
                ),

                Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
