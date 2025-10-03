import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmaplus_flutter/data/models/medicine_model.dart';

class MedicineListTile extends StatelessWidget {
  final MedicineModel medicine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MedicineListTile({
    super.key,
    required this.medicine,
    required this.onEdit,
    required this.onDelete,
  });

  String formatPrice(double price) {
    // Check if price has no decimal
    if (price == price.roundToDouble()) {
      final formatCurrency = NumberFormat.currency(
        locale: 'en_PK',
        symbol: '₨.',
        decimalDigits: 0,
      );
      return formatCurrency.format(price);
    } else {
      final formatCurrency = NumberFormat.currency(
        locale: 'en_PK',
        symbol: '₨.',
        decimalDigits: 2,
      );
      return formatCurrency.format(price);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      color: const Color.fromARGB(208, 109, 109, 110),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (medicine name)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(121, 168, 168, 169),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                medicine.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),

            // 🔑 Secret Code
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Secret Code:', style: _labelStyle),
                Text(medicine.secretCode, style: _valueStyle), // ✅ NEW
              ],
            ),
            const SizedBox(height: 4),

            // Prices
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Cost Price:', style: _labelStyle),
                Text(formatPrice(medicine.costPrice), style: _valueStyle),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Wholesale Price:', style: _labelStyle),
                Text(formatPrice(medicine.wholeSalePrice), style: _valueStyle),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sale Price:', style: _labelStyle),
                Text(formatPrice(medicine.salePrice), style: _valueStyle),
              ],
            ),

            const SizedBox(height: 12),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Edit Button
                ElevatedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(135, 163, 81, 235),
                    fixedSize: const Size(110, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 10),

                // Delete Button
                ElevatedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(110, 40),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle get _labelStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  TextStyle get _valueStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
