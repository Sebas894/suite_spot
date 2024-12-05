import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homePage.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Suite Spot',
            style: TextStyle(fontFamily: 'Italiana-Regular', color: Colors.black),
          ),
          backgroundColor: Color.fromRGBO(232, 204, 191, 1),
          elevation: 0,
        ),
        body: Center(
          child: Text('No user is currently logged in.'),
        ),
      );
    }

    final String userId = currentUser.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Suite Spot',
          style: TextStyle(fontFamily: 'Italiana-Regular', color: Colors.black),
        ),
        backgroundColor: Color.fromRGBO(232, 204, 191, 1),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/historyBG.png'), // Replace with the path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Overlay and Content
          Column(
            children: [
              // Title
              Container(
                color: Color.fromRGBO(165, 111, 77, 1),
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: Text(
                    'Booking History and Status',
                    style: TextStyle(
                      fontFamily: 'Italiana-Regular',
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Booking History Table
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Color.fromRGBO(232, 204, 191, 1), // Light-colored card for better contrast
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('accounts')
                            .doc(userId)
                            .collection('reservations')
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error loading reservations.'));
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No reservations found.'));
                          }

                          final reservations = snapshot.data!.docs;

                          return SingleChildScrollView(
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Reservation ID')),
                                DataColumn(label: Text('Hotel Name')),
                                DataColumn(label: Text('Check-In')),
                                DataColumn(label: Text('Check-Out')),
                                DataColumn(label: Text('Status')),
                              ],
                              rows: reservations.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                return DataRow(cells: [
                                  DataCell(Text(data['reservationID'] ?? 'N/A')),
                                  DataCell(Text(data['hotelName'] ?? 'N/A')),
                                  DataCell(Text(data['checkInDate'] ?? 'N/A')),
                                  DataCell(Text(data['checkOutDate'] ?? 'N/A')),
                                  DataCell(Text(data['status'] ?? 'N/A')),
                                ]);
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

