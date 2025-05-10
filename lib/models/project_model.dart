class Project {
  final String name;
  final String description;
  final List<String> imageUrls;
  final List<String> videoUrls;
  final double latitude;  // Latitude of the project
  final double longitude; // Longitude of the project

  Project({
    required this.name,
    required this.description,
    required this.imageUrls,
    required this.videoUrls,
    required this.latitude,
    required this.longitude,
  });
}
