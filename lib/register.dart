

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Future<void> sendMessage(String pin, String phoneNumber) async {
        await [Permission.sms].request();
        String message = "Your pin is ${pin}";
        List<String> recipents = [phoneNumber];
        String result = await sendSMS(message: message, recipients: recipents, sendDirect: true)
            .catchError((onError) {
          print(onError);
        });
        print(result);
        if (result == 'SMS Sent!') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('phoneNumber', phoneNumber);
          // print(prefs.getString('phoneNumber'));
        }
    }

    Future<void> register() async {
      var phoneNumber = _controller.text;
      print('Phone Number $phoneNumber');
      if (phoneNumber.toString().length != 11) {
        final snackBar = SnackBar(
          content: const Text('Invalid Phone Number entered'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      final QueryBuilder<ParseObject> parseQuery =
          QueryBuilder<ParseObject>(ParseObject('UserTable'));
      parseQuery.whereEqualTo('PhoneNumber', phoneNumber);
      final ParseResponse apiResponse = await parseQuery.query();
      var pin = "";
      print(apiResponse.success);
      print(apiResponse.results);
      if (apiResponse.success && apiResponse.results != null) {
        print(apiResponse.count);
        if (apiResponse.count > 0) {
          for (var object in apiResponse.results as List<ParseObject>) {
            print('${object.get<String>('PIN')}');
            pin = object.get<String>('PIN').toString();
            sendMessage(pin, phoneNumber);
          }
        }
      } else {
        var rng = Random();
        pin = (rng.nextInt(10000) + 10000).floor().toString().substring(1);
        print(pin);
        final ParseObject createAccount = ParseObject('UserTable')..set('PhoneNumber', phoneNumber)..set('PIN', pin);
        final ParseResponse parseResponse = await createAccount.save();
        if (parseResponse.success && parseResponse.results != null) {
          sendMessage(pin, phoneNumber);
        } else {
          print(parseResponse.error);
        }
      }
    }


    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/logo-big.png',
            scale: 1.25,
          ),
          const SizedBox(
            height: 5.0,
          ),
          Image.asset(
            'assets/logo-text.png',
            scale: 1.25,
          ),
          const SizedBox(
            height: 25.0,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Register",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25,
                    decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 50, right: 50),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Enter your phone number to receive a one time pin",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15,
                    decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, ),
              decoration: const InputDecoration(
                hintText: 'Phone number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          const SizedBox(
            height: 40.0,
          ),
          ElevatedButton(
            onPressed: () { register(); },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.0),
                ),
                minimumSize: const Size(150, 60)),
            child: const Text(
              'Enter',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                  fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
          Align(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Go back",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
