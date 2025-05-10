import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

import '../models/project_model.dart';
import '../utilities/download_media.dart';
import '../utilities/video_player_widget.dart';
import 'home_screen.dart';
import 'map_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  ProjectDetailScreen({required this.project});

  void _uploadMedia(BuildContext context, String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: type == 'image' ? FileType.image : FileType.video,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final bytes = file.bytes;
    final fileName = file.name;

    if (bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File data is empty.')),
      );
      return;
    }

    final storageRef = FirebaseStorage.instance.ref().child(fileName);

    try {
      final uploadTask = await storageRef.putData(bytes);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Upload successful!'),
        backgroundColor: Colors.green,
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ProjectDetailScreen(
            project: Project(
              name: project.name,
              description: project.description,
              imageUrls: type == 'image'
                  ? [...project.imageUrls, downloadUrl]
                  : project.imageUrls,
              videoUrls: type == 'video'
                  ? [...project.videoUrls, downloadUrl]
                  : project.videoUrls,
              latitude: project.latitude,
              longitude: project.longitude,
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Upload failed: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(project.name,style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80), // Adjust height for description + tabs
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text(
                    project.description.isNotEmpty
                        ? project.description
                        : 'No description provided.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                TabBar(
                  tabs: [
                    Tab(text: 'Images'),
                    Tab(text: 'Videos'),
                  ],
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                ),
              ],
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.add, color: Colors.white),
              color: Colors.grey[900],
              onSelected: (type) => _uploadMedia(context, type),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'image',
                  child: Text('Upload Image', style: TextStyle(color: Colors.white)),
                ),
                PopupMenuItem(
                  value: 'video',
                  child: Text('Upload Video', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.tealAccent,
          icon: Icon(Icons.map, color: Colors.black),
          label: Text("View on Map", style: TextStyle(color: Colors.black)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DashboardScreen(initialTabIndex: 1,)),
            );
          },
        ),
        body: TabBarView(
          children: [
            _buildImageSection(context),
            _buildVideoSection(context),
          ],
        ),

      ),

    );
  }
  Widget _buildImageSection(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: project.imageUrls.length,
      itemBuilder: (context, index) {
        final url = project.imageUrls[index];
        final filename = url.split('/').last.split('?').first;

        return Card(
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 12),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(url, fit: BoxFit.cover, width: double.infinity),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.black87,
                  child: IconButton(
                    icon: Icon(Icons.download, color: Colors.tealAccent),
                    onPressed: () => downloadFile(context, url, filename),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideoSection(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: project.videoUrls.length,
      itemBuilder: (context, index) {
        final url = project.videoUrls[index];
        final filename = url.split('/').last.split('?').first;

        return Card(
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 12),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: VideoPlayerWidget(videoUrl: url),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.black87,
                  child: IconButton(
                    icon: Icon(Icons.download, color: Colors.tealAccent),
                    onPressed: () => downloadFile(context, url, filename),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
