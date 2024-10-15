import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for user details

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> interestedGroups;

  CartPage({required this.interestedGroups});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String selectedPaymentMethod = '';

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF064A58),
        title: Text(
          'Cart',
          style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Study Groups in Cart Section
            Text(
              'Study Groups in Cart',
              style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildCartItems(),
            SizedBox(height: 20),

            // Total Price Section
            Text(
              'Total: ₹10.00 x ${widget.interestedGroups.length} = ₹${10 * widget.interestedGroups.length}',
              style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF064A58),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (widget.interestedGroups.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Your cart is empty! Please add study groups to cart.'),
                    ));
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentMethodPage(interestedGroups: widget.interestedGroups),
                      ),
                    );
                  }
                },
                child: Text(
                  'Checkout',
                  style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Cart Items Builder
  Widget _buildCartItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.interestedGroups.length,
      itemBuilder: (context, index) {
        final group = widget.interestedGroups[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  group['subject'] ?? 'No subject',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹10.00',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PaymentMethodPage extends StatefulWidget {
  final List<Map<String, dynamic>> interestedGroups;

  PaymentMethodPage({required this.interestedGroups});

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String selectedPaymentMethod = '';

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF064A58),
        title: Text(
          'Select a Payment Method',
          style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // UPI Section
            Text(
              'UPI',
              style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildPaymentOption(
              title: 'Other UPI Apps',
              description: 'Google Pay, PhonePe, Paytm and more',
              isSelected: selectedPaymentMethod == 'Other UPI Apps',
              onTap: () => _selectPaymentMethod('Other UPI Apps'),
              icon: Icons.qr_code,
            ),
            SizedBox(height: 16),

            // Credit & Debit Cards Section
            Text(
              'Credit & Debit Cards',
              style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildPaymentOption(
              title: 'Add a new credit or debit card',
              isSelected: selectedPaymentMethod == 'Credit or Debit Card',
              onTap: () => _selectPaymentMethod('Credit or Debit Card'),
              icon: Icons.credit_card,
            ),
            SizedBox(height: 16),

            // More Ways to Pay Section
            Text(
              'More Ways to Pay',
              style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildPaymentOption(
              title: 'EMI',
              isSelected: selectedPaymentMethod == 'EMI',
              onTap: () => _selectPaymentMethod('EMI'),
              icon: Icons.payment,
            ),
            _buildPaymentOption(
              title: 'Net Banking',
              isSelected: selectedPaymentMethod == 'Net Banking',
              onTap: () => _selectPaymentMethod('Net Banking'),
              icon: Icons.account_balance,
            ),
            SizedBox(height: 20),

            // Gift Card or Promo Code Section
            _buildGiftCardSection(),

            SizedBox(height: 30),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF064A58),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (selectedPaymentMethod.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please select a payment method!'),
                    ));
                  } else {
                    _registerStudyGroups();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentSuccessPage(),
                      ),
                    );
                  }
                },
                child: Text(
                  'Continue',
                  style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Payment Option Builder
  Widget _buildPaymentOption({
    required String title,
    String? description,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
    String? actionText,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio(
                value: title,
                groupValue: selectedPaymentMethod,
                onChanged: (value) => onTap(),
              ),
              SizedBox(width: 10),
              Icon(icon ?? Icons.payment, size: 30, color: Colors.grey),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (description != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          description,
                          style: GoogleFonts.lato(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    if (actionText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          actionText,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Gift Card Section
  Widget _buildGiftCardSection() {
    return ExpansionTile(
      title: Text(
        'Add Gift Card or Promo Code',
        style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter gift card or promo code',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Promo Code Applied!'),
              ));
            },
            child: Text('Apply'),
          ),
        ),
      ],
    );
  }

  // Register Study Groups
  void _registerStudyGroups() {
    final userID = FirebaseAuth.instance.currentUser?.email ?? ''; // Get the actual user's email

    if (userID.isEmpty) {
      print("User is not authenticated.");
      return;
    }

    for (var group in widget.interestedGroups) {
      final studyGroupID = group['studyGroupID'] ?? 'unknown';

      // Add to subcollection under the user
      FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('registered_study_groups')
          .doc(studyGroupID)
          .set(group)
          .then((_) => print("Added to user's subcollection successfully"))
          .catchError((error) => print("Failed to add to user's subcollection: $error"));

      // Add to main collection for global access
      FirebaseFirestore.instance
          .collection('registered_study_groups')
          .doc('${userID}_$studyGroupID') // Use a combination of userID and studyGroupID as document ID to ensure uniqueness
          .set({
        'userID': userID,
        'studyGroupID': studyGroupID,
        'groupDetails': group
      })
          .then((_) => print("Added to main collection successfully"))
          .catchError((error) => print("Failed to add to main collection: $error"));
    }
  }

  // Select Payment Method Handler
  void _selectPaymentMethod(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });
  }
}

class PaymentSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF064A58),
        title: Text(
          'Payment Successful',
          style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: isDarkMode ? Colors.lightGreen : Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Your payment was successful!!',
              style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF064A58),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
              child: Text(
                'Back to Home',
                style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}