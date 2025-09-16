import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/presentation/widgets/custom_input_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height; // ✅ Correct extraction
    final width = size.width;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0BBFF), // pale violet
              Color(0xFFC2A3FF), // pastel purple
              Color(0xFFA0C4FF),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.12),
              //WElcome Text
              Text(
                "Welcome,",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.08,
                ),
              ),
              //Glad to see you Text
              Text(
                "Glad to see you!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: width * 0.09,
                ),
              ),
              SizedBox(height: height * 0.05),
              //Email Address feild
              CustomInputFieldWidget(hintText: "Email Address"),
              SizedBox(height: height * 0.01),
              //Password feild
              CustomInputFieldWidget(hintText: "Password", obscureText: true),
              SizedBox(height: height * 0.015),
              //Forgot Password Text
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: width * 0.6),
                  GestureDetector(
                    onTap: () {
                      log("FOrgot PAssword CLicked");
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.035,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.03),
              //Login Button
              MaterialButton(
                onPressed: () {
                  log("Login Pressed");
                },
                color: Colors.white,
                minWidth: width * 0.8,
                height: height * 0.06,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    height * 0.01,
                  ), // Half of height
                ),
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.black, fontSize: width * 0.06),
                ),
              ),
              SizedBox(height: height * 0.05),
              //Or Login with text
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: height * 0.002,
                    width: width * 0.25,
                    color: Colors.white,
                  ),
                  Text(
                    "   Or Login with   ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.045,
                    ),
                  ),
                  Container(
                    height: height * 0.002,
                    width: width * 0.25,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: height * 0.03),
              //Google logo button
              GestureDetector(
                onTap: () {
                  log("SIgnup with google");
                },
                child: Container(
                  height: height * 0.065,
                  width: width * 0.6,

                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 211, 189, 255),
                    borderRadius: BorderRadius.circular(height * 0.01),
                    border: Border.all(
                      color: Colors.white,
                      width: height * 0.003,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/logo/google.png",
                        height: height * 0.04,
                        width: width * 0.16,
                        fit: BoxFit.fill,
                      ),
                      Text(
                        "Sign in with Google",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.04,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
