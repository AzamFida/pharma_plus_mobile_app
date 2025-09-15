import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/providers/medicine_provider';
import 'package:provider/provider.dart';
import 'package:pharmaplus_flutter/presentation/screens/add_edit_medicine_screen.dart';
import 'package:pharmaplus_flutter/presentation/widgets/medicine_list_tile.dart';
import 'package:shimmer/shimmer.dart';

class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({super.key});

  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Simulate 2 seconds loading
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicineProvider>(context);
    final medicines = provider.medicines;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicines List'),
        backgroundColor: Colors.lightBlue,
      ),
      body: _isLoading
          ? _buildShimmerList()
          : medicines.isEmpty
          ? const Center(child: Text('No medicines added yet.'))
          : ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final medicine = medicines[index];
                return MedicineListTile(
                  medicine: medicine,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddEditMedicineScreen(medicine: medicine),
                      ),
                    );
                  },
                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Row(
                          children: const [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Text('Confirm Deletion'),
                          ],
                        ),
                        content: const Text(
                          'This action will permanently remove this medicine.\nAre you sure you want to proceed?',
                          style: TextStyle(fontSize: 16, height: 1.4),
                        ),
                        actionsPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        actions: [
                          ElevatedButton.icon(
                            onPressed: () => Navigator.of(context).pop(false),
                            icon: const Icon(Icons.cancel, size: 18),
                            label: const Text('Cancel'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade400,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => Navigator.of(context).pop(true),
                            icon: const Icon(Icons.delete, size: 18),
                            label: const Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      provider.removeMedicine(medicine.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Medicine deleted')),
                      );
                    }
                  },
                );
              },
            ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditMedicineScreen(),
            ),
          );
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.blue,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
