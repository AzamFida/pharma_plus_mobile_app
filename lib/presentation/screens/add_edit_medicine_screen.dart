import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/presentation/widgets/custom_buttons.dart';
import 'package:pharmaplus_flutter/presentation/widgets/custom_text_field.dart';
import 'package:pharmaplus_flutter/presentation/widgets/gradient_background.dart';
import 'package:pharmaplus_flutter/providers/medicine_provider.dart';
import 'package:pharmaplus_flutter/providers/theme_provider.dart';
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

  bool _isLoading = false;

  String formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    } else {
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
      return double.parse(value);
    } else {
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

  Future<void> _saveMedicine() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final medicine = MedicineModel(
          id: 0,
          name: _nameController.text,
          costPrice: parseNumber(_costPriceController.text).toDouble(),
          wholeSalePrice: parseNumber(
            _wholeSalePriceController.text,
          ).toDouble(),
          salePrice: parseNumber(_salePriceController.text).toDouble(),
        );

        final medicineProvider = context.read<MedicineProvider>();

        if (widget.medicine == null) {
          await medicineProvider.addMedicine(medicine);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Data Added Successfully",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
            ),
          );
        } else {
          await medicineProvider.updateMedicine(
            medicine.copyWith(id: widget.medicine!.id),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Data Updated Successfully",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
            ),
          );
        }

        if (mounted) Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter valid numbers.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.medicine != null;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: isDarkMode
              ? const Color.fromARGB(39, 94, 93, 93)
              : Colors.blue,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            isEditing ? 'Edit Medicine' : 'Add Medicine',
            style: const TextStyle(color: Colors.white),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  /// 👇 Fade + Slide animations for fields
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: CustomTextFormField(
                      controller: _nameController,
                      label: "Name",
                    ),
                  ),
                  const SizedBox(height: 15),

                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 150),
                    child: CustomTextFormField(
                      controller: _costPriceController,
                      label: "Cost Price",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 15),

                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 300),
                    child: CustomTextFormField(
                      controller: _wholeSalePriceController,
                      label: "Wholesale Price",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 15),

                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 450),
                    child: CustomTextFormField(
                      controller: _salePriceController,
                      label: "Sale Price",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// Button animation
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 600),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            onPressed: _saveMedicine,
                            text: isEditing ? 'Update' : 'Save',
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
