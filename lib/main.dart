import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WineShopScreen(),
    );
  }
}

class WineShopScreen extends StatefulWidget {
  @override
  _WineShopScreenState createState() => _WineShopScreenState();
}

class _WineShopScreenState extends State<WineShopScreen> {
  late Future<List<Map<String, dynamic>>> wineData;

  @override
  void initState() {
    super.initState();
    wineData = loadWineData();
  }

  Future<List<Map<String, dynamic>>> loadWineData() async {
    final String response = await rootBundle.loadString('assets/data/wines.json');
    final List<dynamic> data = json.decode(response);
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Donnerville Drive',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              '4 Donnerville Hall, Donnerville Drive, Adamaston...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications, color: Colors.black),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '123',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // Acțiune pentru notificări
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: wineData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Eroare la încărcarea datelor"));
          } else {
            final wines = snapshot.data!;
            return ListView.builder(
              itemCount: wines.length,
              itemBuilder: (context, index) {
                final wine = wines[index];
                return WineCard(
                  title: wine['title'],
                  imageAsset: wine['imageAsset'],
                  price: wine['price'],
                  criticsScore: wine['criticsScore'],
                  isAvailable: wine['isAvailable'],
                  isAdded: wine['isAdded'],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class WineCard extends StatelessWidget {
  final String title;
  final String imageAsset;
  final String price;
  final int criticsScore;
  final bool isAvailable;
  final bool isAdded;

  WineCard({
    required this.title,
    required this.imageAsset,
    required this.price,
    required this.criticsScore,
    this.isAvailable = true,
    this.isAdded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                  child: Image.asset(
                    imageAsset,
                    height: 150,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isAvailable ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isAvailable ? 'Available' : 'Unavailable',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Critics' Scores: $criticsScore / 100",
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 4),
                        Text(
                          price,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
