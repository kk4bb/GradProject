✦ Integration Guide: Managing Educational Content (Flutter)

  This guide outlines how to integrate the updated educational content features into the Flutter application, specifically handling the OriginalFileName and implementing the new deletion endpoint.

  ---

  1. Handling Updated API Responses

  The API now returns an OriginalFileName property in the EducationalContentDto object for courses. Update your model classes to include this field.

  Flutter Model Update

    1 class EducationalContent {
    2   final int id;
    3   final String contentType;
    4   final String fileUrl;
    5   final String? originalFileName; // New field
    6
    7   EducationalContent({
    8     required this.id,
    9     required this.contentType,
   10     required this.fileUrl,
   11     this.originalFileName,
   12   });
   13
   14   factory EducationalContent.fromJson(Map<String, dynamic> json) {
   15     return EducationalContent(
   16       id: json['id'],
   17       contentType: json['contentType'],
   18       fileUrl: json['fileUrl'],
   19       originalFileName: json['originalFileName'], // Parse the new field
   20     );
   21   }
   22 }

  UI Recommendation: Display originalFileName if available. If null (e.g., for legacy data), fall back to displaying the file extension extracted from the fileUrl or a generic "Download" label.

  ---

  2. Integrating the Deletion Endpoint

  We have introduced a new DELETE endpoint to allow instructors and TAs to remove content.

  API Endpoint Details
   * Method: DELETE
   * Path: /api/Course/content/{id}
   * Authentication: Requires a bearer token (role: Instructor or TA).

  Implementation Example (using http package)

    1 import 'package:http/http.dart' as http;
    2
    3 Future<void> deleteEducationalContent(int contentId, String token) async {
    4   final url = Uri.parse('YOUR_API_BASE_URL/api/Course/content/$contentId');
    5
    6   final response = await http.delete(
            url,
    8     headers: {
    9       'Content-Type': 'application/json',
   10       'Authorization': 'Bearer $token',
   11     },
   12   );
   13
   14   if (response.statusCode == 200) {
   15     print('Content deleted successfully');
   16   } else if (response.statusCode == 403) {
   17     throw Exception('Unauthorized to delete content.');
   18   } else {
   19     throw Exception('Failed to delete content: ${response.statusCode}');
   20   }
   21 }
