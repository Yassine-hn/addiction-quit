// NumberInputField.dart
import 'package:flutter/material.dart';

class NumberInputField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool autoFocus;
  final EdgeInsetsGeometry? padding;

  const NumberInputField({
    super.key,
    required this.label,
    this.hintText,
    required this.controller,
    this.onChanged,
    this.autoFocus = false,
    this.padding,
  });

  @override
  State<NumberInputField> createState() => _NumberInputFieldState();
}

class _NumberInputFieldState extends State<NumberInputField> {
  bool _isValid = false;

  void _validateInput(String value) {
    final number = int.tryParse(value);
    setState(() {
      _isValid = number != null && number > 0;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty) {
      _validateInput(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isValid
                    ? Colors.green
                    : widget.controller.text.isNotEmpty
                    ? Colors.orange
                    : const Color(0xFFDDDDDD),
                width: 2,
              ),
            ),
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              autofocus: widget.autoFocus,
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Enter a number',
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                suffixIcon: widget.controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          widget.controller.clear();
                          _validateInput('');
                          if (widget.onChanged != null) {
                            widget.onChanged!('');
                          }
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.grey,
                          size: 20,
                        ),
                      )
                    : null,
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              onChanged: (value) {
                _validateInput(value);
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (widget.controller.text.isNotEmpty)
                Icon(
                  _isValid ? Icons.check_circle : Icons.error_outline,
                  size: 16,
                  color: _isValid ? Colors.green : Colors.orange,
                ),
              const SizedBox(width: 6),
              Text(
                widget.controller.text.isEmpty
                    ? ''
                    : _isValid
                    ? ''
                    : 'Please enter a valid number',
                style: TextStyle(
                  fontSize: 13,
                  color: widget.controller.text.isEmpty
                      ? Colors.grey
                      : _isValid
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
