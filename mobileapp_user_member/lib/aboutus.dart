import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             
              
                
                Image.asset(
                  "./assets/image/logo.png", // Replace with your logo
                  height: 100,
                ),
            
              SizedBox(height: 10),
              Text(
                "Nedumbassery Grama Panchayath, located in Ernakulam district, Kerala, is a rapidly developing region known for housing Cochin International Airport. With a strong focus on infrastructure, education, and environmental sustainability, the Panchayath plays a crucial role in enhancing the quality of life for its residents while promoting economic and social development.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),


              // Contact Us
              Text(
                "Contact Us",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, color: Colors.blueAccent),
                  SizedBox(width: 8),
                  Text("Nedumbasserygp@gmail.com"),


                ],
              ),

              SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, color: Colors.blueAccent),
                  SizedBox(width: 8),
                  Text("0484 2477531"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
