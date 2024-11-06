// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async'; // For Timer
import 'package:google_fonts/google_fonts.dart'; // For custom fonts

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.poppinsTextTheme(), // Use Poppins font
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() {
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        _progressValue += 0.1;
        if (_progressValue >= 1.0) {
          timer.cancel();
          _navigateToHome();
        }
      });
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF43A047), Colors.green.shade400],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.2),
                      //     blurRadius: 10,
                      //     offset: const Offset(0, 5),
                      //   ),
                      // ],
                      ),
                  child: Image.asset(
                    'lib/assets/pngwing.com (1).png', // Replace with your image asset
                    height: 150,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Welcome to Mind Reader',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: LinearProgressIndicator(
                    value: _progressValue,
                    backgroundColor: Colors.white.withOpacity(0.5),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.lightGreenAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
List<String> phrases = [
    "Analyzing brainwaves...",
    "Scanning mermories...",
    "Calculating probabilities...",
    "Decoding thoughts...",
  ];

  late StreamController<String> _streamController;
  late Stream<String> _phraseStream;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<String>();
    _phraseStream = _streamController.stream;
    _startPhrases();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _startPhrases() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (_currentIndex < phrases.length) {
        _streamController.add(phrases[_currentIndex]);
        _currentIndex++;
      } else {
        timer.cancel();
        _streamController.close();
      }
    });
  }
  void _showMindReadingDialog() {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a number')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0.5),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.lightGreenAccent),
                ),
                const SizedBox(height: 20),
                StreamBuilder<String>(
              stream: _phraseStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    "Loading...",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  );
                } else if (snapshot.hasData) {
                  return Text(
                    snapshot.data!,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
    // Reset the stream and controller after the dialog is closed
    _streamController.close();
  });

    Timer(const Duration(seconds: 5), () {
      Navigator.pop(context); // Close progress dialog
      _showResultDialog();
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green[50],
          title: Center(
            child: Text(
              "Mind Reader",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "lib/assets/WhatsApp_Image_2024-10-06_at_13.01.03-removebg-preview.png",
                height: 150,
              ),
              Text(
                "You are thinking about ${_controller.text}.",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                _controller.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MIND READER",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.green[600],
        shadowColor: Colors.black38,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(40.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.green.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Think of any number from 1 to 99",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
              Image.asset(
                "lib/assets/mindreader.png",
                height: 250,
              ),
              const SizedBox(height: 1),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextFormField(
                  maxLength: 2,
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(fontSize: 18),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.green)),
                    prefixIcon: const Icon(Icons.numbers, color: Colors.green),
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.green,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Enter your number",
                    labelStyle: const TextStyle(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  _showMindReadingDialog();
                },
                icon: const Icon(FontAwesomeIcons.brain, color: Colors.green),
                label: Text(
                  "Read my mind",
                  style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
