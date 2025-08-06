import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateFuelPricePage extends StatefulWidget {
  const CreateFuelPricePage({super.key});

  @override
  State<CreateFuelPricePage> createState() => _CreateFuelPricePageState();
}

class _CreateFuelPricePageState extends State<CreateFuelPricePage> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  DateTime? _effectiveFrom;

  String? _selectedFuelType;

  final fuelTypes = ['PETROL', 'DIESEL', 'LPG', 'KEROSENE'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Set Fuel Price")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Fuel Type',
                border: OutlineInputBorder(),
              ),
              value: _selectedFuelType,
              items: fuelTypes
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedFuelType = value);
              },
              validator: (value) =>
                  value == null ? 'Please select fuel type' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Price per Litre (KES)',
                border: OutlineInputBorder(),
                prefixText: 'KES ',
              ),
              validator: (value) {
                final parsed = double.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid price';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Effective From',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _effectiveFrom != null
                      ? DateFormat.yMMMMd().add_jm().format(_effectiveFrom!)
                      : 'Select date and time',
                  style: TextStyle(
                    color: _effectiveFrom != null
                        ? null
                        : Theme.of(context).hintColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // TextFormField(
            //   controller: _colorController,
            //   decoration: InputDecoration(
            //     labelText: 'Color HEX',
            //     border: const OutlineInputBorder(),
            //     suffixIcon: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: CircleAvatar(
            //         radius: 10,
            //         backgroundColor: _parseHexColor(_colorController.text),
            //       ),
            //     ),
            //   ),
            //   onChanged: (_) => setState(() {}),
            //   validator: (value) {
            //     if (value == null || !_isValidHex(value)) {
            //       return 'Enter a valid hex color (e.g. #1D8289)';
            //     }
            //     return null;
            //   },
            // ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save),
              label: const Text('Save Price'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _effectiveFrom = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    // You can send this to the backend or controller
    final priceData = {
      'fuel_type': _selectedFuelType,
      'price_per_litre': double.parse(_priceController.text),
      'effective_from': _effectiveFrom?.toUtc().toIso8601String(),
      // 'color_hex': _colorController.text,
    };

    print("🚀 Creating fuel price: $priceData");

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Fuel price saved')));

    // Clear form or navigate away
  }

  Color _parseHexColor(String hex) {
    try {
      final buffer = StringBuffer();
      if (hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  bool _isValidHex(String hex) {
    final hexRegExp = RegExp(r'^#(?:[0-9a-fA-F]{6})$');
    return hexRegExp.hasMatch(hex);
  }
}
