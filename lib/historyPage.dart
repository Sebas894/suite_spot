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
                    color: Color.fromRGBO(232, 204, 191, 0.85), // Light-colored card for better contrast
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('accounts')
                            .doc(userId)
                            .collection('reservations')
                            .snapshots(),
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
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: reservations.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                final status = data['status'] ?? 'N/A';
                                return DataRow(
                                  cells: [
                                    DataCell(Text(data['reservationID'] ?? 'N/A')),
                                    DataCell(Text(data['hotelName'] ?? 'N/A')),
                                    DataCell(Text(data['checkInDate'] ?? 'N/A')),
                                    DataCell(Text(data['checkOutDate'] ?? 'N/A')),
                                    DataCell(Text(status)),
                                    //DataCell(Text(data['status'] ?? 'N/A')),
                                    DataCell(
                                      ElevatedButton(
                                        onPressed: (status == 'CANCELLED' || status == 'COMPLETE')
                                            ? null // Disable button for CANCELLED or COMPLETE reservations
                                            : () {
                                                _showCancellationDialog(context, userId, doc.id);
                                              },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: (status == 'CANCELLED' || status == 'COMPLETE')
                                              ? Colors.white // White text for disabled
                                              : Colors.white, // White text for active
                                          backgroundColor: (status == 'CANCELLED' || status == 'COMPLETE')
                                              ? Colors.grey // Greyed out for disabled
                                              : Colors.brown, // White text for active
                                        ),
                                        child: Text(
                                          status == 'CANCELLED' || status == 'COMPLETE'
                                              ? 'Not Available'
                                              : 'Cancel',
                                          style: TextStyle(
                                            color: (status == 'CANCELLED' || status == 'COMPLETE')
                                                ? Colors.black // Black text for greyed-out button
                                                : Colors.white, // White text for active button
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
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

  void _showCancellationDialog(BuildContext context, String userId, String reservationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Reservation'),
          content: Text('Are you sure you want to cancel this reservation?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('accounts')
                    .doc(userId)
                    .collection('reservations')
                    .doc(reservationId)
                    .update({'status': 'CANCELLED'});
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reservation status set to CANCELLED.')),
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}