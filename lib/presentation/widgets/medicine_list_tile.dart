import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmaplus_flutter/data/models/medicine_model.dart';
import 'package:provider/provider.dart';
import 'package:pharmaplus_flutter/providers/theme_provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Card(
      color: isDark
          ? const Color.fromARGB(33, 77, 77, 77)
          : const Color.fromARGB(
              255,
              255,
              255,
              255,
            ), // Background depends on theme
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 12,
      shadowColor: isDark ? Colors.black54 : Colors.grey.withOpacity(0.3),
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
                color: isDark
                    ? const Color.fromARGB(66, 179, 179, 179)
                    : const Color.fromARGB(255, 241, 240, 240),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                medicine.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.white
                      : const Color.fromARGB(255, 36, 35, 35),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),

            // Secret Code
            _buildRow('Secret Code:', medicine.secretCode, isDark),
            const SizedBox(height: 4),

            // Prices
            _buildRow('Cost Price:', formatPrice(medicine.costPrice), isDark),
            const SizedBox(height: 4),
            _buildRow(
              'Wholesale Price:',
              formatPrice(medicine.wholeSalePrice),
              isDark,
            ),
            const SizedBox(height: 4),
            _buildRow('Sale Price:', formatPrice(medicine.salePrice), isDark),

            const SizedBox(height: 12),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Edit Button
                ElevatedButton.icon(
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit,
                    size: 18,
                    color: isDark ? Colors.white : Colors.white,
                  ),
                  label: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    fixedSize: const Size(110, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 10),

                // Delete Button
                ElevatedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 18, color: Colors.white),
                  label: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    fixedSize: const Size(110, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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

  Widget _buildRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.grey[300] : Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}
