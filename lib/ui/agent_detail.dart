import 'package:flutter/material.dart';
import 'package:flutter_tugas/models/agent_models.dart';
import 'package:flutter_tugas/repo/agent.dart';
import 'package:flutter_tugas/repo/listing_repo.dart';
import 'package:flutter_tugas/repo/resp/listing_create_resp.dart';
import 'package:flutter_tugas/ui/agent_edit.dart';
import 'package:flutter_tugas/ui/listing_detail.dart';

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
              _buildAgentCard(),
              const SizedBox(height: 24),
              _buildDetailInformation(),
              const SizedBox(height: 24),
              _buildListingSection(context),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingButtons(context),
    );
  }

  Widget _buildAgentCard() {
    return Card(
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
    );
  }

  Widget _buildDetailInformation() {
    return Card(
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
              title: 'Created At',
              value: agentModel.createdAt,
              icon: Icons.calendar_today,
            ),
            const Divider(),
            buildDetailRow(
              title: 'Updated At',
              value: agentModel.updatedAt,
              icon: Icons.update,
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildListingSection(BuildContext context) {
  return FutureBuilder<List<ListingModel>>(
    future: ListingRepository().getListingsByAgent(agentModel.id),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Failed to load listings: ${snapshot.error}'),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(
          child: Text('No listings found for this agent.'),
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Listings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final listing = snapshot.data![index];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(listing.name),
                    subtitle: Text(
                      'Price: ${listing.price} | Category: ${listing.category}',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // 🔹 Navigasi ke halaman ListingDetail ketika item ditekan
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListingDetail(listingModel: listing),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
      }
    },
  );
}


  Widget _buildFloatingButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
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
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: () {
            _confirmDelete(context);
          },
          backgroundColor: Colors.redAccent,
          child: const Icon(Icons.delete, color: Colors.white),
          tooltip: 'Delete Agent',
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this agent?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAgent(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteAgent(BuildContext context) async {
    final repository = AgentRepository();
    try {
      await repository.deleteAgent(agentModel.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agent deleted successfully'),
          backgroundColor: Colors.redAccent,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete agent: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget buildDetailRow({
    required String title,
    required String value,
    required IconData icon,
  }) {
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
