import 'package:flutter/material.dart';
import 'package:flutter_tugas/models/agent_models.dart';
import 'package:flutter_tugas/repo/agent.dart';
import 'package:flutter_tugas/ui/agent_create.dart';
import 'package:flutter_tugas/ui/agent_detail.dart';

class UserHomepage extends StatefulWidget {
  const UserHomepage({super.key});

  @override
  State<UserHomepage> createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  final AgentRepository agentRepository = AgentRepository();
  late Future<List<AgentModel>> futureUser;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureUser = agentRepository.getAgentModels();
  }

  void searchAgent(String query) {
    setState(() {
      futureUser = agentRepository.getAgentModels(searchName: query);
    });
  }

  void refreshAgents() {
    setState(() {
      searchController.clear();
      futureUser = agentRepository.getAgentModels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Agent',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Cari agen berdasarkan nama',
                  prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                onChanged: (value) {
                  searchAgent(value);
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<AgentModel>>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  final agents = snapshot.data!;
                  if (agents.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada agen ditemukan',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: agents.length,
                    itemBuilder: (context, index) {
                      AgentModel agent = agents[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AgentDetail(agentModel: agent),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Text(
                                agent.name[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              agent.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(agent.email),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.indigo[300],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('No data available'),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateAgentPage(),
            ),
          );
          refreshAgents();
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
