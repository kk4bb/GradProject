class ForumsData {
  final String title;
  final String description;
  final String image;
  final int? courseId;

  ForumsData({
    required this.title,
    required this.description,
    required this.image,
    this.courseId,
  });
}
