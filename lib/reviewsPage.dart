import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewsPage extends StatefulWidget {
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _rating = 3.0; // Added to track slider value
  final TextEditingController _reviewController = TextEditingController();
  String? _selectedHotel; // Track selected hotel for hotel reviews

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _reviewController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reviewController.removeListener(_checkFormValidity);
    _reviewController.dispose();
    super.dispose();
  }

  bool _isSubmitEnabled = false;

  void _checkFormValidity() {
    setState(() {
      _isSubmitEnabled = _reviewController.text.isNotEmpty && (_selectedHotel != null || _tabController.index == 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/homeBG.png'),
                fit: BoxFit.cover,
              ),
            ),
        child: Column(
          children: [
            Container(
              color: Color.fromRGBO(232, 204, 191, 1), // AppBar color
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Reviews',
                    style: TextStyle(color: Colors.black, fontFamily: 'Italiana-Regular', fontSize: 26),
                  ),
                ],
              ),
            ),
            Container(
              color: Color.fromRGBO(165, 111, 77, 1), // TabBar background color
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: TextStyle(
                  fontFamily: 'Italiana-Regular',
                  fontSize: 20, // Font size for selected tab
                  fontWeight: FontWeight.bold, // Font weight for selected tab
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'Italiana-Regular',
                  fontSize: 16, // Font size for unselected tab
                  fontWeight: FontWeight.normal, // Font weight for unselected tab
                ),
                tabs: [
                  Tab(text: 'Hotel Reviews'),
                  Tab(text: 'Site Reviews'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildReviewTab(isHotelReview: true),
                  buildReviewTab(isHotelReview: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget buildReviewTab({required bool isHotelReview}) {
  final collection = isHotelReview ? 'hotelReviews' : 'siteReviews';
  return Center(
    child: Container(
      width: 900, // Set fixed width for content
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 450,
              child: Card(
                color: Color.fromRGBO(232, 204, 191, 1),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isHotelReview)
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Hotel',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem(value: 'Belmont Shore Inn', child: Text('Belmont Shore Inn')),
                            DropdownMenuItem(value: 'Best Western Liberty Inn', child: Text('Best Western Liberty Inn')),
                            DropdownMenuItem(value: 'Best Western Plus Carriage Inn', child: Text('Best Western Plus Carriage Inn')),
                            DropdownMenuItem(value: 'Chaminade Resort & Spa', child: Text('Chaminade Resort & Spa')),
                            DropdownMenuItem(value: 'Double Tree', child: Text('Double Tree')),
                            DropdownMenuItem(value: 'FOUND Hotel', child: Text('FOUND Hotel')),
                            DropdownMenuItem(value: 'Freehand Los Angeles', child: Text('Freehand Los Angeles')),
                            DropdownMenuItem(value: 'Gaslamp Plaza Suites', child: Text('Gaslamp Plaza Suites')),
                            DropdownMenuItem(value: 'Hampton Inn', child: Text('Hampton Inn')),
                            DropdownMenuItem(value: 'Hilton Long Beach', child: Text('Hilton Long Beach')),
                            DropdownMenuItem(value: 'Hilton Woodland Hills', child: Text('Hilton Woodland Hills')),
                            DropdownMenuItem(value: 'Hollywood Inn Suites', child: Text('Hollywood Inn Suites')),
                            DropdownMenuItem(value: 'Home2 Suites', child: Text('Home2 Suites')),
                            DropdownMenuItem(value: 'Hotel Amarano Burbank', child: Text('Hotel Amarano Burbank')),
                            DropdownMenuItem(value: 'Hotel Z', child: Text('Hotel Z')),
                            DropdownMenuItem(value: 'Indian Wells Resort', child: Text('Indian Wells Resort')),
                            DropdownMenuItem(value: 'Kasa La Monarca', child: Text('Kasa La Monarca')),
                            DropdownMenuItem(value: 'Margaritaville Hotel', child: Text('Margaritaville Hotel')),
                            DropdownMenuItem(value: 'Moxy Downtown', child: Text('Moxy Downtown')),
                            DropdownMenuItem(value: 'Omni Los Angeles', child: Text('Omni Los Angeles')),
                            DropdownMenuItem(value: 'Pacific Edge', child: Text('Pacific Edge')),
                            DropdownMenuItem(value: 'San Francisco Proper', child: Text('San Francisco Proper')),
                            DropdownMenuItem(value: 'Staypineapple San Francisco', child: Text('Staypineapple San Francisco')),
                            DropdownMenuItem(value: 'The Marker Union Square', child: Text('The Marker Union Square')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedHotel = value;
                              _checkFormValidity();
                            });
                          },
                        ),
                      if (isHotelReview) SizedBox(height: 16),
                      Text('Rating:'),
                      Slider(
                        value: _rating,
                        min: 0.0,
                        max: 5.0,
                        divisions: 10,
                        label: _rating.toString(),
                        onChanged: (value) {
                          setState(() {
                            _rating = value;
                          });
                        },
                      ),
                      TextField(
                        controller: _reviewController,
                        decoration: InputDecoration(
                          labelText: 'Write your review',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 4,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isSubmitEnabled ? () => _submitReview(collection, isHotelReview) : null,
                        child: Text('Submit Review'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(collection).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No reviews available'));
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return Card(
                        color: Color.fromRGBO(232, 204, 191, 1),
                        child: ListTile(
                          title: Text('Username: ${data['username']}',
                            style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Italiana-Regular',
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.black87,
                                ),),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isHotelReview)
                                Text('Hotel: ${data['hotelName'] ?? ''}',
                                  style: TextStyle(
                                  fontSize: 16, 
                                  fontFamily: 'Italiana-Regular',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87, 
                                ),),
                                Text('Rating: ${data['score']}',
                                  style: TextStyle(
                                  fontSize: 16, 
                                  fontFamily: 'Italiana-Regular',
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.black87, 
                                ),),
                                Text('Review: ${data['description']}',
                                  style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Italiana-Regular',
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.black87, 
                                ),),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



  void _submitReview(String collection, bool isHotelReview) async {
    if (isHotelReview && _selectedHotel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a hotel.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to submit a review.')),
      );
      return;
    }

    // Fetch the username from the accounts collection
    String username = 'Anonymous'; // Default username
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        username = userData?['username'] ?? 'Anonymous';
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch username: $error')),
      );
    }

    final reviewData = {
      'username': username,
      'score': _rating.toString(),
      'description': _reviewController.text,
      if (isHotelReview) 'hotelName': _selectedHotel,
    };

    FirebaseFirestore.instance.collection(collection).add(reviewData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submitted successfully!')),
      );
      _reviewController.clear();
      setState(() {
        _rating = 3.0;
        _selectedHotel = null;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $error')),
      );
    });
  }
}
