import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petnest/providers/user_provider.dart' hide User;
import 'package:petnest/data/mock_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Required for Auth

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _activeTab = 'upcoming';
  bool _isUploading = false;

  // Get the current logged-in user from Firebase
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  Future<void> _pushMockDataToFirebase() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String? currentUserId = firebaseUser?.uid;

    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ You must be logged in!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isUploading = true);
    final db = FirebaseFirestore.instance;

    try {
      // 1. Upload Products
      for (var item in mockProducts) {
        await db.collection('products').doc(item.id.toString()).set({
          'id': item.id,
          'name': item.name,
          'price': item.price,
          'category': item.category,
          'image': item.image,
          'description': item.description,
          'ownerId': currentUserId,
          'uploadedAt': FieldValue.serverTimestamp(),
        });
      }

      // 2. Upload Doctors
      for (var doc in mockDoctors) {
        await db.collection('doctors').doc(doc.id.toString()).set({
          'id': doc.id,
          'name': doc.name,
          'specialty': doc.specialty,
          'ownerId': currentUserId,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Data Synced Successfully!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  // --- LOGOUT FUNCTION (Backend Logic) ---
  Future<void> _handleLogout() async {
    try {
      // 1. Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // 2. Clear local provider data (Optional but good practice)
      // Provider.of<UserProvider>(context, listen: false).clearData();

      // 3. Navigate to Login Screen
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/start', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // We try to get data from Provider, but fallback to Firebase for Email
    final userProvider = Provider.of<UserProvider>(context);

    // Logic: Use Firebase Email if available, otherwise "Guest"
    final String displayEmail = firebaseUser?.email ?? userProvider.email;
    final String displayName = userProvider.userName.isNotEmpty ? userProvider.userName : "User";

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          _isUploading
              ? const Padding(padding: EdgeInsets.all(12.0), child: CircularProgressIndicator(strokeWidth: 2))
              : IconButton(
            icon: const Icon(Icons.cloud_upload, color: Colors.blue),
            onPressed: _pushMockDataToFirebase,
            tooltip: "Sync Mock Data to Cloud",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Header (Now uses real Email)
            _buildHeader(displayName, displayEmail),

            const SizedBox(height: 24),

            // Admin Panel
            _buildAdminPanel(),

            const SizedBox(height: 24),

            // User Info
            _buildInfoCard(userProvider),

            const SizedBox(height: 32),

            // Sign Out (Now functional)
            _buildSignOutButton(),
          ],
        ),
      ),
    );
  }

  // --- UPDATED UI COMPONENTS ---

  Widget _buildHeader(String name, String email) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200'),
            backgroundColor: Colors.blue[50],
          ),
          const SizedBox(height: 16),
          Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          // Shows the REAL Firebase Gmail
          Text(email, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildAdminPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Inventory Management', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
          const SizedBox(height: 8),
          const Text('Upload data as public, but only you will have delete rights.',
              style: TextStyle(fontSize: 12, color: Colors.orange)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isUploading ? null : _pushMockDataToFirebase,
              icon: const Icon(Icons.storage),
              label: Text(_isUploading ? 'Syncing...' : 'Push & Tag Data'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildRow('City', user.city.isNotEmpty ? user.city : "Not set"),
          const Divider(),
          _buildRow('Phone', user.phone.isNotEmpty ? user.phone : "Not set"),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSignOutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        // Calls the new backend function
        onPressed: _handleLogout,
        style: TextButton.styleFrom(
            foregroundColor: Colors.red,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.red.shade100))
        ),
        child: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}