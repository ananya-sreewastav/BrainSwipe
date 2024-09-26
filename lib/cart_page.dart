import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatelessWidget {
  final List<Map<String, String>> cartItems;

  CartPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF052659),
        title: Text(
          'Cart',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: cartItems.isEmpty
          ? Center(
        child: Text(
          'Cart is empty',
          style: GoogleFonts.roboto(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            title: Text(
              item['name']!,
              style: GoogleFonts.playfairDisplay(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              'Venue: ${item['venue']} \nDate: ${item['date']}',
              style: GoogleFonts.roboto(
                color: isDarkMode ? Colors.white70 : Colors.black54,
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}
