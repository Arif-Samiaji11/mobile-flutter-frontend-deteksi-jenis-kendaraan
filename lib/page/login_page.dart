import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apkksaya/page/dashboardss.dart';
import 'package:apkksaya/page/sign_up.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = FlutterSecureStorage();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final String url = 'http://192.168.1.10:5000/login';
    final Map<String, String> data = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token_access'];
        await storage.write(key: 'token', value: token);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MakeDashboardItems()),
        );
      } else {
        setState(() {
          errorMessage = 'Login Gagal. Silahkan coba lagi.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan. Silahkan coba lagi.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF64B5F6),
              Color(0xFF90CAF9),
              Color(0xFFBBDEFB),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Silahkan Masuk Akun Anda',
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                'Atau buat akun baru',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 40.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(isLoading ? 'Loading...' : 'Sign In'),
              ),
              SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (builder) => SignUpPage()),
                  );
                },
                child: Text('Tidak punya akun? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
