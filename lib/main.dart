import 'package:flutter/material.dart';

void main() {
  runApp(const TDEECalculator());
}

class TDEECalculator extends StatelessWidget {
  const TDEECalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TDEE Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String gender = 'male';
  String activityLevel = 'sedentary';

  void calculateTDEE() {
    final double? age = double.tryParse(ageController.text);
    final double? weight = double.tryParse(weightController.text);
    final double? height = double.tryParse(heightController.text);

    if (age == null || weight == null || height == null) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Error"),
          content: Text("Please enter valid numbers in all fields."),
        ),
      );
      return;
    }

    double bmr = gender == 'male'
        ? 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)
        : 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);

    final multipliers = {
      'sedentary': 1.2,
      'light': 1.375,
      'moderate': 1.55,
      'active': 1.725
    };

    final tdee = bmr * multipliers[activityLevel]!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("TDEE Result"),
        content: Text("Your Total Daily Energy Expenditure is ${tdee.toStringAsFixed(0)} kcal/day."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF303030),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4))
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'TDEE Calculator',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00E676),
                  ),
                ),
                const SizedBox(height: 20),
                CustomInput(controller: ageController, label: 'Age'),
                CustomInput(controller: weightController, label: 'Weight (kg)'),
                CustomInput(controller: heightController, label: 'Height (cm)'),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Gender', style: TextStyle(color: Colors.white)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      label: 'Male',
                      active: gender == 'male',
                      onTap: () => setState(() => gender = 'male'),
                    ),
                    CustomButton(
                      label: 'Female',
                      active: gender == 'female',
                      onTap: () => setState(() => gender = 'female'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Activity Level', style: TextStyle(color: Colors.white)),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var level in ['sedentary', 'light', 'moderate', 'active'])
                      CustomButton(
                        label: level[0].toUpperCase() + level.substring(1),
                        active: activityLevel == level,
                        onTap: () => setState(() => activityLevel = level),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: calculateTDEE,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Calculate TDEE',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const CustomInput({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF424242),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF00E676) : const Color(0xFF424242),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
