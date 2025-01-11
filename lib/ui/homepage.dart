import 'package:flutter/material.dart';
import 'package:flutter_tugas/ui/usermenu.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            MenuCard(
              label: 'Cari Agent',
              icon: Icons.search,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserHomepage()),
                );
              },
            ),
            MenuCard(
              label: 'Tambah Agent',
              icon: Icons.add_circle,
              onTap: () {
                
              },
            ),
            MenuCard(
              label: 'Keluar',
              icon: Icons.logout,
              onTap: () {
                _showExitConfirmationDialog(context);
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Future.delayed(Duration(milliseconds: 100), () {
                  // Gunakan delay kecil agar dialog benar-benar tertutup sebelum keluar
                  Navigator.of(context).pop(); // Keluar dari aplikasi
                });
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }
class MenuCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const MenuCard({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
