import 'package:flutter/material.dart';
import 'package:yelloskye_test/views/project_details_screen.dart';
import '../models/project_model.dart';

class ProjectScreen extends StatefulWidget {
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final List<Project> _projects = [
    Project(
      name: 'Space Rover',
      description: "A prototype for Mars exploration with autonomous AI.",
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
      description: "A conversational assistant with real-time language understanding.",
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
      description: "A sustainable drone for environmental monitoring.",
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

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _projects
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Search Projects',
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(16)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(16)

                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final project = filtered[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProjectDetailScreen(project: project),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              project.description.isNotEmpty
                                  ? project.description
                                  : "No description provided.",
                              style: TextStyle(color: Colors.white70),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                _buildTag(Icons.image, project.imageUrls.length, "Photos"),
                                SizedBox(width: 8),
                                _buildTag(Icons.videocam, project.videoUrls.length, "Videos"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(IconData icon, int count, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueGrey[700],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white),
          SizedBox(width: 4),
          Text(
            '$count $label',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
