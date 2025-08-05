import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 4,
            children: [
              Icon(Icons.lock, size: 100),
              SizedBox(height: 22),
              Text(
                "Please provide your username and password to continue",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),

              SizedBox(height: 8),

              TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if ((value?.length ?? 0) < 3) {
                    return "Please provide a valid username";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if ((value?.length ?? 0) < 6) {
                    return "Please provide a valid password, atleast 6 characters";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 22),
              Obx(
                () => FilledButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Please correct the form and retry",
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }

                          print("boom");

                          await authController.login(
                            username: _usernameController.text.trim(),
                            password: _passwordController.text,
                          );

                          if (authController.errorMessage.value != null &&
                              context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  authController.errorMessage.value!,
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            // Optional: Navigate to another screen or show success
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Login successful"),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                  child: authController.isLoading.value
                      ? CircularProgressIndicator.adaptive()
                      : Text("Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
