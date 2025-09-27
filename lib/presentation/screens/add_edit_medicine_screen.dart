import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/presentation/widgets/custom_buttons.dart';
import 'package:pharmaplus_flutter/presentation/widgets/custom_text_field.dart';

import 'package:pharmaplus_flutter/providers/medicine_provider.dart';
import 'package:provider/provider.dart';
import 'package:pharmaplus_flutter/data/models/medicine_model.dart';

class AddEditMedicineScreen extends StatefulWidget {
  final MedicineModel? medicine;

  const AddEditMedicineScreen({super.key, this.medicine});

  @override
  State<AddEditMedicineScreen> createState() => _AddEditMedicineScreenState();
}

class _AddEditMedicineScreenState extends State<AddEditMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _costPriceController;
  late TextEditingController _wholeSalePriceController;
  late TextEditingController _salePriceController;

  String formatNumber(double value) {
    if (value == value.roundToDouble()) {
      // If whole number, show without decimal
      return value.toInt().toString();
    } else {
      // Else show with decimal
      return value.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medicine?.name ?? '');
    _costPriceController = TextEditingController(
      text: widget.medicine != null
          ? formatNumber(widget.medicine!.costPrice)
          : '',
    );
    _wholeSalePriceController = TextEditingController(
      text: widget.medicine != null
          ? formatNumber(widget.medicine!.wholeSalePrice)
          : '',
    );
    _salePriceController = TextEditingController(
      text: widget.medicine != null
          ? formatNumber(widget.medicine!.salePrice)
          : '',
    );
  }

  num parseNumber(String value) {
    if (value.contains('.')) {
      // decimal number
      return double.parse(value);
    } else {
      // integer number
      return int.parse(value);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costPriceController.dispose();
    _wholeSalePriceController.dispose();
    _salePriceController.dispose();
    super.dispose();
  }

  // In _saveMedicine method, remove the ID generation:
  // In _saveMedicine method, remove the ID generation:
  void _saveMedicine() {
    if (_formKey.currentState!.validate()) {
      try {
        // Create medicine without ID - it will be auto-generated
        final medicine = MedicineModel(
          id: 0, // Temporary value, will be replaced by auto-increment
          name: _nameController.text,
          costPrice: parseNumber(_costPriceController.text).toDouble(),
          wholeSalePrice: parseNumber(
            _wholeSalePriceController.text,
          ).toDouble(),
          salePrice: parseNumber(_salePriceController.text).toDouble(),
        );

        final medicineProvider = context.read<MedicineProvider>();

        if (widget.medicine == null) {
          // Add new medicine (auto-increment will handle ID)
          medicineProvider.addMedicine(medicine);
        } else {
          // Editing existing medicine - keep the original ID
          medicineProvider.updateMedicine(
            medicine.copyWith(id: widget.medicine!.id),
          );
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please Enter valid numbers.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.medicine != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Medicine' : 'Add Medicine'),
        animateColor: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 60),
                CustomTextFormField(controller: _nameController, label: "Name"),
                CustomTextFormField(
                  controller: _costPriceController,
                  label: "Cost Price",
                  keyboardType: TextInputType.number,
                ),
                CustomTextFormField(
                  controller: _wholeSalePriceController,
                  label: "Wholesale Price",
                  keyboardType: TextInputType.number,
                ),
                CustomTextFormField(
                  controller: _salePriceController,
                  label: "Sale Price",
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 20),
                CustomButton(
                  onPressed: _saveMedicine,
                  text: isEditing ? 'Update' : 'Save',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
