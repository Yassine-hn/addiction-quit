import 'package:flutter/material.dart';
import 'SearchBarWidget.dart';
import 'SearchItemTile.dart';
import 'SearchListContainer.dart';
import 'ValidationButton.dart';

class SearchListWidget extends StatefulWidget {
  final List<String> items;
  final Function(String) onSelected;
  final String? initialSelection;

  const SearchListWidget({
    super.key,
    required this.items,
    required this.onSelected,
    this.initialSelection,
  });

  @override
  State<SearchListWidget> createState() => _SearchListWidgetState();
}

class _SearchListWidgetState extends State<SearchListWidget> {
  final searchController = TextEditingController();
  String? selectedItem;
  List<String> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = widget.items;

    // Initialize with the current selection if provided
    if (widget.initialSelection != null &&
        widget.items.contains(widget.initialSelection)) {
      selectedItem = widget.initialSelection;
    }
  }

  void filterList(String value) {
    setState(() {
      if (value.isEmpty) {
        filteredList = widget.items;
      } else {
        filteredList = widget.items
            .where((e) => e.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBarWidget(controller: searchController, onChanged: filterList),

        const SizedBox(height: 16),

        if (filteredList.isEmpty)
          const SearchListContainer(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No items found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          )
        else
          SearchListContainer(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredList.length,
                itemBuilder: (_, i) {
                  final item = filteredList[i];
                  return SearchItemTile(
                    text: item,
                    selected: item == selectedItem,
                    hasBorder: i != 0,
                    onTap: () {
                      setState(() => selectedItem = item);
                    },
                  );
                },
              ),
            ),
          ),

        const SizedBox(height: 24),

        ValidationButton(
          label: "Validate Selection",
          onPressed: () {
            if (selectedItem != null) {
              widget.onSelected(selectedItem!);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select an item first'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
