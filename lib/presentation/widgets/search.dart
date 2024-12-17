import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double searchBarHeight = 32;

    return Container(
      color: theme.appBarTheme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Search Bar
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: isSearch
                  ? MediaQuery.of(context).size.width - 118
                  : MediaQuery.of(context).size.width - 32,
              child: Container(
                height: searchBarHeight,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onTap: () {
                    setState(() {
                      isSearch = true;
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                    hintStyle: TextStyle(fontSize: 16),
                    contentPadding: EdgeInsets.only(bottom: 12),
                  ),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
            if (isSearch) ...[
              const SizedBox(width: 8),
              // Cancel Button
              TextButton(
                onPressed: () {
                  setState(() {
                    isSearch = false;
                  });
                },
                child: Text(
                  'Cancel',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.secondaryHeaderColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
