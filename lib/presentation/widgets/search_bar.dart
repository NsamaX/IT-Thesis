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

  void _startSearch(bool value) {
    if (isSearch != value) {
      setState(() => isSearch = value);
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
      padding: const EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 12.0),
      child: Row(
        children: [
          _buildSearchBar(context),
          _buildClearButton(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        height: 32.0,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: TextField(
          controller: _searchController,
          onTap: () => _startSearch(true),
          onChanged: widget.onSearchChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            hintText: locale.translate('text.hint_text'),
            hintStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            contentPadding: const EdgeInsets.only(bottom: 12.0),
          ),
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildClearButton(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 300),
      width: isSearch ? 86.0 : 0.0,
      height: 42.0,
      child: isSearch
          ? TextButton(
              onPressed: () {
                _startSearch(false);
                _clearSearch();
              },
              child: Text(
                locale.translate('button.cancel'),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor),
              ),
            )
          : null,
    );
  }
}
