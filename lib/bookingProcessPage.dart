import 'package:flutter/material.dart';

class BookingProcessPage extends StatefulWidget {
  final String hotelName;
  final String hotelAddress;
  final String roomType;
  final double pricePerGuest;

  BookingProcessPage({
    required this.hotelName,
    required this.hotelAddress,
    required this.roomType,
    required this.pricePerGuest,
  });
  
  @override
  _BookingProcessPageState createState() => _BookingProcessPageState();
}

class _BookingProcessPageState extends State<BookingProcessPage> {
  int guestCount = 1;
  double get totalPrice => widget.pricePerGuest * guestCount;

  // Controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expirationDateController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Process'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel Booking',
              style: TextStyle(color: Colors.yellow[800], fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel and Room Information
            Card(
              color: Color.fromRGBO(232, 204, 191, 0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.hotelName,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.hotelAddress),
                    SizedBox(height: 10),
                    Text('Room Type: ${widget.roomType}'),
                    Text('Price per Guest: \$${widget.pricePerGuest.toStringAsFixed(2)}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (guestCount > 1) guestCount--;
                                });
                              },
                            ),
                            Text('$guestCount Guests'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  guestCount++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Check-In Information
            Card(
              color: Color.fromRGBO(232, 204, 191, 0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Who is checking in?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Full Name'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Billing and Payment Information
            Card(
              color: Color.fromRGBO(232, 204, 191, 0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Billing and Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(labelText: 'Address'),
                    ),
                    TextField(
                      controller: cityController,
                      decoration: InputDecoration(labelText: 'City, State'),
                    ),
                    TextField(
                      controller: zipController,
                      decoration: InputDecoration(labelText: 'ZIP Code'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: cardNumberController,
                      decoration: InputDecoration(labelText: 'Card Number'),
                    ),
                    TextField(
                      controller: expirationDateController,
                      decoration: InputDecoration(labelText: 'Expiration Date'),
                    ),
                    TextField(
                      controller: cvcController,
                      decoration: InputDecoration(labelText: 'CVC'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Confirm Booking Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Process the booking
                },
                child: Text('Confirm Booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
