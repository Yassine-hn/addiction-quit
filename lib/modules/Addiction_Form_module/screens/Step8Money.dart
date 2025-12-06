// Step8Money.dart - Fixed with single scrollable layout
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/Cubit/UserInfoCubit.dart';
import 'Step9ReviewHour.dart';
import '../widgets/ValidationButton.dart';

class Step8Money extends StatefulWidget {
  const Step8Money({super.key});

  @override
  State<Step8Money> createState() => _Step8MoneyState();
}

class _Step8MoneyState extends State<Step8Money> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();

  String _selectedCurrency = 'DA';
  bool _isAmountValid = false;

  final List<Map<String, dynamic>> _currencies = [
    {'symbol': 'DA', 'name': 'Algerian Dinar', 'default': true},
    {'symbol': '\$', 'name': 'US Dollar'},
    {'symbol': '€', 'name': 'Euro'},
    {'symbol': '£', 'name': 'British Pound'},
    {'symbol': '₹', 'name': 'Indian Rupee'},
    {'symbol': '¥', 'name': 'Japanese Yen'},
    {'symbol': '₽', 'name': 'Russian Ruble'},
    {'symbol': 'other', 'name': 'Other'},
  ];

  @override
  void initState() {
    super.initState();

    // Load existing data from cubit
    final cubit = BlocProvider.of<UserInfoCubit>(context, listen: false);
    final savedData = cubit.state.moneySavedPerDay;

    if (savedData != null && savedData.isNotEmpty) {
      if (savedData.containsKey('amount')) {
        final amount = savedData['amount'];
        if (amount is num) {
          _amountController.text = _formatAmount(amount.toDouble());
          _validateAmount(_amountController.text);
        }
      }

      if (savedData.containsKey('currency')) {
        final currency = savedData['currency'] as String;
        final found = _currencies.firstWhere(
          (c) => c['symbol'] == currency,
          orElse: () => {'symbol': 'other', 'name': 'Other'},
        );
        _selectedCurrency = found['symbol'];
      }
    }

    _amountFocusNode.addListener(() {
      if (!_amountFocusNode.hasFocus && _amountController.text.isNotEmpty) {
        _validateAmount(_amountController.text);
      }
    });
  }

  String _formatAmount(double amount) {
    // Remove trailing zeros if it's a whole number
    if (amount % 1 == 0) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(2);
  }

  void _validateAmount(String value) {
    final amount = double.tryParse(value);
    setState(() {
      _isAmountValid = amount != null && amount > 0;
    });
  }

  void _handleContinue() {
    if (_isAmountValid) {
      final amount = double.tryParse(_amountController.text);

      if (amount != null) {
        final data = {'amount': amount, 'currency': _selectedCurrency};

        context.read<UserInfoCubit>().updateMoneySavedPerDay(data);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<UserInfoCubit>(),
              child: const Step9ReviewHour(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isLandscape ? 32 : 24,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Compact Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Financial Savings',
                      style: TextStyle(
                        fontSize: isLandscape ? 28 : 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'How much money do you think you can spare per day if you stop?',
                      style: TextStyle(
                        fontSize: isLandscape ? 16 : 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Information Card - more compact
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F7FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE3F2FD),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            color: const Color.fromARGB(255, 0, 9, 180),
                            size: isLandscape ? 18 : 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'This helps us track your financial progress.',
                              style: TextStyle(
                                fontSize: isLandscape ? 12 : 13,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Amount Input Card
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFEEEEEE),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Savings Amount',
                        style: TextStyle(
                          fontSize: isLandscape ? 16 : 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Amount Input with Currency
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                _isAmountValid &&
                                    _amountController.text.isNotEmpty
                                ? Colors.green
                                : _amountController.text.isNotEmpty
                                ? Colors.orange
                                : const Color(0xFFEEEEEE),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _amountController,
                                focusNode: _amountFocusNode,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: false,
                                    ),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 18,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.attach_money,
                                    color: Colors.grey,
                                    size: isLandscape ? 20 : 24,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: isLandscape ? 20 : 24,
                                  fontWeight: FontWeight.w600,
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    _validateAmount(value);
                                  } else {
                                    setState(() {
                                      _isAmountValid = false;
                                    });
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: isLandscape ? 70 : 80,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Color(0xFFEEEEEE),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                _selectedCurrency,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isLandscape ? 18 : 20,
                                  fontWeight: FontWeight.w700,
                                  color: const Color.fromARGB(255, 0, 9, 180),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            _isAmountValid && _amountController.text.isNotEmpty
                                ? Icons.check_circle
                                : _amountController.text.isNotEmpty
                                ? Icons.error_outline
                                : Icons.info_outline,
                            size: 16,
                            color:
                                _isAmountValid &&
                                    _amountController.text.isNotEmpty
                                ? Colors.green
                                : _amountController.text.isNotEmpty
                                ? Colors.orange
                                : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _amountController.text.isEmpty
                                ? 'Enter the amount you save daily'
                                : _isAmountValid
                                ? 'Valid amount'
                                : 'Please enter a valid positive number',
                            style: TextStyle(
                              fontSize: isLandscape ? 12 : 14,
                              color:
                                  _isAmountValid &&
                                      _amountController.text.isNotEmpty
                                  ? Colors.green
                                  : _amountController.text.isNotEmpty
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Currency Selection
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFEEEEEE),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Currency',
                        style: TextStyle(
                          fontSize: isLandscape ? 16 : 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Default: DA (Algerian Dinar)',
                        style: TextStyle(
                          fontSize: isLandscape ? 13 : 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Currency Grid - Using Wrap for better layout
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.start,
                        children: _currencies.map((currency) {
                          final symbol = currency['symbol'] as String;
                          final name = currency['name'] as String;
                          final isDefault = currency['default'] == true;
                          final isSelected = _selectedCurrency == symbol;
                          final itemWidth = isLandscape
                              ? (MediaQuery.of(context).size.width - 80) /
                                    6 // 6 columns in landscape
                              : (MediaQuery.of(context).size.width - 72) /
                                    4; // 4 columns in portrait

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCurrency = symbol;
                              });
                            },
                            child: Container(
                              width: itemWidth,
                              height: 60,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color.fromARGB(255, 0, 9, 180)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color.fromARGB(255, 0, 9, 180)
                                      : const Color(0xFFEEEEEE),
                                  width: isSelected ? 2 : 1.5,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                            255,
                                            0,
                                            9,
                                            180,
                                          ).withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    symbol,
                                    style: TextStyle(
                                      fontSize: isLandscape ? 18 : 20,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  if (isDefault && !isSelected)
                                    const SizedBox(height: 4),
                                  if (isDefault && !isSelected)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          9,
                                          180,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'DEFAULT',
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // Preview
                if (_isAmountValid && _amountController.text.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.savings, color: Colors.green),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daily savings: $_selectedCurrency${_amountController.text}',
                                style: TextStyle(
                                  fontSize: isLandscape ? 14 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Weekly: $_selectedCurrency${(double.tryParse(_amountController.text) ?? 0 * 7).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: isLandscape ? 12 : 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Continue Button
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    top: isLandscape ? 20 : 40,
                    bottom: MediaQuery.of(context).padding.bottom + 20,
                  ),
                  child: ValidationButton(
                    label: 'Continue',
                    onPressed: () => _isAmountValid ? _handleContinue() : null,
                    enabled: _isAmountValid,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }
}
