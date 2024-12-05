import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // date formatting
import 'package:suite_spot/main.dart';
import 'package:suite_spot/ratingsPage.dart';
import 'package:suite_spot/historyPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suite_spot/searchPage2.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController guestsController = TextEditingController();
  DateTime? checkInDate;
  DateTime? checkOutDate;

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    DateTime initialDate = isCheckIn ? DateTime.now() : (checkInDate ?? DateTime.now()).add(Duration(days: 1));
    
    // Sets the firstDate to ensure past dates are unclickable
    DateTime firstDate = isCheckIn ? DateTime.now() : (checkInDate ?? DateTime.now()).add(Duration(days: 1));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          // Clear check-out date if it's before check-in date
          if (checkOutDate != null && checkOutDate!.isBefore(checkInDate!)) {
            checkOutDate = null;
          }
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  void _logout() async {
    try {
      // Sign out the user
      await FirebaseAuth.instance.signOut();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully logged out.')),
      );

      // Navigate back to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your login page widget
      );
    } catch (e) {
      // Show an error message if logout fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: $e')),
      );
    }
  }

  void _showAboutUsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows tapping outside to close the dialog
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 450, // Fixed width
            height: 300, // Fixed height
            decoration: BoxDecoration(
              color: Color.fromRGBO(232, 204, 191, 1), // Custom background color
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Company Name
                Text(
                  'Suite Spot',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Italiana-Regular',
                    color: Color.fromRGBO(165, 111, 77, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                
                // Email
                Text(
                  'Email: contact@suitespot.com',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(height: 10),
                
                // Phone Number
                Text(
                  'Phone: +1 (555) 123-4567',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(height: 15),
                
                // Company Description
                Text(
                  'Our mission at Suite Spot is to connect travelers with luxury stays across the globe, providing unforgettable experiences and exceptional customer service. Weaim to make booking your perfect stay seamless and enjoyable.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20),

                // Close Button
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(165, 111, 77, 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Suite Spot', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 40, color: Colors.black)),
        backgroundColor: Color.fromRGBO(232, 204, 191, 0.75),
        elevation: 0,
        actions: [
          // Booking Status button
          TextButton(
            onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingHistoryPage()),
            );
          },
            child: Text('Booking Status', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 20, color: Colors.black))
          ),
          
          // Ratings Buttons
          TextButton(
              onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RatingsPage()),
              );
            },
            child: Text('Review', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 20, color: Colors.black)),
          ),
          
          // About Us Button
          TextButton(onPressed: () {
            _showAboutUsDialog(context);
          },
          child: Text('About Us', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 20, color: Colors.black))),
          
          // Logout Button
          TextButton(
            onPressed: _logout,
            child: Text('Log Out', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 20, color: Colors.black)),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/homeBG.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Semi-transparent Overlay
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Main Content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Title and Subtitle
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(232, 204, 191, 0.75),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Discover Your Perfect Stay',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Italiana-Regular',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Experience world-class hospitality and create unforgettable memories with our premium handpicked stays around the globe',
                          style: TextStyle(
                            fontFamily: 'Italiana-Regular',
                            fontSize: 22,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Search Form
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      // Set a fixed width and height for the form
                      maxWidth: 400,
                      maxHeight: 350,
                    ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(232, 204, 191, 0.75),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        // Destination Field
                        Text('Destination', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextField(
                          controller: destinationController,
                          decoration: InputDecoration(
                            hintText: 'Enter destination',
                            border: OutlineInputBorder(borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                        SizedBox(height: 15),

                        // Number of Guests Field
                        Text('Number of Guests', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextField(
                          controller: guestsController,
                          decoration: InputDecoration(
                            hintText: 'Enter number of guests',
                            border: OutlineInputBorder(borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 15),

                        // Check-In & Check-Out Date Fields
                        Text('Check In & Out Dates', style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDate(context, true),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    checkInDate != null
                                        ? DateFormat('MM/dd/yyyy').format(checkInDate!)
                                        : 'Check-In Date',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDate(context, false),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    checkOutDate != null
                                        ? DateFormat('MM/dd/yyyy').format(checkOutDate!)
                                        : 'Check-Out Date',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Search Hotels Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HotelSearchPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(255, 82, 82, 1),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Search Hotels'),
                        ),
                      ],
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
