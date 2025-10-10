import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/presentation/widgets/animation_widget.dart';
import 'package:pharmaplus_flutter/presentation/widgets/gradient_background.dart';
import 'package:pharmaplus_flutter/presentation/widgets/logout_dialog.dart';
import 'package:pharmaplus_flutter/providers/medicine_provider.dart';
import 'package:pharmaplus_flutter/providers/theme_provider.dart';
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
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = "";
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.unfocus();
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
    _searchFocusNode.unfocus();
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
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
    final theme = Provider.of<ThemeProvider>(context).isDarkMode;

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

    return WillPopScope(
      onWillPop: () async {
        // 🧠 If the search bar is focused → unfocus instead of closing app
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
          return false;
        }
        return true;
      },
      child: AnimatedTheme(
        data: theme ? ThemeData.dark() : ThemeData.light(),
        duration: const Duration(milliseconds: 300),
        child: GradientBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: theme
                  ? const Color.fromARGB(39, 68, 68, 68)
                  : Colors.blue,

              title: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Provider.of<ThemeProvider>(context).isDarkMode
                      ? const Color.fromARGB(74, 242, 237, 245)
                      : const Color.fromARGB(
                          80,
                          205,
                          203,
                          203,
                        ), // light mode background
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  autofocus: false,
                  focusNode: _searchFocusNode,
                  controller: _searchController,
                  textCapitalization: TextCapitalization.characters,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: "Search medicines...",
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.cancel, color: Colors.white),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (value) {
                    (_searchController).notifyListeners();
                  },
                ),
              ),
              actions: [
                FadeInUp(
                  duration: const Duration(milliseconds: 1500),
                  delay: Duration(milliseconds: 1300),
                  child: IconButton(
                    icon: Icon(
                      Provider.of<ThemeProvider>(context).isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      final themeProvider = Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      );
                      themeProvider.toggleTheme(!themeProvider.isDarkMode);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.white),
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
                      if (filteredMedicines.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              'No medicines found.',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color:
                                    Provider.of<ThemeProvider>(
                                      context,
                                    ).isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        )
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final medicine = filteredMedicines[index];

                            // All items slide in from left, one after another
                            return FadeInDown(
                              duration: const Duration(milliseconds: 1000),
                              delay: Duration(
                                milliseconds: index * 80,
                              ), // 👈 small stagger delay
                              child: MedicineListTile(
                                medicine: medicine,
                                onEdit: () {
                                  Navigator.push(
                                    context,
                                    createFadeScaleRoute(
                                      AddEditMedicineScreen(medicine: medicine),
                                    ),
                                  ).then((_) {
                                    setState(() => _isLoading = true);
                                    _loadMedicines();
                                  });
                                },
                                onDelete: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) =>
                                        _deleteDialog(context),
                                  );
                                  if (confirm == true) {
                                    provider.removeMedicine(medicine.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.redAccent,
                                        content: Text(
                                          'Medicine deleted',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          }, childCount: filteredMedicines.length),
                        ),
                    ],
                  ),
            floatingActionButton: _buildFab(context),
          ),
        ),
      ),
    );
  }

  Widget _deleteDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final isSmall = width < 380;

    return BounceInDown(
      duration: const Duration(milliseconds: 500),
      delay: Duration(milliseconds: 300),
      child: AlertDialog(
        backgroundColor: isDark
            ? const Color.fromARGB(255, 71, 71, 71)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent.shade200,
              size: width * 0.07,
            ),
            SizedBox(width: width * 0.025),
            Expanded(
              child: Text(
                'Confirm Deletion',
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),

        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: width * 0.8,
            maxHeight: height * 0.25,
          ),
          child: Text(
            'This action will permanently remove this medicine.\nAre you sure you want to proceed?',
            style: TextStyle(
              fontSize: width * 0.04,
              height: 1.4,
              color: isDark ? Colors.grey[200] : Colors.black87,
            ),
          ),
        ),

        actions: [
          if (isSmall)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _cancelButton(context, isDark),
                const SizedBox(height: 10),
                _deleteButton(context),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _cancelButton(context, isDark)),
                const SizedBox(width: 16),
                Expanded(child: _deleteButton(context)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _cancelButton(BuildContext context, bool isDark) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.of(context).pop(false),
      icon: const Icon(Icons.cancel, size: 18),
      label: const Text('Cancel'),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark
            ? const Color(0xFF555555)
            : Colors.grey.shade300,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.of(context).pop(true),
      icon: const Icon(Icons.delete, size: 18),
      label: const Text('Delete'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
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
          color: Colors.blue,
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
          loop: 2,

          baseColor: Provider.of<ThemeProvider>(context).isDarkMode
              ? const Color.fromARGB(237, 78, 78, 79)
              : const Color.fromARGB(121, 175, 175, 176),

          highlightColor: Provider.of<ThemeProvider>(context).isDarkMode
              ? const Color.fromARGB(121, 175, 175, 176)
              : const Color.fromARGB(236, 229, 229, 229),

          child: Card(
            color: Provider.of<ThemeProvider>(context).isDarkMode
                ? const Color.fromARGB(122, 211, 196, 237)
                : const Color.fromARGB(121, 231, 231, 231),
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
                          color: Colors.blue,
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
        Container(height: 16, width: 100, color: Colors.white),
        Container(height: 16, width: 80, color: Colors.white),
      ],
    );
  }
}
