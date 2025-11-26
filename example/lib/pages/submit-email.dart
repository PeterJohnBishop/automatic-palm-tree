import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubmitEmailButton extends StatefulWidget {
  final String alias;
  final String sender;
  final String name;
  final String email;
  final String subject;
  final String message;

  const SubmitEmailButton({
    super.key,
    required this.alias,
    required this.sender,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });

  @override
  State<SubmitEmailButton> createState() => _SubmitEmailButtonState();
}

class _SubmitEmailButtonState extends State<SubmitEmailButton> {
  var _isHovering = false;
  late String alias;
  late String sender;
  late String name;
  late String email;
  late String subject;
  late String message;

  String responseMessage = '';

  Future<void> sendEmail() async {
    String formattedSubject = "${subject} - ${name}";
    List<String> formattedRecipients = [email, "pjb.den@gmail.com"];

    const url = 'https://example.com/api/data'; 
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'alias': alias,
      'sender': sender,
      'recipients': formattedRecipients, 
      'subject': formattedSubject, 
      'html': message
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          responseMessage = "Success: ${responseData['message'] ?? 'OK'}";
        });
      } else {
        setState(() {
          responseMessage = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        responseMessage = "Exception: $e";
      });
    }
  }


  @override
  void initState() {
    super.initState();
    alias = widget.alias;
    name = widget.name;
    email = widget.email;
    subject = widget.subject;
    message = widget.message;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _isHovering ? Colors.black : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          sendEmail();
        },
        child: Text("Submit"),
      ),
    );
  }
}
