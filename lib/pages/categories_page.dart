// TODO 144: Import necessary packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO 145: Import providers, widgets, and utils
import '../providers/app_provider.dart';
import '../utils/helpers.dart';
import '../widgets/common/category_chip.dart';
import '../utils/constants.dart';

// TODO 146: Define categories page
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final Map<String, bool> _loadingStates = {};

  // TODO 147: Load category wallpapers
  void _loadCategoryWallpapers(String query) async {
    setState(() {
      _loadingStates[query] = true;
    });

    final provider = Provider.of<AppProvider>(context, listen: false);

    try {
      await provider.loadCategoryWallpapers(query);
      Navigator.pop(context);
    } catch (e) {
      AppHelpers.showError(context, 'Failed to load category: $e');
    } finally {
      setState(() {
        _loadingStates[query] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // TODO 148: Categories header
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Choose a Category',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // TODO 149: Categories grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: AppConstants.categories.length,
              itemBuilder: (context, index) {
                final category = AppConstants.categories[index];
                final isLoading = _loadingStates[category['query']] == true;

                return CategoryChip(
                  name: category['name'],
                  iconName: category['icon'],
                  colorName: category['color'],
                  isLoading: isLoading,
                  onTap: () => _loadCategoryWallpapers(category['query']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}