import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk FilteringTextInputFormatter
import 'package:flutter_tugas/models/agent_models.dart';
import 'package:flutter_tugas/repo/agent.dart';
import 'package:flutter_tugas/repo/listing_repo.dart';
import 'package:flutter_tugas/repo/resp/listing_create_resp.dart';

class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key});

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  final ListingRepository listingRepository = ListingRepository();
  final AgentRepository agentRepository = AgentRepository();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  late Future<List<AgentModel>> futureAgents;
  int? selectedAgentId;

  @override
  void initState() {
    super.initState();
    futureAgents = agentRepository.getAgentModels();
  }

  void saveListing() async {
    if (selectedAgentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih agent terlebih dahulu')),
      );
      return;
    }

    if (nameController.text.isEmpty ||
        streetController.text.isEmpty ||
        priceController.text.isEmpty ||
        categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi semua bidang')),
      );
      return;
    }

    ListingModel newListing = ListingModel(
      id: 0,
      agentId: selectedAgentId!,
      name: nameController.text,
      street: streetController.text,
      price: priceController.text,
      category: categoryController.text,
      createdAt: '',
      updatedAt: '',
    );

    try {
      await listingRepository.createListing(newListing);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing berhasil dibuat!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Listing Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<List<AgentModel>>(
              future: futureAgents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final agents = snapshot.data!;
                  if (agents.isEmpty) {
                    return const Text('Tidak ada agent tersedia');
                  }
                  return DropdownButtonFormField<int>(
                    value: selectedAgentId,
                    items: agents
                        .map((agent) => DropdownMenuItem<int>(
                              value: agent.id,
                              child: Text(agent.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAgentId = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Pilih Agent',
                      border: OutlineInputBorder(),
                    ),
                  );
                } else {
                  return const Text('Tidak ada data');
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Listing',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: streetController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Harga',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: saveListing,
              child: const Text('Simpan Listing'),
            ),
          ],
        ),
      ),
    );
  }
}
