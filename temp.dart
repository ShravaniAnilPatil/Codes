import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginSignupPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}

class LoginSignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "SKIP",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/ticket.png', width: 120, height: 120),
            SizedBox(height: 10),
            Text(
              "Enjoy faster show booking through our recommendations tailored for you.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                // Navigate to HomePage on Google Sign-in click
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              icon: Image.asset('assets/Google.png', width: 24, height: 24),
              label: Text("Continue with Google"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
                side: BorderSide(color: Colors.black26),
              ),
            ),
            SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.email, color: Colors.black),
              label: Text("Continue with Email"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
                side: BorderSide(color: Colors.black26),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Home Screen (After clicking Continue with Google)
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Guest!'),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.qr_code), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text("Navi Mumbai", style: TextStyle(color: Colors.red)),
            ),

            // Location Enable Bar
            Container(
              width: double.infinity,
              color: Colors.blue,
              padding: EdgeInsets.all(10),
              child: Text(
                "Enable location to discover nearby events, movies, and more.",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 10),

            // Categories (Movies, Music Shows, etc.)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  _categoryIcon(Icons.movie, "Movies"),
                  _categoryIcon(Icons.music_note, "Music Shows"),
                  _categoryIcon(Icons.theater_comedy, "Comedy Shows"),
                  _categoryIcon(Icons.event, "Plays"),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Featured Events (Carousel)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(child: Image.asset('assets/event1.jpg', fit: BoxFit.cover)),
                  SizedBox(width: 10),
                  Expanded(child: Image.asset('assets/event2.jpg', fit: BoxFit.cover)),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Recommended Movies Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Recommended Movies", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("See All >", style: TextStyle(color: Colors.red)),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Movies List
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  _movieCard('assets/movie1.jpg', 'PROMOTED'),
                  _movieCard('assets/movie2.jpg', ''),
                  _movieCard('assets/movie3.jpg', ''),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black54,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movies"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Live Events"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _categoryIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 40),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _movieCard(String imagePath, String tag) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Stack(
            children: [
              Image.asset(imagePath, width: 100, height: 150),
              if (tag.isNotEmpty)
                Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: Text(tag, style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
