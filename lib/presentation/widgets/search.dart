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
  bool isSearch = false;
  bool showCancel = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      color: theme.appBarTheme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(26, 0, 26, 12),
        child: Row(
          children: [
            // Static Search Container (Left Side)
            Expanded(
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onTap: () {
                    setState(() {
                      isSearch = true;
                      Future.delayed(const Duration(milliseconds: 300), () {
                        setState(() {
                          showCancel = true;
                        });
                      });
                    });
                  },
                  onChanged: widget.onSearchChanged,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: locale.translate('search.hint_text'),
                    hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                    contentPadding: const EdgeInsets.only(bottom: 10),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black),
                ),
              ),
            ),
            // Animated Container (Right Side)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: isSearch ? 86 : 0, // Shrink to show the Cancel button
              child: showCancel
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          isSearch = false;
                          showCancel = false;
                          _searchController.clear();
                        });
                        widget.onSearchCleared();
                      },
                      child: Text(
                        locale.translate('search.button'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.secondaryHeaderColor,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
