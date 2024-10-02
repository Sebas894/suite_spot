import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suite Spot'),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Stay', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () {}, child: const Text('Explore', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () {}, child: const Text('Packages', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () {}, child: const Text('About Us', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () {}, child: const Text('Contact Us', style: TextStyle(color: Colors.white))),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://example.com/your-background-image.jpg'), // Replace with your image URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent Overlay
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                // Hero Section
                const Text(
                  "Discover Your Perfect Stay",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Experience world-class hospitality and create unforgettable\n'
                    'memories with our premium, handpicked stays around the globe',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),
                // Search Widget
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Location Input
                        const Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.blue),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Destination',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        // Number of Guests
                        const Row(
                          children: [
                            Icon(Icons.people, color: Colors.blue),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Guests',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        // Arrival & Departure Dates
                        Row(
                          children: [
                            const Icon(Icons.date_range, color: Colors.blue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Check In & Out',
                                  border: InputBorder.none,
                                ),
                                readOnly: true,
                                onTap: () {
                                  // Handle date selection logic here
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Search Button
                        ElevatedButton(
                          onPressed: () {
                            // Handle search logic here
                          },
                          child: const Text('Search Hotels'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
