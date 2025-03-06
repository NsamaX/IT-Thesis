import 'package:flutter/material.dart';

import 'package:nfc_project/core/locales/localizations.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;
  
  SearchBarWidget({
    Key? key,
    required this.onSearchChanged,
    required this.onSearchCleared,
  }) : super(key: key);

  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<bool> isSearch = ValueNotifier(false);

  void _toggleSearch(bool startSearch) {
    isSearch.value = startSearch;
    if (!startSearch) {
      _searchController.clear();
      onSearchCleared();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      color: theme.appBarTheme.backgroundColor,
      padding: const EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _SearchInputField(
              controller: _searchController,
              onTap: () => _toggleSearch(true),
              onChanged: onSearchChanged,
              hintText: locale.translate('text.hint_text'),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isSearch,
            builder: (context, value, child) => _ClearButton(
              isVisible: value,
              onPressed: () => _toggleSearch(false),
              label: locale.translate('button.cancel'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  final ValueChanged<String> onChanged;
  final String hintText;

  const _SearchInputField({
    Key? key,
    required this.controller,
    required this.onTap,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 32.0,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        controller: controller,
        onTap: onTap,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: hintText,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          contentPadding: const EdgeInsets.only(bottom: 12.0),
        ),
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black),
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onPressed;
  final String label;

  const _ClearButton({
    Key? key,
    required this.isVisible,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 300),
      width: isVisible ? 86.0 : 0.0,
      height: 42.0,
      child: isVisible
          ? TextButton(
              onPressed: onPressed,
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor),
              ),
            )
          : null,
    );
  }
}
