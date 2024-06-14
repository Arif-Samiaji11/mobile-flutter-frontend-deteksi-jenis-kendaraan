import 'package:flutter/material.dart';
import 'package:apkksaya/page/login_page.dart';

void main() {
  runApp(logout());
}

class logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('LogOut'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Apakah Anda yakin ingin keluar?',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman lain saat tombol "Ya" ditekan
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Ya'),
              ),
              SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                },
                child: Text('Tidak'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman selanjutnya setelah logout
class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Selanjutnya'),
      ),
      body: Center(
        child: Text('Anda telah berhasil logout!'),
      ),
    );
  }
}
