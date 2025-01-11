import 'package:flutter/material.dart';
import 'package:flutter_tugas/models/agent_models.dart';
import 'package:flutter_tugas/ui/edit_agent.dart';

class AgentDetail extends StatelessWidget {
  final AgentModel agentModel;

  const AgentDetail({Key? key, required this.agentModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(agentModel.name),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          agentModel.name[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              agentModel.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              agentModel.email,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  agentModel.status == "Active"
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: agentModel.status == "Active"
                                      ? Colors.green
                                      : Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  agentModel.status,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: agentModel.status == "Active"
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Card for additional details
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detail Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildDetailRow(
                        context,
                        title: 'Created At',
                        value: agentModel.createdAt,
                        icon: Icons.calendar_today,
                      ),
                      const Divider(),
                      buildDetailRow(
                        context,
                        title: 'Updated At',
                        value: agentModel.updatedAt,
                        icon: Icons.update,
                      ),
                      const Divider(),
                      if (agentModel.deletedAt != null)
                        buildDetailRow(
                          context,
                          title: 'Deleted At',
                          value: agentModel.deletedAt!,
                          icon: Icons.delete_forever,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAgentScreen(agentModel: agentModel),
      ),
    );
  },
  backgroundColor: Colors.blueAccent,
  child: const Icon(Icons.edit, color: Colors.white),
  tooltip: 'Edit Agent',
),

    );
  }

  Widget buildDetailRow(BuildContext context,
      {required String title, required String value, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}


// class EditAgentScreen extends StatelessWidget {
//   final AgentModel agentModel;

//   const EditAgentScreen({Key? key, required this.agentModel}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit ${agentModel.name}'),
//       ),
//       body: Center(
//         child: Text('Edit form for ${agentModel.name}'),
//       ),
//     );
//   }
// }
