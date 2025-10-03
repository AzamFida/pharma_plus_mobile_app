import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/presentation/widgets/animation_widget.dart';
import 'package:pharmaplus_flutter/presentation/widgets/gradient_background.dart';
import 'package:pharmaplus_flutter/presentation/widgets/logout_dialog.dart';
import 'package:pharmaplus_flutter/providers/medicine_provider.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadMedicines();

    // 🔍 Debounced search listener
    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        setState(() {
          _searchQuery = _searchController.text.toLowerCase();
        });
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMedicines() async {
    final provider = Provider.of<MedicineProvider>(context, listen: false);
    await provider.fetchMedicines();

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicineProvider>(context);
    final medicines = provider.medicines;

    // 🔍 Filter medicines by search query
    final filteredMedicines = medicines.where((medicine) {
      final query = _searchQuery.trim();
      if (query.isEmpty) return true;

      final name = medicine.name.toLowerCase();
      final id = medicine.id.toString();
      final salePrice = medicine.salePrice.toString();

      return name.contains(query) ||
          id.contains(query) ||
          salePrice.contains(query);
    }).toList();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Medicines List',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                showLogoutDialog(context);
              },
            ),
          ],
        ),

        body: _isLoading
            ? _buildShimmerList()
            : CustomScrollView(
                slivers: [
                  // 🔍 Search bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search medicines...",
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(74, 242, 237, 245),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 📝 Medicines list or empty state
                  if (filteredMedicines.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No medicines found.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final medicine = filteredMedicines[index];
                        return MedicineListTile(
                          medicine: medicine,
                          onEdit: () {
                            Navigator.push(
                              context,
                              createFadeScaleRoute(
                                AddEditMedicineScreen(medicine: medicine),
                              ),
                            ).then((_) {
                              setState(() {
                                _isLoading = true; // Show shimmer again
                              });
                              _loadMedicines();
                            });
                          },

                          onDelete: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => _deleteDialog(context),
                            );
                            if (confirm == true) {
                              provider.removeMedicine(medicine.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Medicine deleted'),
                                ),
                              );
                            }
                          },
                        );
                      }, childCount: filteredMedicines.length),
                    ),
                ],
              ),
        floatingActionButton: _buildFab(context),
      ),
    );
  }

  /// 🛑 Delete confirmation dialog
  Widget _deleteDialog(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return AlertDialog(
      backgroundColor: const Color.fromARGB(243, 195, 169, 251),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: const [
          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
          SizedBox(width: 8),
          Text('Confirm Deletion'),
        ],
      ),
      content: const Text(
        'This action will permanently remove this medicine.\nAre you sure you want to proceed?',
        style: TextStyle(fontSize: 16, height: 1.4),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actions: [
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(false),
          icon: const Icon(Icons.cancel, size: 18),
          label: const Text('Cancel'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 223, 167, 248),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(width: width * 0.1),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.delete, size: 18),
          label: const Text('Delete'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  /// ➕ Floating Action Button
  Widget _buildFab(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          createFadeScaleRoute(const AddEditMedicineScreen()),
        ).then((_) {
          setState(() {
            _isLoading = true; // Show shimmer again
          });
          _loadMedicines();
        });
      },

      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(215, 185, 109, 240),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  /// ✨ Shimmer loading list
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color.fromARGB(238, 181, 134, 248),
          highlightColor: const Color.fromARGB(121, 195, 164, 248),
          child: Card(
            borderOnForeground: true,
            color: const Color.fromARGB(122, 211, 196, 237),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(122, 211, 196, 237),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildShimmerRow(),
                  const SizedBox(height: 4),
                  _buildShimmerRow(),
                  const SizedBox(height: 4),
                  _buildShimmerRow(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 40,
                        width: 110,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(242, 192, 134, 243),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 110,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(height: 16, width: 100, color: Colors.white.withOpacity(0.5)),
        Container(height: 16, width: 80, color: Colors.white.withOpacity(0.5)),
      ],
    );
  }
}
