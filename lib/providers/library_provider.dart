import 'package:biblioteca/models/genre.dart';
import 'package:biblioteca/services/library_service.dart';
import 'package:flutter/material.dart';

class LibraryProvider with ChangeNotifier {
  final LibraryService _service = LibraryService();

  List<Genre> genres = [];
  bool loading = false;
  String? error;

  Future<void> fetchLibrary() async {
    loading = true;
    notifyListeners();

    try {
      genres = await _service.fetchLibraryData();
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }
}
