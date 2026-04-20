// TODO 104: Import necessary packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO 105: Import providers and utils
import '../../providers/app_provider.dart';
import '../../utils/helpers.dart';

// TODO 106: Define search dialog widget
class SearchDialog extends StatefulWidget {
  const SearchDialog({super.key});

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // TODO 107: Perform search operation
  void _performSearch() async {
    if (_searchController.text.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    final provider = Provider.of<AppProvider>(context, listen: false);

    try {
      await provider.searchWallpapers(_searchController.text.trim());
      Navigator.pop(context);
      AppHelpers.showInfo(context, 'Search results for "${_searchController.text}"');
    } catch (e) {
      AppHelpers.showError(context, 'Search failed: $e');
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Search Wallpapers',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: TextField(
        controller: _searchController,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Enter search term...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          filled: true,
          fillColor: Colors.grey[850],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          suffixIcon: _isSearching
              ? const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
                  ),
                )
              : null,
        ),
        onSubmitted: (value) => _performSearch(),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: _isSearching ? null : _performSearch,
          child: _isSearching
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Search'),
        ),
      ],
    );
  }
}