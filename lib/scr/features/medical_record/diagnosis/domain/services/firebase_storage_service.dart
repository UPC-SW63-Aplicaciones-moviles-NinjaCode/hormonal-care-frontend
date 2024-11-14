import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Map<String, String>>> getMedicalTests() async {
    List<Map<String, String>> tests = [];
    try {
      final ListResult result = await _storage.ref('medical_tests').listAll();
      for (var item in result.items) {
        final String url = await item.getDownloadURL();
        final String name = item.name;
        tests.add({'name': name, 'url': url});
      }
    } catch (e) {
      print('Error fetching medical tests: $e');
    }
    return tests;
  }
}