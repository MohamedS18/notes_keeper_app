import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'controller.dart';
import 'package:provider/provider.dart';
import 'states.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginPage createState() => LoginPage();
}

class LoginPage extends State<Login> {
  bool isSignUp = false;
  final TextEditingController username = TextEditingController(text: "");
  final TextEditingController password = TextEditingController(text: "");

  void showError(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  bool validateCredentials() {
    String x = username.text.trim();
    String y = password.text.trim();

    bool isValidEmail = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(x);

    bool isValidPassword = RegExp(r'^\d{4}$').hasMatch(y);

    if (!isValidEmail) {
      showError("Enter a valid email address.");
      return false;
    } else if (!isValidPassword) {
      showError("Password must be exactly 4 digits.");
      return false;
    }
    return true;
  }

  void setIsSignUp() {
    setState(() {
      isSignUp = !isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "asset/icons/logo.svg",
              width: 50,
              height: 50,
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
            Text("Notes Keeper", style: TextStyle(fontSize: 32)),
            SizedBox(height: 20.0),
            TextField(
              controller: username,
              decoration: InputDecoration(
                label: Text("username"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              obscureText: true,
              controller: password,
              decoration: InputDecoration(
                label: Text("pin"),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            FilledButton(
              onPressed: () async {
                if (!validateCredentials()) return;
                bool response;
                if (isSignUp) {
                  response = await Controller.signUp(
                    username.text,
                    password.text,
                  );
                } else {
                  response = await Controller.login(
                    username.text,
                    password.text,
                  );
                }
                if (response) {
                  context.read<States>().setUsername(username.text);
                  States.setIsLogged(true);
                  Navigator.popAndPushNamed(context, "/home");
                } else {
                  showError("Wrong credentials");
                }
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.amber),
              child: Text(isSignUp ? "Sign Up" : "Login"),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isSignUp
                    ? Text("Already have an account")
                    : Text("don't have an account"),
                SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () {
                    setIsSignUp();
                  },

                  child: Text(
                    isSignUp ? 'Login' : 'Sign Up',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
