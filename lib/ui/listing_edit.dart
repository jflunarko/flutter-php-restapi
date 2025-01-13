import 'package:flutter/material.dart';
import 'package:flutter_tugas/repo/listing_repo.dart';
import 'package:flutter_tugas/repo/resp/listing_create_resp.dart';

class EditListingPage extends StatefulWidget {
  final ListingModel listing;

  const EditListingPage({Key? key, required this.listing}) : super(key: key);

  @override
  State<EditListingPage> createState() => _EditListingPageState();
}

class _EditListingPageState extends State<EditListingPage> {
  final ListingRepository listingRepository = ListingRepository();

  late TextEditingController nameController;
  late TextEditingController streetController;
  late TextEditingController priceController;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.listing.name);
    streetController = TextEditingController(text: widget.listing.street);
    priceController = TextEditingController(text: widget.listing.price);
    categoryController = TextEditingController(text: widget.listing.category);
  }

  void updateListing() async {
    ListingModel updatedListing = ListingModel(
      id: widget.listing.id,
      agentId: widget.listing.agentId,
      name: nameController.text,
      street: streetController.text,
      price: priceController.text,
      category: categoryController.text,
      createdAt: widget.listing.createdAt,
      updatedAt: '', // This will be updated by the backend
    );

    try {
      await listingRepository.updateListing(updatedListing);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing berhasil diupdate!')),
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
        title: const Text('Edit Listing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Nama Listing
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Listing',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Input Street
            TextField(
              controller: streetController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Input Harga
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Harga',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Input Kategori
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Tombol Simpan
            ElevatedButton(
              onPressed: updateListing,
              child: const Text('Update Listing'),
            ),
          ],
        ),
      ),
    );
  }
}
