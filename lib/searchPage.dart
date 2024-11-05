import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'homePage.dart';

class SearchResultsPage extends StatefulWidget {
  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  DateTime? checkInDate;
  DateTime? checkOutDate;

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? (checkInDate ?? DateTime.now())
          : (checkOutDate ?? (checkInDate ?? DateTime.now()).add(Duration(days: 1))),
      firstDate: isCheckIn ? DateTime.now() : (checkInDate ?? DateTime.now()),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = pickedDate;
          checkOutDate = null; // Reset check-out date whenever check-in date changes
        } else {
          checkOutDate = pickedDate;
        }
      });
    }
  }

  // Sample hotel data
  final List<Map<String, String>> hotels = [
    {
      "name": "Grand Plaza",
      "address": "123 Main St, Cityville",
      "services": "Free Wi-Fi, Breakfast, Pool",
      "price": "\$150/night",
      "rating": "4.5"
    },
    {
      "name": "Ocean Breeze",
      "address": "456 Ocean Dr, Beachside",
      "services": "Ocean View, Gym, Spa",
      "price": "\$200/night",
      "rating": "4.8"
    },
    {
      "name": "Mountain Retreat",
      "address": "789 Mountain Rd, Hilltown",
      "services": "Hiking Trails, Free Parking, Hot Tub",
      "price": "\$180/night",
      "rating": "4.6"
    },
    {
      "name": "Urban Escape",
      "address": "101 Downtown Ave, Metropolis",
      "services": "Free Wi-Fi, Business Center, Bar",
      "price": "\$130/night",
      "rating": "4.2"
    },
    {
      "name": "Lakeview Resort",
      "address": "202 Lake Ln, Waterside",
      "services": "Lake View, Free Kayaks, Picnic Area",
      "price": "\$170/night",
      "rating": "4.7"
    }
  ];

  // Selected hotel data for details card
  Map<String, String>? selectedHotel;

  // Track selected room index
  int? selectedRoomIndex;

  // Initial value for prices
  double _selectedPrice = 250;
  
  // Initial value for guest rating
  int _selectedRating = 0;

  // Map to store the selection status of each service option
  Map<String, bool> _services = {
    'WiFi': false,
    'Meals': false,
    'Pool': false,
    'Gym': false,
    'Spa': false,
    'Hot Tub': false,
    'Laundry': false,
    'Room Service': false,
    'Transport': false,
  };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Suite Spot',
          style: TextStyle(fontFamily: 'Serif', color: Colors.black),
        ),
        backgroundColor: Color.fromRGBO(232, 204, 191, 1),
        elevation: 0,
      ),
      body: Row(
        children: [
           // Sidebar for Filters (Scrollable)
          Container(
            width: 200,
            color: Color.fromRGBO(232, 204, 191, 0.9),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Filter with slider
                  Text(
                    'Price',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _selectedPrice,
                    min: 20,
                    max: 500,
                    divisions: 48,
                    label: '\$${_selectedPrice.toInt()}',
                    onChanged: (double value) {
                      setState(() {
                        _selectedPrice = value;
                      });
                    },
                  ),
                  Text(
                    'Max Price: \$${_selectedPrice.toInt()}',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 20),

                  // Services offered filter
                  Text(
                    'Services Offered',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: _services.keys.map((service) {
                      return CheckboxListTile(
                        title: Text(service),
                        value: _services[service],
                        onChanged: (bool? value) {
                          setState(() {
                            _services[service] = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),

                  // Guest Ratings filter with clickable stars
                  Text(
                    'Guest Ratings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        iconSize: 20,
                        icon: Icon(
                          Icons.star,
                          color: index < _selectedRating ? Colors.yellow : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 20),


                  Text('Property Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // Main Content Area
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Search Input Section
                  Row(
                    children: [

                      // Location input
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),




// Check-In Date Picker
Flexible(
  child: GestureDetector(
    onTap: () => _selectDate(context, true),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        checkInDate != null
          ? 'Check-In: ${DateFormat('yyyy-MM-dd').format(checkInDate!)}'
          : 'Select Check-In Date',
        style: TextStyle(color: Colors.black54),
      ),
    ),
  ),  
),
SizedBox(width: 10),

// Check-Out Date Picker
Flexible(
  child: GestureDetector(
    onTap: () => _selectDate(context, false),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        checkOutDate != null
          ? 'Check-Out: ${DateFormat('yyyy-MM-dd').format(checkOutDate!)}'
          : 'Select Check-Out Date',
        style: TextStyle(color: Colors.black54),
      ),
    ),
  ),
),
 SizedBox(width: 10),



                      // Number of guests input
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: '# of Guests',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Search logic goes here
                        },
                        child: Icon(Icons.search),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Hotel Results & Map and Details Section
                  Expanded(
                    child: Row(
                      children: [
                        // Hotel Results Container
                        Expanded(
                          flex: 2,
                          child: ListView.builder(
                            itemCount: hotels.length,
                            itemBuilder: (context, index) {
                              return buildHotelCard(hotels[index]);
                            },
                          ),
                        ),
                        SizedBox(width: 20),

                        // Map and Details Container
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              // Google Maps API Placeholder
                              Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: Center(
                                  child: Text(
                                    'Google Maps API\n(Hotel Location)',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              // Hotel Details Card
                              Expanded(
                                child: Card(
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
                                          'Hotel Name: ${selectedHotel?["name"] ?? "Select a hotel"}',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        Text('Address: ${selectedHotel?["address"] ?? "N/A"}'),
                                        SizedBox(height: 10),
                                        Text('Services: ${selectedHotel?["services"] ?? "N/A"}'),
                                        SizedBox(height: 10),
                                        Text(
                                          'Rooms Available:',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        // Room Choices
                                        Expanded(
                                          child: ListView(
                                            children: List.generate(3, (index) => buildRoomCard(index)),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Booking process navigation
                                            },
                                            child: Text('Proceed to Booking'),
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  // Build a hotel card with information and interaction
  Widget buildHotelCard(Map<String, String> hotel) {
  bool isSelected = selectedHotel == hotel; // Check if this hotel is selected
  return Card(
    margin: EdgeInsets.only(bottom: 15),
    color: isSelected ? Colors.blue[100] : Colors.white, // Highlight color if selected
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      leading: Container(
        width: 50,
        height: 50,
        color: Colors.grey, // Placeholder for hotel image
      ),
      title: Text(hotel["name"] ?? "Hotel Name"),
      subtitle: Row(
        children: [
          Icon(Icons.star, color: Colors.yellow[700]),
          Text('${hotel["rating"]} Rating • ${hotel["price"]}'),
        ],
      ),
      onTap: () {
        setState(() {
          selectedHotel = hotel; // Update selected hotel details
          selectedRoomIndex = null; // Reset selected room when a new hotel is selected
        });
      },
    ),
  );
}


  // Build a sample room card for room selection in the details section
  Widget buildRoomCard(int index) {
    bool isRoomSelected = selectedRoomIndex == index; // Check if this room is selected
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      color: isRoomSelected ? Colors.blue[100] : Colors.white, // Highlight color if selected
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          color: Colors.grey, // Placeholder for room image
        ),
        title: Text('Room Type $index'),
        onTap: () {
          setState(() {
            selectedRoomIndex = index; // Update selected room index
          });
        },
      ),
    );
  }
}