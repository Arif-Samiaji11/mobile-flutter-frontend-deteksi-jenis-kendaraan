import 'package:flutter/material.dart';
import 'package:apkksaya/data_strimlit.dart';
import 'package:apkksaya/page/chatbot.dart';
import 'package:apkksaya/page/coomingsoon.dart';
import 'package:apkksaya/page/deteksiasli.dart';
import 'package:apkksaya/page/logout.page.dart';
import 'package:apkksaya/page/barcode_widget.dart';
import 'package:apkksaya/page/wa.dart';
import 'package:apkksaya/page/profilepage.dart'; // Impor halaman profil

class MakeDashboardItems extends StatefulWidget {
  const MakeDashboardItems({Key? key}) : super(key: key);

  @override
  _MakeDashboardItemsState createState() => _MakeDashboardItemsState();
}

class _MakeDashboardItemsState extends State<MakeDashboardItems> {
  ElevatedButton buatElevatedButton(String judul, String img, Widget halaman) {
    return ElevatedButton(
      onPressed: () {
        navigateToPage(halaman);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF663399), Color(0xFFA9A9A9)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          constraints: BoxConstraints(minHeight: 150),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                img,
                height: 60,
                width: 60,
              ),
              SizedBox(height: 10),
              Text(
                judul,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToPage(Widget halaman) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => halaman),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Color(0xFF663399),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              navigateToPage(ProfilePage());
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF663399), Color(0xFFA9A9A9)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Item:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF663399), Color(0xFFA9A9A9)],
                  ),
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(20),
                  mainAxisSpacing: 20, // Jarak antara baris
                  crossAxisSpacing: 20, // Jarak antara kolom
                  children: [
                    buatElevatedButton(
                        "Data Streamlit", "assets/deteksi.jpg", MyHomePage()),
                    buatElevatedButton(
                        "Chatbot", "assets/chatbot.png", ChatbotPage()),
                    buatElevatedButton(
                        "Cooming Soon", "assets/call.png", coomingsoon()),
                    buatElevatedButton(
                        "Deteksi Realtime", "assets/detect.jpg", deteksiasli()),
                    buatElevatedButton("Tentang Kami", "assets/abour1.png",
                        TentangKamiPage()),
                    buatElevatedButton("LogOut", "assets/logout.png", logout()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
