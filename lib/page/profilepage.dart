import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = FlutterSecureStorage();
  String? name;
  String? email;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      print('No token found');
      return;
    }

    print('Token: $token');

    final response = await http.get(
      Uri.parse('http://192.168.1.10:5000/myprofile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        name = data['name'];
        email = data['email'];
        profileImageUrl = data['profile_image_url'];
      });
    } else {
      print('Failed to load profile');
    }
  }

  void _navigateToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
    );
    fetchProfile();
  }

  void _navigateToChangePassword() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
    );
  }

  void _navigateToEditProfilePhoto() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePhotoPage()),
    );
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Pengguna"),
      ),
      body: Center(
        child: name == null || email == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (profileImageUrl != null)
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profileImageUrl!),
                    ),
                  SizedBox(height: 20),
                  Text(
                    "Nama: $name",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Email: $email",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _navigateToEditProfilePhoto,
                    child: Text("Ubah Foto Profil"),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _navigateToEditProfile,
                    child: Text("Ubah Profil"),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _navigateToChangePassword,
                    child: Text("Ubah Kata Sandi"),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            'Halaman Profile Anda',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class EditProfilePhotoPage extends StatefulWidget {
  @override
  _EditProfilePhotoPageState createState() => _EditProfilePhotoPageState();
}

class _EditProfilePhotoPageState extends State<EditProfilePhotoPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  final storage = FlutterSecureStorage();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
    });
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Pilih gambar terlebih dahulu."),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String? token = await storage.read(key: 'token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Token tidak tersedia."),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.10:5000/updateprofilephoto'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath(
        'profile_photo',
        _selectedImage!.path,
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Foto profil berhasil diperbarui."),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memperbarui foto profil."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan saat mengunggah foto."),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Foto Profil"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedImage != null
                ? Image.file(
                    File(_selectedImage!.path),
                    height: 200,
                  )
                : Text("Tidak ada gambar dipilih"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Pilih Gambar"),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadImage,
                    child: Text("Simpan Foto"),
                  ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? oldName = prefs.getString('name');
    String? oldEmail = prefs.getString('email');
    setState(() {
      _nameController.text = oldName ?? '';
      _emailController.text = oldEmail ?? '';
    });
  }

  Future<void> updateProfile() async {
    String newName = _nameController.text;
    String newEmail = _emailController.text;

    if (newName.isEmpty || newEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Nama dan email harus diisi."),
        ),
      );
      return;
    }

    try {
      String? token = await FlutterSecureStorage().read(key: 'token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Token tidak tersedia."),
          ),
        );
        return;
      }

      final response = await http.put(
        Uri.parse('http://192.168.1.10:5000/updateprofile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': newName, 'email': newEmail}),
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('name', newName);
        prefs.setString('email', newEmail);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Profil berhasil diperbarui"),
          ),
        );

        Navigator.pop(context);
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Input tidak valid."),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memperbarui profil"),
         
          ),
        );
      }
    } catch (e) {
      print('Error: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan saat memperbarui profil"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ubah Nama:",
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Nama",
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Ubah Email:",
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateProfile,
              child: Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> changePassword() async {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Semua bidang harus diisi."),
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Konfirmasi kata sandi tidak cocok."),
        ),
      );
      return;
    }

    try {
      String? token = await FlutterSecureStorage().read(key: 'token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Token tidak tersedia."),
          ),
        );
        return;
      }

      final response = await http.put(
        Uri.parse('http://192.168.1.10:5000/changepassword'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'old_password': currentPassword, // use 'old_password' as per backend
            'new_password': newPassword,     // use 'new_password' as per backend
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Kata sandi berhasil diubah"),
          ),
        );
        Navigator.pop(context);
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal mengubah kata sandi. Periksa kembali kata sandi saat ini."),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal mengubah kata sandi"),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan saat mengubah kata sandi"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Current Password:",
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Current Password",
              ),
            ),
            SizedBox(height: 20),
            Text(
              "New Password:",
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "New Password",
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Confirm New Password:",
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Confirm New Password",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: changePassword,
              child: Text("Change Password"),
            ),
          ],
        ),
      ),
    );
  }
}
