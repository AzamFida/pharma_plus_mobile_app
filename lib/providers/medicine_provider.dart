import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/data/models/medicine_model.dart';

class MedicineProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<MedicineModel> _medicines = [];
  bool _isLoading = false;
  int _lastMedicineId = 0; // Cache the last ID

  List<MedicineModel> get medicines => _medicines;
  bool get isLoading => _isLoading;

  String? get _currentUserId => _auth.currentUser?.uid;

  // Initialize or get the next medicine ID
  Future<int> _getNextMedicineId() async {
    if (_currentUserId == null) throw Exception('User not logged in');

    final counterRef = _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('metadata')
        .doc('medicine_counter');

    return await _firestore.runTransaction<int>((transaction) async {
      final snapshot = await transaction.get(counterRef);

      int nextId;
      if (snapshot.exists) {
        final lastId = snapshot.data()?['lastId'] ?? 0;
        nextId = lastId + 1;
      } else {
        nextId = 1; // start from 1 for first medicine
      }

      transaction.set(counterRef, {'lastId': nextId});
      _lastMedicineId = nextId; // cache locally
      return nextId;
    });
  }

  // Fetch medicines and initialize the counter
  Future<void> fetchMedicines() async {
    if (_currentUserId == null) {
      _medicines = [];
      _isLoading = false;
      return;
    }

    if (_isLoading) return;

    _isLoading = true;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_currentUserId)
          .collection('medicines')
          .orderBy('id') // Order by ID for sequential display
          .get();

      _medicines = snapshot.docs
          .map((doc) => MedicineModel.fromMap(doc.data()))
          .toList();

      // Initialize the last ID from existing medicines
      if (_medicines.isNotEmpty) {
        _lastMedicineId = _medicines
            .map((m) => m.id)
            .reduce((a, b) => a > b ? a : b);
      }
    } catch (e) {
      print('Error fetching medicines: $e');
      _medicines = [];
    } finally {
      _isLoading = false;
      Future.delayed(Duration.zero, () {
        notifyListeners();
      });
    }
  }

  // Add medicine with auto-increment ID
  Future<void> addMedicine(MedicineModel medicine) async {
    if (_currentUserId == null) return;

    try {
      final newId = await _getNextMedicineId();
      final medicineWithId = medicine.copyWith(id: newId);

      await _firestore
          .collection('users')
          .doc(_currentUserId)
          .collection('medicines')
          .doc(newId.toString()) // Use ID as document ID
          .set(medicineWithId.toMap());

      _medicines.add(medicineWithId);
      // Sort by ID to maintain order
      _medicines.sort((a, b) => a.id.compareTo(b.id));
      notifyListeners();
    } catch (e) {
      print('Error adding medicine: $e');
      rethrow;
    }
  }

  // Update medicine
  Future<void> updateMedicine(MedicineModel medicine) async {
    if (_currentUserId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_currentUserId)
          .collection('medicines')
          .doc(medicine.id.toString())
          .update(medicine.toMap());

      final index = _medicines.indexWhere((m) => m.id == medicine.id);
      if (index != -1) {
        _medicines[index] = medicine;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating medicine: $e');
      rethrow;
    }
  }

  // Delete medicine (NOTE: We don't reuse deleted IDs to keep it simple)
  Future<void> removeMedicine(int medicineId) async {
    if (_currentUserId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_currentUserId)
          .collection('medicines')
          .doc(medicineId.toString())
          .delete();

      _medicines.removeWhere((medicine) => medicine.id == medicineId);
      notifyListeners();
    } catch (e) {
      print('Error deleting medicine: $e');
      rethrow;
    }
  }

  // Clear medicines when user logs out
  void clearMedicines() {
    _medicines.clear();
    _lastMedicineId = 0;
    _isLoading = false;
    notifyListeners();
  }
}
