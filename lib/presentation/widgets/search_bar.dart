import 'package:flutter/material.dart';
import 'package:nfc_project/core/locales/localizations.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;

  const SearchBarWidget({
    Key? key,
    required this.onSearchChanged,
    required this.onSearchCleared,
  }) : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearch = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch({required bool value}) {
    if (isSearch != value) {
      setState(() {
        isSearch = value;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onSearchCleared();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.appBarTheme.backgroundColor,
      padding: const EdgeInsets.fromLTRB(26, 0, 26, 12),
      child: Row(
        children: [
          _buildSearchBar(context: context),
          _buildClearButton(context: context),
        ],
      ),
    );
  }

  Widget _buildSearchBar({required BuildContext context}) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          onTap: () {
            if (!isSearch) _startSearch(value: true);
          },
          onChanged: widget.onSearchChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            hintText: locale.translate('text.hint_text'),
            hintStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            contentPadding: const EdgeInsets.only(bottom: 14),
          ),
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildClearButton({required BuildContext context}) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isSearch ? 86 : 0,
      height: 42,
      child: isSearch
          ? TextButton(
              onPressed: () {
                _startSearch(value: false);
                _clearSearch();
              },
              child: Text(
                locale.translate('button.cancel'),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
              ),
            )
          : null,
    );
  }
}
