import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/project_model.dart';
import 'project_details_screen.dart';

class MapScreen extends StatelessWidget {
  final List<Project> sampleProjects = [
    Project(
      name: 'Space Rover',
      description: "",
      imageUrls: [
        'https://firebasestorage.googleapis.com/v0/b/flutter-firebase-login-storage.firebasestorage.app/o/%232580A5.png?alt=media&token=a8da83f6-683d-4aa1-9c1f-b79bbc1d8366',
        'https://firebasestorage.googleapis.com/v0/b/flutter-firebase-login-storage.firebasestorage.app/o/batman-sign-black-background-dc-superheroes-amoled-5k-8k-10k-3840x2160-4409.jpg?alt=media&token=47a54a7b-9183-41c8-9123-b4ed6eb289a7'
      ],
      videoUrls: [
        'https://firebasestorage.googleapis.com/v0/b/flutter-firebase-login-storage.firebasestorage.app/o/SampleVideo_1280x720_2mb.mp4?alt=media&token=c73181a5-228c-49c6-8853-06527064a2b7'
      ],
      latitude: 12.9716,
      longitude: 77.5946,
    ),
    Project(
      name: 'AI Chatbot',
      description: "",
      imageUrls: [
        'https://firebasestorage.googleapis.com/v0/b/flutter-firebase-login-storage.firebasestorage.app/o/batman-sign-black-background-dc-superheroes-amoled-5k-8k-10k-3840x2160-4409.jpg?alt=media&token=47a54a7b-9183-41c8-9123-b4ed6eb289a7'
      ],
      videoUrls: [
        'https://firebasestorage.googleapis.com/v0/b/flutter-firebase-login-storage.firebasestorage.app/o/SampleVideo_1280x720_2mb.mp4?alt=media&token=c73181a5-228c-49c6-8853-06527064a2b7'
      ],
      latitude: 28.6139,
      longitude: 77.2090,
    ),
    Project(
      name: 'Eco Drone',
      description: "",
      imageUrls: [
        'https://firebasestorage.googleapis.com/v0/b/flutter-firebase-login-storage.firebasestorage.app/o/%232580A5.png?alt=media&token=a8da83f6-683d-4aa1-9c1f-b79bbc1d8366'
      ],
      videoUrls: [
        'https://firebasestorage.googleapis.com/v0/b/flutter-firebase-login-storage.firebasestorage.app/o/SampleVideo_1280x720_2mb.mp4?alt=media&token=c73181a5-228c-49c6-8853-06527064a2b7'
      ],
      latitude: 19.0760,
      longitude: 72.8777,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(20, 77),
            initialZoom: 5.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: sampleProjects.map((project) {
                return Marker(
                  point: LatLng(project.latitude, project.longitude),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectDetailScreen(project: project),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        // Floating UI Panel
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black87.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📍 ${sampleProjects.length} Projects found',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Tap on any red marker to view details',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
