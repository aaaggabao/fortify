import 'package:flutter/material.dart';
import 'package:fortify/home.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var pin = "";

    Future<void> userLogin(String pinEntered) async {
      pin = pin + pinEntered;
      print(pin);
      if (pin.length == 4) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String phoneNumber = prefs.getString('phoneNumber').toString();

        final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(ParseObject('UserTable'));
        parseQuery.whereEqualTo('PhoneNumber', phoneNumber);
        final apiResponse = await parseQuery.query();
        var pinStored = "";
        print(apiResponse.success);
        if (apiResponse.success && apiResponse.results != null) {
          print(apiResponse.count);
          if(apiResponse.count > 0) {
            for (var object in apiResponse.results as List<ParseObject>) {
              print('${object.get<String>('PIN')}');
              pinStored = object.get<String>('PIN').toString();

              if (pinStored == pin) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage()),
                );
                pin = "";
              } else {
                final snackBar = SnackBar(
                  content: const Text('Wrong pin!'),
                  action: SnackBarAction(
                    label: 'Close',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                pin = "";
                return;
              }
            }
          }
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
            height: 5.0,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Pin code",
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
            height: 5.0,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 50, right: 50),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Enter your 4-digit pin code",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                    decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      userLogin('1');
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: const Size(60, 60)),
                    child: const Text(
                      '1',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      userLogin('2');
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: const Size(60, 60)),
                    child: const Text(
                      '2',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {userLogin('3');},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: const Size(60, 60)),
                    child: const Text(
                      '3',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {userLogin('4');},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: const Size(60, 60)),
                    child: const Text(
                      '4',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {userLogin('5');},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: const Size(60, 60)),
                    child: const Text(
                      '5',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {userLogin('6');},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: const Size(60, 60)),
                    child: const Text(
                      '6',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {userLogin('7');},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: const Size(60, 60)),
                    child: const Text(
                      '7',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {userLogin('8');},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: const Size(60, 60)),
                    child: const Text(
                      '8',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {userLogin('9');},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: const Size(60, 60)),
                    child: const Text(
                      '9',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      userLogin('0');

                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: const Size(60, 60)),
                    child: const Text(
                      '0',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30),
                    ),
                  ),
                ],
              ),
            ],
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
