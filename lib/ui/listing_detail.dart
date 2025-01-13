import 'package:dio/dio.dart'; // Tambahkan impor untuk Dio
import 'package:flutter/material.dart';
import 'package:flutter_tugas/repo/resp/listing_create_resp.dart';
import 'package:flutter_tugas/ui/listing_edit.dart';
import 'package:flutter_tugas/repo/agent.dart';
import 'package:flutter_tugas/models/agent_models.dart';
import 'package:intl/intl.dart';

class ListingDetail extends StatefulWidget {
  final ListingModel listingModel;

  const ListingDetail({super.key, required this.listingModel});

  @override
  _ListingDetailState createState() => _ListingDetailState();
}

class _ListingDetailState extends State<ListingDetail> {
  AgentModel? _agent;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAgent();
  }

  Future<void> _fetchAgent() async {
    try {
      final agent = await AgentRepository().getAgentById(widget.listingModel.agentId);
      setState(() {
        _agent = agent;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _agent = null;
        _isLoading = false;
      });
    }
  }

  Future<void> deleteListing(int listingId) async {
    try {
      final Dio dio = Dio();
      String url = 'http://10.0.0.95/api-php/listing_delete.php';
      var response = await dio.post(url, data: {'id': listingId});

      if (response.statusCode == 200 && response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'])),
        );
        Navigator.pop(context, true); // Kembali ke halaman sebelumnya
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus listing: $e')),
      );
    }
  }

  String formattedPrice(String price) {
    return NumberFormat.currency(
      locale: 'id_ID', symbol: 'Rp', decimalDigits: 0,
    ).format(int.parse(price));
  }

  String formatDate(String date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Listing'),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final bool? confirmDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Konfirmasi Hapus'),
                  content: const Text('Apakah Anda yakin ingin menghapus listing ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );

              if (confirmDelete == true) {
                await deleteListing(widget.listingModel.id);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.listingModel.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  formattedPrice(widget.listingModel.price),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.green[700],
                  ),
                ),
                const Divider(height: 20, thickness: 1),
                _buildInfoTile(Icons.location_on, 'Alamat', widget.listingModel.street),
                _buildInfoTile(Icons.category, 'Kategori', widget.listingModel.category),
                _buildInfoTile(Icons.date_range, 'Dibuat', formatDate(widget.listingModel.createdAt)),
                _buildInfoTile(Icons.update, 'Diperbarui', formatDate(widget.listingModel.updatedAt)),
                const Divider(height: 20, thickness: 1),
                _buildAgentInfo(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditListingPage(listing: widget.listingModel),
            ),
          );
        },
        child: const Icon(Icons.edit),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildAgentInfo() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_agent == null) {
      return const Text(
        "Agen tidak ditemukan",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    }

    return Card(
      elevation: 5,
      child: ListTile(
        leading: Icon(
          _agent!.status == "Active" ? Icons.check_circle : Icons.cancel,
          color: _agent!.status == "Active" ? Colors.green : Colors.red,
        ),
        title: Text(_agent!.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(_agent!.email),
      ),
    );
  }
}
