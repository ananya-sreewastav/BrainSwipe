import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> interestedGroups;

  CartPage({required this.interestedGroups});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF064A58),
        title: Text(
          'BrainSwipe',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: interestedGroups.isEmpty
          ? Center(
        child: Text(
          'No study groups added to the cart.',
          style: GoogleFonts.lato(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 18,
          ),
        ),
      )
          : ListView.builder(
        itemCount: interestedGroups.length,
        itemBuilder: (context, index) {
          final group = interestedGroups[index];
          return ListTile(
            title: Text(
              group['subject'] ?? 'No subject',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Department: ${group['department'] ?? 'No department'}'),
                Text('Date: ${group['date'] ?? 'No date'}'),
                Text('Time: ${group['time'] ?? 'No time'}'),
                Text('Location: ${group['location'] ?? 'No location'}'),
              ],
            ),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}
