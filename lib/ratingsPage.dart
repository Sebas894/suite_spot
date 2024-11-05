import 'package:flutter/material.dart';
import 'homePage.dart';

class RatingsPage extends StatefulWidget {
  @override
  _RatingsPageState createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for the text fields
  final TextEditingController hotelNameController = TextEditingController();
  final TextEditingController hotelReviewController = TextEditingController();
  final TextEditingController siteReviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    hotelNameController.dispose();
    hotelReviewController.dispose();
    siteReviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suite Spot', style: TextStyle(fontFamily: 'Italiana-Regular', color: Colors.black)),
        backgroundColor: Color.fromRGBO(232, 204, 191, 1),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Title and Tabs
          Container(
            color: Color.fromRGBO(165, 111, 77, 1), 
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Center(
              child: Text(
                'Leave a Review!',
                style: TextStyle(
                  fontFamily: 'Italiana-Regular',
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            color: Color.fromRGBO(165, 111, 77, 1),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: 'Hotel Reviews'),
                Tab(text: 'Site Reviews'),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color.fromRGBO(232, 204, 191, 0.8),
              padding: EdgeInsets.all(20),
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Hotel Reviews Tab
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: hotelNameController,
                        decoration: InputDecoration(
                          labelText: 'Hotel Name',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15),
                      
                      // Box for users to write their hotel review
                      SizedBox(
                        height: 150,
                        child: TextField(
                          controller: hotelReviewController,
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            labelText: 'Write your review here...',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Add logic to submit hotel review
                          print("Hotel Name: ${hotelNameController.text}");
                          print("Hotel Review: ${hotelReviewController.text}");
                        },
                        child: Text('Submit Review'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(165, 111, 77, 1),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // Display for other user reviews
                      // Placeholder reviews
                      Expanded(
                        child: ListView(
                          children: [
                            Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Username: User1", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    SizedBox(height: 5),
                                    Text("Hotel Name: Grand Plaza", style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                                    SizedBox(height: 10),
                                    Text("Great stay at the hotel! Very clean and comfortable."),
                                  ],
                                ),
                              ),
                            ),
                            
                            Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Username: User2", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    SizedBox(height: 5),
                                    Text("Hotel Name: Ocean Breeze", style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                                    SizedBox(height: 10),
                                    Text("Service was excellent, will come back again!"),
                                  ],
                                ),
                              ),
                            ),
                            // Additional hardcoded or fetched reviews go here
                          ],
                        ),
                      ),

                    ],
                  ),
                  
                  // Site Reviews Tab
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Inside the Column widget of the Site Reviews Tab
                      SizedBox(
                        height: 150, // Reduced height for the review input box
                        child: TextField(
                          controller: siteReviewController,
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            labelText: 'Write your site review here...',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Add logic to submit site review
                          print("Site Review: ${siteReviewController.text}");
                        },
                        child: Text('Submit Review'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(165, 111, 77, 1),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // Display for other 
                      Expanded(
                        child: ListView(
                          children: [
                            Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Username: UserA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    SizedBox(height: 10),
                                    Text("Really liked the user-friendly interface!"),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Username: UserB", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    SizedBox(height: 10),
                                    Text("Found the site very easy to navigate."),
                                  ],
                                ),
                              ),
                            ),
                            // Additional hardcoded or fetched reviews go here
                          ],
                        ),
                      ),

                    ],
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