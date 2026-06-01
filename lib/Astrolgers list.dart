import 'package:flutter/material.dart';
import 'package:astrotalk/payment.dart';
import 'package:astrotalk/ChatBox.dart';

class AstrologersList extends StatefulWidget {
  const AstrologersList({super.key});

  @override
  State<AstrologersList> createState() => _AstrologersListState();
}

class _AstrologersListState extends State<AstrologersList> {
  final List<Map<String, dynamic>> astrologers = [
    {
      'name': 'Prince Sharma',
      'languages': ['Hindi', 'Punjabi', 'English'],
      'experience': '15 years',
      'expertise': 'Vedic Astrology, Numerology',
      'charges': 50,
      'rating': 4.5,
      'online': true,
      'image': 'assets/prince.jpg',
    },
    {
      'name': 'Pandit Vipul',
      'languages': ['Hindi', 'English'],
      'experience': '10 years',
      'expertise': 'Tarot Reading, Palmistry',
      'charges': 50,
      'rating': 4.0,
      'online': false,
      'image': 'assets/vipul.jpg',
    },
    {
      'name': 'Samir Brahmin',
      'languages': ['Hindi', 'Punjabi'],
      'experience': '20 years',
      'expertise': 'Horoscope Analysis, Vastu',
      'charges': 50,
      'rating': 5.0,
      'online': true,
      'image': 'assets/samir.jpg',
    },
    {
      'name': 'Yaadi Baba',
      'languages': ['Punjabi', 'English'],
      'experience': '12 years',
      'expertise': 'KP Astrology, Face Reading',
      'charges': 50,
      'rating': 4.2,
      'online': false,
      'image': 'assets/yaadi.jpg',
    },
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredAstrologers = astrologers.where((astrologer) {
      final query = searchQuery.toLowerCase();
      return astrologer['name'].toLowerCase().contains(query) ||
          astrologer['expertise'].toLowerCase().contains(query) ||
          astrologer['languages'].join(',').toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Astrologers List'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search by name, language or expertise...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredAstrologers.length,
        itemBuilder: (context, index) {
          final astrologer = filteredAstrologers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(astrologer['image']),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                astrologer['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.circle,
                              color: astrologer['online'] ? Colors.green : Colors.red,
                              size: 12,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('Languages: ${astrologer['languages'].join(', ')}'),
                        Text('Experience: ${astrologer['experience']}'),
                        Text('Expertise: ${astrologer['expertise']}'),
                        const SizedBox(height: 4),
                        _buildRatingStars(astrologer['rating']),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '₹${astrologer['charges']}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _scheduleAppointment(astrologer),
                        child: const Text('Book', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    final fullStars = rating.floor();
    final halfStar = rating - fullStars >= 0.5;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else if (index == fullStars && halfStar) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 16);
        }
      }),
    );
  }

  Future<void> _scheduleAppointment(Map<String, dynamic> astrologer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Schedule Appointment'),
        content: Text('Do you want to schedule an appointment with ${astrologer['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Payment(
            amount: astrologer['charges'].toDouble(),
            astrologerName: astrologer['name'],
            astrologerImage: astrologer['image'],
          ),
        ),
      );
    }
  }
}
