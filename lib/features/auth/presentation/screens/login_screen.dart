import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(12),
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
            FilledButton(onPressed: () {}, child: Text("Continue")),
          ],
        ),
      ),
    );
  }
}
