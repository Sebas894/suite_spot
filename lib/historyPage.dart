import 'package:flutter/material.dart';
import 'homePage.dart';

class BookingHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              
              // Booking History Card
              Center(
                child: Card(
                  color: Color.fromRGBO(232, 204, 191, 0.95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: 700, // Fixed width
                    height: 400, // Fixed height
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reservation Records',
                          style: TextStyle(
                            fontFamily: 'Italiana-Regular',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text('Reservation ID')),
                                DataColumn(label: Text('Hotel Name')),
                                DataColumn(label: Text('Check-In')),
                                DataColumn(label: Text('Check-Out')),
                                DataColumn(label: Text('Status')),
                              ],
                              rows: [
                                // Placeholder rows
                                DataRow(cells: [
                                  DataCell(Text('12345')),
                                  DataCell(Text('Grand Plaza')),
                                  DataCell(Text('2024-11-10')),
                                  DataCell(Text('2024-11-15')),
                                  DataCell(Text('UPCOMING')),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('67890')),
                                  DataCell(Text('Ocean Breeze')),
                                  DataCell(Text('2024-06-01')),
                                  DataCell(Text('2024-06-05')),
                                  DataCell(Text('COMPLETED')),
                                ]),
                                // Add more rows as needed
                              ],
                            ),
                          ),
                        ),
                      ],
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
