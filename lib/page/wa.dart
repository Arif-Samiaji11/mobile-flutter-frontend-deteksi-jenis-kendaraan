import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TentangKamiPage extends StatelessWidget {
  final String phoneNumber = '+6287797741817'; // Nomor telepon WhatsApp
  final String email = 'arifsamiaji11@gmail.com'; // Email

  void _launchWhatsApp() async {
    String message = 'Halo! Saya ingin menghubungi Anda.';
    String url = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Tidak dapat membuka WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(146, 146, 189, 1),
        title: Text('Tentang Kami'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Ganti warna background sesuai keinginan
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat datang di Aplikasi Vehicle Detection and Counting!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Aplikasi ini dibuat oleh tim Gemtek pengembang yang berdedikasi untuk memberikan pengalaman yang luar biasa kepada pengguna, diharapkan aplikasi ini mampu mendeteksi jenis-jenis kendaraan didarat terlebih khusus untuk kebutuhan jalan tol serta dapat menghitung jumlahnya.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Fitur Utama:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- Mulai Deteksi: Fitur halaman untuk memulai proses deteksi jenis kendaraan tertentu.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '- Data Streamlit: Fitur halaman untuk melihat hasil data dari deteksi kendaraan.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '- Chatbot: Fitur  halaman yang memungkinkan pengguna berinteraksi dengan asisten virtual.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '- LogOut: Fitur halaman untuk keluar dari aplikasi.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Hubungi Kami:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _launchWhatsApp,
                    child: Text('Hubungi via WhatsApp'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      String subject = 'Pertanyaan tentang Aplikasi';
                      String url = 'mailto:$email?subject=${Uri.encodeFull(subject)}';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Tidak dapat mengirim email';
                      }
                    },
                    child: Text('Hubungi via Email'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TentangKamiPage(),
  ));
}
