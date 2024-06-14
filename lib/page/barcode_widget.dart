import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentGatewayPage extends StatefulWidget {
  @override
  _PaymentGatewayPageState createState() => _PaymentGatewayPageState();
}

class _PaymentGatewayPageState extends State<PaymentGatewayPage> {
  TextEditingController _amountController = TextEditingController();
  bool _isProcessing = false;
  String _errorMessage = '';
  String? _selectedPaymentMethod; // Ubah tipe data menjadi String?

  List<String> _paymentMethods = ['Bank Transfer', 'Credit Card', 'GoPay'];

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:3000/payment'), // Ganti dengan alamat backend Anda
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'amount': int.parse(_amountController.text),
          'recipientAccountNumber':
              '123456789', // Contoh nomor rekening penerima
          'paymentMethod':
              _selectedPaymentMethod ?? '', // Gunakan null-aware operator (??)
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        bool isSuccess = responseBody['success'] ?? false;

        setState(() {
          _isProcessing = false;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Payment Status'),
            content: Text(isSuccess
                ? 'Payment successful! Transaction ID: ${responseBody['transactionId']}'
                : 'Payment failed.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _isProcessing = false;
          _errorMessage =
              'Error: ${response.statusCode} ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Gateway'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            // Dropdown button untuk memilih metode pembayaran
            DropdownButton<String>(
              value: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
              items: _paymentMethods.map((method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _isProcessing ? null : _processPayment,
              child:
                  _isProcessing ? CircularProgressIndicator() : Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PaymentGatewayPage(),
  ));
}
