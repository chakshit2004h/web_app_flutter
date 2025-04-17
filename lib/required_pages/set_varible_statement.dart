import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../addon/provider.dart'; // Make sure you have your provider here

class SetVariablePage extends StatefulWidget {
  const SetVariablePage({super.key});

  @override
  State<SetVariablePage> createState() => _SetVariablePageState();
}

class _SetVariablePageState extends State<SetVariablePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController minLengthController = TextEditingController();
  final TextEditingController maxLengthController = TextEditingController();

  bool mAskUser = false;
  bool mAskUserCheckBox = false;

  String? selectedType;
  final List<String> spinnerOptions = ["Option 1", "Option 2", "Option 3"];

  @override
  void dispose() {
    nameController.dispose();
    questionController.dispose();
    valueController.dispose();
    minLengthController.dispose();
    maxLengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: const Color(0xff1a1e22),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomSwitch("Ask User", mAskUser, (val) => setState(() => mAskUser = val)),
            const SizedBox(height: 20),
            _buildCustomSwitch("Ask User CheckBox", mAskUserCheckBox, (val) => setState(() => mAskUserCheckBox = val)),
            const SizedBox(height: 20),
            _buildTextField("Name", nameController),
            const SizedBox(height: 20),
            _buildTextField("Question", questionController),
            const SizedBox(height: 20),
            _buildTextField("Min Length", minLengthController, isNumber: true),
            const SizedBox(height: 20),
            _buildTextField("Max Length", maxLengthController, isNumber: true),
            const SizedBox(height: 20),
            _buildDropdownField(),
            const SizedBox(height: 20),
            _buildTextField("Value", valueController),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<SaveCardState>(context, listen: false).addCard(
                    variableCardOutput(
                      name: nameController.text,
                      question: questionController.text,
                      minLength: minLengthController.text,
                      maxLength: maxLengthController.text,
                      type: selectedType ?? '',
                      value: valueController.text,
                      askUser: mAskUser,
                      askUserCheckbox: mAskUserCheckBox,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff04bcb0)),
                child: const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter $label",
            hintStyle: const TextStyle(color: Colors.white54),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff04bcb0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Type', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white54),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: selectedType,
            isExpanded: true,
            dropdownColor: const Color(0xff1a1e22),
            underline: const SizedBox(),
            hint: const Text("Select Type", style: TextStyle(color: Colors.white54)),
            style: const TextStyle(color: Colors.white),
            iconEnabledColor: const Color(0xff04bcb0),
            items: spinnerOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) => setState(() => selectedType = newValue),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xff04bcb0),
        ),
      ],
    );
  }
  Widget variableCardOutput({
    required String name,
    required String question,
    required String minLength,
    required String maxLength,
    required String type,
    required String value,
    required bool askUser,
    required bool askUserCheckbox,
  }) {
    return Card(
      color: const Color(0xff101f1f),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Variable", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Name: $name", style: const TextStyle(color: Colors.white)),
            Text("Question: $question", style: const TextStyle(color: Colors.white)),
            Text("Min Length: $minLength", style: const TextStyle(color: Colors.white)),
            Text("Max Length: $maxLength", style: const TextStyle(color: Colors.white)),
            Text("Type: $type", style: const TextStyle(color: Colors.white)),
            Text("Value: $value", style: const TextStyle(color: Colors.white)),
            Text("Ask User: ${askUser ? 'Yes' : 'No'}", style: const TextStyle(color: Colors.white)),
            Text("Ask User Checkbox: ${askUserCheckbox ? 'Yes' : 'No'}", style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

}
