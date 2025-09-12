import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/data/models/medicine_model.dart';
import 'package:pharmaplus_flutter/presentation/widgets/medicine_list_tile.dart'; // Update path as needed

class MedicineListScreen extends StatelessWidget {
  MedicineListScreen({super.key});

  // Dummy data list
  final List<MedicineModel> dummyMedicines = [
    MedicineModel(
      id: 1,
      name: 'Paracetamol',
      costPrice: 2.50,
      wholeSalePrice: 3.00,
      salePrice: 3.50,
    ),
    MedicineModel(
      id: 2,
      name: 'Ibuprofen',
      costPrice: 3.00,
      wholeSalePrice: 3.80,
      salePrice: 4.50,
    ),
    MedicineModel(
      id: 3,
      name: 'Cough Syrup',
      costPrice: 4.00,
      wholeSalePrice: 4.50,
      salePrice: 5.00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medicines List')),
      body: ListView.builder(
        itemCount: dummyMedicines.length,
        itemBuilder: (context, index) {
          final medicine = dummyMedicines[index];
          return MedicineListTile(
            medicine: medicine,
            onEdit: () {
              // You can navigate to your edit screen here
              debugPrint('Edit: ${medicine.name}');
            },
            onDelete: () {
              // For now just print delete
              debugPrint('Delete: ${medicine.name}');
            },
          );
        },
      ),
    );
  }
}
