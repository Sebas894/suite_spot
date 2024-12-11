import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:suite_spot/historyPage.dart';
import 'homePage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';


class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({super.key});

  @override
  _HotelSearchPageState createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  String searchCity = "";
  String? selectedHotelId;

  double maxPrice = 500;
  double minRating = 0.0;
  List<String> selectedAmenities = [];

  DateTime? checkInDate;
  DateTime? checkOutDate;
  String roomType = 'Traditional';
  int numberOfGuests = 1;

  String fullName = '';
  String email = '';
  String phoneNumber = '';
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';
  String billingAddress = '';

  final amenitiesList = [
    'Wi-Fi',
    'Pool',
    'Parking',
    'Air Conditioning',
    'Hot Tub',
    'Restaurant',
    'Bar',
    'Fitness',
    'Pet-Friendly'
  ];

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    DateTime initialDate =
        isCheckIn ? DateTime.now() : (checkInDate ?? DateTime.now()).add(Duration(days: 1));

    DateTime firstDate =
        isCheckIn ? DateTime.now() : (checkInDate ?? DateTime.now()).add(Duration(days: 1));

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

  double calculateTotalCost(double pricePerNight) {
    if (checkInDate == null || checkOutDate == null) {
      return 0.0;
    }

    int numberOfNights = checkOutDate!.difference(checkInDate!).inDays;
    double baseRate = roomType == 'Traditional' ? pricePerNight : pricePerNight * 1.5;
    double additionalGuestCost = (numberOfGuests - 1) * 20.0;
    double totalCost = (baseRate + additionalGuestCost) * numberOfNights.toDouble();

    return totalCost;
  }

void _showBookingConfirmationDialog(BuildContext context, String hotelName, double totalCost, String address) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents dismissing by tapping outside the dialog
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          bool isFormValid() {
            final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
            final phoneRegex = RegExp(r"^\d{10}$");
            final cardNumberRegex = RegExp(r"^\d{16}$");
            final cvvRegex = RegExp(r"^\d{3}$");
            final expiryDateRegex = RegExp(r"^(0[1-9]|1[0-2])\/\d{2}$");

            String sanitizedPhoneNumber = phoneNumber.replaceAll('-', '');
            String sanitizedCardNumber = cardNumber.replaceAll('-', '');

            if (!emailRegex.hasMatch(email)) return false;
            if (!phoneRegex.hasMatch(sanitizedPhoneNumber)) return false;
            if (!cardNumberRegex.hasMatch(sanitizedCardNumber)) return false;
            if (!cvvRegex.hasMatch(cvv)) return false;

            if (!expiryDateRegex.hasMatch(expiryDate)) return false;
            try {
              final parts = expiryDate.split('/');
              final month = int.parse(parts[0]);
              final year = int.parse(parts[1]) + 2000;
              final now = DateTime.now();
              final expiry = DateTime(year, month + 1);
              if (expiry.isBefore(now)) return false;
            } catch (e) {
              return false;
            }

            if (fullName.isEmpty || billingAddress.isEmpty) return false;

            return true;
          }

          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Color(0xFFEEDACB),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reservation Review',
                            style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFFA57045)),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Color(0xFFA57045)),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                        ],
                      ),
                    SizedBox(height: 16),
                    Text('Hotel Name: $hotelName', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Total Cost: \$${totalCost.toStringAsFixed(2)}', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 24),
                    Text(
                      '**All fields must be filled in for both Guest and Payment information',
                      style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    Text(
                      'Guest Information',
                      style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person, color: Color(0xFFA57045)),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onChanged: (value) {
                        setState(() {
                          fullName = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email, color: Color(0xFFA57045)),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone, color: Color(0xFFA57045)),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          String newText = newValue.text.replaceAll('-', '');
                          final buffer = StringBuffer();
                          for (int i = 0; i < newText.length; i++) {
                            if (i == 3 || i == 6) buffer.write('-');
                            buffer.write(newText[i]);
                          }
                          return TextEditingValue(
                            text: buffer.toString(),
                            selection: TextSelection.collapsed(offset: buffer.length),
                          );
                        })
                      ],
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {
                          phoneNumber = value;
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Payment Information',
                      style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Card Number',
                        prefixIcon: Icon(Icons.credit_card, color: Color(0xFFA57045)),
                        fillColor: Colors.white,
                        filled: true,  
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          String newText = newValue.text.replaceAll('-', '');
                          final buffer = StringBuffer();
                          for (int i = 0; i < newText.length; i++) {
                            if (i > 0 && i % 4 == 0) buffer.write('-');
                              buffer.write(newText[i]);
                          }
                            return TextEditingValue(
                              text: buffer.toString(),
                              selection: TextSelection.collapsed(offset: buffer.length),
                          );
                        })
                      ],
                      onChanged: (value) {
                        setState(() {
                          cardNumber = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Expiry Date (MM/YY)',
                        prefixIcon: Icon(Icons.calendar_month, color: Color(0xFFA57045)),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          String newText = newValue.text.replaceAll('/', '');
                          final buffer = StringBuffer();
                          for (int i = 0; i < newText.length; i++) {
                            if (i == 2) buffer.write('/');
                            buffer.write(newText[i]);
                          }
                          return TextEditingValue(
                            text: buffer.toString(),
                            selection: TextSelection.collapsed(offset: buffer.length),
                          );
                        })
                      ],
                      onChanged: (value) {
                        setState(() {
                          expiryDate = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        prefixIcon: Icon(Icons.lock, color: Color(0xFFA57045)),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      onChanged: (value) {
                        setState(() {
                          cvv = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Billing Address',
                        prefixIcon: Icon(Icons.home, color: Color(0xFFA57045)),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onChanged: (value) {
                        setState(() {
                          billingAddress = value;
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: isFormValid()
                            ? () {
                                Navigator.of(context).pop(); // Close the review dialog
                                _showReservationCompletedDialog(context, hotelName, address);
                              }
                            : null,
                        child: Text('Confirm Reservation'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}


void _showReservationCompletedDialog(BuildContext context, String hotelName, String address) {
  String reservationID = _generateReservationID();

  // Fetch the current user's UID from Firebase Authentication
  String? currentUserUID = FirebaseAuth.instance.currentUser?.uid;

  if (currentUserUID != null) {
    // Save reservation to Firebase
    _saveReservationToFirebase(
      currentUserUID,
      reservationID,
      hotelName,
      address,
      checkInDate!,
      checkOutDate!,
    );

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Color(0xFFEEDACB),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Reservation Completed',
                    style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                Text('Reservation ID: $reservationID', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Text('Hotel Name: $hotelName', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Address: $address', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Number of Guests: $numberOfGuests', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Check-In Date: ${_formatDate(checkInDate!)}', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Check-Out Date: ${_formatDate(checkOutDate!)}', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the reservation complete dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Thank you for your reservation!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFA57045), // Medium Brown button color
                        foregroundColor: Colors.white, // White text color
                      ),
                      child: Text('Close'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the reservation complete dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BookingHistoryPage()),
                        ); // Navigate to Booking History page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFA57045), // Medium Brown button color
                        foregroundColor: Colors.white, // White text color
                      ),
                      child: Text('View Booking History'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  } else {
    // Handle the case where no user is logged in (optional)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: User not logged in. Please log in to make a reservation.')),
    );
  }
}

void _saveReservationToFirebase(String currentUserUID, String reservationID, String hotelName, String address, DateTime checkInDate, DateTime checkOutDate) async {
  // Create a reference to the user's document in the "accounts" collection
  DocumentReference userDocRef = FirebaseFirestore.instance.collection('accounts').doc(currentUserUID);

  // Create a reference to the "reservations" subcollection
  CollectionReference reservationsRef = userDocRef.collection('reservations');

  // Prepare the reservation data
  Map<String, dynamic> reservationData = {
    'reservationID': reservationID,
    'hotelName': hotelName,
    'address': address,
    'checkInDate': _formatDate(checkInDate),
    'checkOutDate': _formatDate(checkOutDate),
    'numberOfGuests': numberOfGuests,
    'status': 'UPCOMING',
    'createdAt': FieldValue.serverTimestamp(), // Add a timestamp to track creation
  };

  // Save the reservation data to Firestore
  try {
    await reservationsRef.add(reservationData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reversaton saved successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error saving reservation: $e")),
    );
  }
} 

  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _generateReservationID() {
    var random = Random();
    return String.fromCharCodes(List.generate(8, (index) => random.nextInt(26) + 65)) + random.nextInt(10000).toString();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEDACB),
      appBar: AppBar(
        title: Text('Hotel Search', style: TextStyle(fontFamily: 'Italian-Regular')),
        backgroundColor: Color(0xFFA57045),
      ),
      body: Row(
        children: [
          // Sidebar for filters
          Container(
            width: 300,
            color: Color.fromARGB(255, 232, 181, 142),
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Text(
                  'Filters',
                  style: TextStyle(
                    fontFamily: 'Italiana-Regular', 
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Text('Max Price (\$${maxPrice.toInt()})', style: TextStyle(fontFamily: 'Italian-Regular')),
                  subtitle: Slider(
                    value: maxPrice,
                    min: 50,
                    max: 500,
                    divisions: 9,
                    label: '\$${maxPrice.toInt()}',
                    onChanged: (value) {
                      setState(() {
                        maxPrice = value;
                      });
                    },
                  ),
                ),
                ExpansionTile(
                  title: Text('Amenities', style: TextStyle(fontFamily: 'Italian-Regular')),
                  children: amenitiesList.map((amenity) {
                    return CheckboxListTile(
                      title: Text(amenity, style: TextStyle(fontFamily: 'Italian-Regular')),
                      value: selectedAmenities.contains(amenity),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedAmenities.add(amenity);
                          } else {
                            selectedAmenities.remove(amenity);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                ListTile(
                  title: Text('Minimum Rating (${minRating.toStringAsFixed(1)})', style: TextStyle(fontFamily: 'Italian-Regular')),
                  subtitle: Slider(
                    value: minRating,
                    min: 0.0,
                    max: 5.0,
                    divisions: 10,
                    label: minRating.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        minRating = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Main content area for hotel cards
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search by City',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFA57045)),
                      ),
                      suffixIcon: Icon(Icons.search, color: Color(0xFFA57045)),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchCity = value.trim();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: (searchCity.isEmpty)
                        ? FirebaseFirestore.instance.collection('hotels').snapshots()
                        : FirebaseFirestore.instance
                            .collection('hotels')
                            .where('city', isEqualTo: searchCity)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No hotels found for the city "$searchCity"'));
                      }

                      final filteredDocs = snapshot.data!.docs.where((doc) {
                        final price = doc['price'] ?? 0.0;
                        final rating = doc['rating'] ?? 0.0;
                        final amenities = List<String>.from(doc['amenities'] ?? []);

                        // Apply filters: price, rating, amenities
                        final matchesPrice = price <= maxPrice;
                        final matchesRating = rating >= minRating;
                        final matchesAmenities = selectedAmenities.isEmpty ||
                            selectedAmenities.every((amenity) => amenities.contains(amenity));

                        return matchesPrice && matchesRating && matchesAmenities;
                      }).toList();

                      if (filteredDocs.isEmpty) {
                        return Center(child: Text('No hotels match the applied filters.'));
                      }

                      return ListView(
                        children: filteredDocs.map((doc) {
                          return HotelCard(
                            doc: doc,
                            isSelected: selectedHotelId == doc.id,
                            onTap: () {
                              setState(() {
                                selectedHotelId = (selectedHotelId == doc.id) ? null : doc.id;
                              });
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Sidebar for booking details
          if (selectedHotelId != null)
            Container(
              width: 300,
              color: Color.fromARGB(255, 232, 181, 142),
              padding: EdgeInsets.all(16.0),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('hotels')
                    .doc(selectedHotelId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var hotelData = snapshot.data!.data() as Map<String, dynamic>;
                  double pricePerNight = hotelData['price'] ?? 0.0;
                  double totalCost = calculateTotalCost(pricePerNight);

                  return ListView(
                    children: [
                      Text(
                        hotelData['name'],
                        style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                        Text(hotelData['address'],
                          style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      SizedBox(height: 8),
                        Text(
                          'Amenities: ${hotelData['amenities'].join(", ")}',
                          style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                      SizedBox(height: 16),
                        Text(
                          'Check-In Date',
                          style: TextStyle(fontFamily: 'Italiana-Regular', fontWeight: FontWeight.bold),
                        ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _selectDate(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFFA57045),
                        ),
                        child: Text(checkInDate == null ? 'Select Check-In Date' : checkInDate.toString().split(' ')[0]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Check-Out Date',
                        style: TextStyle(fontFamily: 'Italiana-Regular', fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _selectDate(context, false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFFA57045),
                        ),
                        child: Text(checkOutDate == null ? 'Select Check-Out Date' : checkOutDate.toString().split(' ')[0]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Room Type',
                        style: TextStyle(fontFamily: 'Italiana-Regular', fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      DropdownButton<String>(
                        value: roomType,
                        onChanged: (String? newValue) {
                          setState(() {
                            roomType = newValue!;
                          });
                        },
                        items: <String>['Traditional', 'Deluxe']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Number of Guests',
                        style: TextStyle(fontFamily: 'Italiana-Regular', fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      StepperControl(
                        currentValue: numberOfGuests,
                        onValueChanged: (value) {
                          setState(() {
                            numberOfGuests = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Total Cost: \$${totalCost.toStringAsFixed(2)}',
                        style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: (checkInDate == null || checkOutDate == null)? null : () { _showBookingConfirmationDialog(
                                  context,
                                  hotelData['name'],
                                  totalCost,
                                  hotelData['address'],
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFFA57045),
                        ),
                        child: Text('Book Now'),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}



class HotelCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  final bool isSelected;
  final VoidCallback onTap;

  const HotelCard({super.key, required this.doc, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.all(8.0),
        color: isSelected ? Color(0xFFA57045) : Color(0xFFEEDACB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Color.fromARGB(255, 57, 39, 24), width: 2.0), // Visible border for the card
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(doc['name'], style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 25, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black),),
              SizedBox(height: 8),
              Text(doc['address'], style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black),),
              SizedBox(height: 8),
              Text('City: ${doc['city']}', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black),),
              SizedBox(height: 8),
              Text('Price: \$${doc['price']} per night', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black),),
              SizedBox(height: 8),
              Text('Rating: ${doc['rating']}', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black),),
              SizedBox(height: 8),
              Text('Amenities: ${doc['amenities'].join(", ")}', style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black),),
            ],
          ),
        ),
      ),
    );
  }
}

class StepperControl extends StatelessWidget {
  final int currentValue;
  final ValueChanged<int> onValueChanged;

  const StepperControl({super.key, required this.currentValue, required this.onValueChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: currentValue > 1 ? () => onValueChanged(currentValue - 1) : null,
          icon: Icon(Icons.remove, color: Color(0xFFA57045)),
        ),
        Text(
          '$currentValue',
          style: TextStyle(fontFamily: 'Italiana-Regular', fontSize: 18, color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: currentValue < 4 ? () => onValueChanged(currentValue + 1) : null,
          icon: Icon(Icons.add, color: Color(0xFFA57045)),
        ),
      ],
    );
  }
}
