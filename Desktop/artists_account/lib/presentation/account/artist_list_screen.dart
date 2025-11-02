import 'package:flutter/material.dart';
import 'other_user_account_screen.dart';

class ArtistListScreen extends StatelessWidget {
  const ArtistListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final artists = [
      {
        'id': 'user123',
        'name': 'Aline Mukarurangwa',
        'profession': 'Painter',
        'location': 'Kigali',
        'bio': 'speak my mind through my pen...',
      },
      {
        'id': 'user456',
        'name': 'Jean Claude Niyonsenga',
        'profession': 'Sculptor',
        'location': 'Kigali',
        'bio': 'Shaping stories through stone and clay',
      },
      {
        'id': 'user789',
        'name': 'Grace Uwase',
        'profession': 'Digital Artist',
        'location': 'Kigali',
        'bio': 'Bringing imagination to life through pixels',
      },
      {
        'id': 'user101',
        'name': 'Samuel Mugisha',
        'profession': 'Photographer',
        'location': 'Kigali',
        'bio': 'Capturing moments that tell stories',
      },
      {
        'id': 'user202',
        'name': 'Diane Iradukunda',
        'profession': 'Fashion Designer',
        'location': 'Kigali',
        'bio': 'Blending tradition with contemporary style',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Artists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: _buildAvatar(artist['name']!),
              title: Text(
                artist['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${artist['profession']} · ${artist['location']}',
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtherUserAccountScreen(
                      userId: artist['id']!,
                      name: artist['name']!,
                      profession: artist['profession']!,
                      location: artist['location']!,
                      bio: artist['bio']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(String name) {
    final initials = name.split(' ').map((n) => n[0]).take(2).join();
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
