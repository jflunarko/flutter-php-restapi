import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tugas/models/agent_models.dart';

class EditAgentScreen extends StatefulWidget {
  final AgentModel agentModel;

  const EditAgentScreen({Key? key, required this.agentModel}) : super(key: key);

  @override
  State<EditAgentScreen> createState() => _EditAgentScreenState();
}

class _EditAgentScreenState extends State<EditAgentScreen> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late String _status;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.agentModel.name);
    _emailController = TextEditingController(text: widget.agentModel.email);
    _status = widget.agentModel.status;
  }

  Future<void> _updateAgent() async {
    if (_formKey.currentState!.validate()) {
      try {
        String url = 'http://127.0.0.1/api-php/edit_agent.php';
        var response = await _dio.post(
          url,
          data: {
            'id': widget.agentModel.id,
            'name': _nameController.text,
            'email': _emailController.text,
            'status': _status,
          },
        );

        if (response.statusCode == 200 && response.data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Agent updated successfully!')),
          );
          Navigator.pop(context); // Kembali ke halaman sebelumnya
        } else {
          throw Exception(response.data['message']);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update agent: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.agentModel.name}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Status Dropdown
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: ['Active', 'Inactive']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Status is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _updateAgent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
