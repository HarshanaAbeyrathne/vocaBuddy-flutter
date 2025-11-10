import 'package:flutter/material.dart';

class CreateActivityPage extends StatefulWidget {
  const CreateActivityPage({super.key});

  @override
  State<CreateActivityPage> createState() => _CreateActivityPageState();
}

class _CreateActivityPageState extends State<CreateActivityPage> {
  final TextEditingController _activityController = TextEditingController();

  @override
  void dispose() {
    _activityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Activity'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Activity Name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // This TextFormField provides the text input field.
            TextFormField(
              controller: _activityController,
              decoration: InputDecoration(
                // 'hintText' shows sample text inside the field when it's empty.
                hintText: 'e.g., "Describe the picture"',
                // 'labelText' provides a floating label.
                labelText: 'Enter activity name',
                border: const OutlineInputBorder(),
                // You can also add an icon.
                prefixIcon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // You can access the entered text using _activityController.text
                final activityName = _activityController.text;
                if (activityName.isNotEmpty) {
                  // TODO: Implement logic to save or use the activity name
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Activity Created: $activityName')),
                  );
                }
              },
              child: const Text('Create Activity'),
            ),
          ],
        ),
      ),
    );
  }
}
