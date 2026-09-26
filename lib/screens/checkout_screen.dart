import 'package:flutter/material.dart';

import '../cart_data.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final Color pink = const Color(0xFFD85C96);
  final Color purple = const Color(0xFF7656D8);
  final Color blue = const Color(0xFF4BB9D5);
  final Color darkText = const Color(0xFF29243A);
  final Color background = const Color(0xFFF8F7FF);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String selectedPayment = 'Transfer Bank';

  final List<String> paymentMethods = [
    'Transfer Bank',
    'E-Wallet',
    'QRIS',
  ];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  double get subtotal {
    double total = 0;

    for (final item in CartData.items) {
      final priceText = item['price'].toString();

      final price = double.tryParse(
            priceText
                .replaceAll('Rp', '')
                .replaceAll('.', '')
                .replaceAll(',', '')
                .trim(),
          ) ??
          0;

      final quantity = item['quantity'] ?? 1;

      total += price * quantity;
    }

    return total;
  }

  String formatPrice(double price) {
    return 'Rp${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        )}';
  }

  void _processPayment() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan lengkapi data pembeli terlebih dahulu.',
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          contentPadding: const EdgeInsets.all(30),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      purple,
                      pink,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 45,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Pesanan Berhasil!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkText,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Terima kasih, ${nameController.text.trim()}!\n'
                'Pesanan digital template kamu berhasil dibuat.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkText.withValues(alpha: 0.65),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    CartData.clearCart();

                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInput({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: darkText,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: darkText.withValues(alpha: 0.35),
              fontSize: 13,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                bottom: maxLines > 1 ? 45 : 0,
              ),
              child: Icon(
                icon,
                color: purple,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: darkText.withValues(alpha: 0.06),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: purple,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod({
    required String title,
    required IconData icon,
  }) {
    final isSelected = selectedPayment == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? purple.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? purple
                : darkText.withValues(alpha: 0.08),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    purple,
                    pink,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected
                  ? purple
                  : darkText.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            purple,
            pink,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pesanan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),

          ...CartData.items.map(
            (item) {
              final quantity = item['quantity'] ?? 1;

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 14,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${item['name']} × $quantity',
                        style: TextStyle(
                          color: Colors.white.withValues(
                            alpha: 0.9,
                          ),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item['price'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          Divider(
            color: Colors.white.withValues(alpha: 0.25),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                formatPrice(subtotal),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: purple,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 17,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Bayar Sekarang',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 20,
      ),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: darkText,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'DIGIMART',
            style: TextStyle(
              color: darkText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          Text(
            'Checkout',
            style: TextStyle(
              color: darkText.withValues(alpha: 0.65),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (CartData.items.isEmpty) {
      return Scaffold(
        backgroundColor: background,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: purple.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Keranjang masih kosong',
                        style: TextStyle(
                          color: darkText,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tambahkan template terlebih dahulu.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: darkText.withValues(alpha: 0.55),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 70 : 20,
                    vertical: 35,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Checkout',
                        style: TextStyle(
                          color: darkText,
                          fontSize: isDesktop ? 32 : 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lengkapi data untuk menyelesaikan pesanan.',
                        style: TextStyle(
                          color: darkText.withValues(alpha: 0.55),
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 30),

                      isDesktop
                          ? Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    children: [
                                      _buildCustomerForm(),
                                      const SizedBox(height: 25),
                                      _buildPaymentSection(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                  flex: 4,
                                  child: _buildOrderSummary(),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildCustomerForm(),
                                const SizedBox(height: 25),
                                _buildPaymentSection(),
                                const SizedBox(height: 25),
                                _buildOrderSummary(),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomerForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: darkText.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Pembeli',
            style: TextStyle(
              color: darkText,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),

          _buildInput(
            label: 'Nama Lengkap',
            hint: 'Masukkan nama lengkap',
            icon: Icons.person_outline_rounded,
            controller: nameController,
          ),

          const SizedBox(height: 18),

          _buildInput(
            label: 'Email',
            hint: 'Masukkan email',
            icon: Icons.email_outlined,
            controller: emailController,
          ),

          const SizedBox(height: 18),

          _buildInput(
            label: 'Alamat',
            hint: 'Masukkan alamat',
            icon: Icons.location_on_outlined,
            controller: addressController,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: darkText.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Metode Pembayaran',
            style: TextStyle(
              color: darkText,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),

          _buildPaymentMethod(
            title: 'Transfer Bank',
            icon: Icons.account_balance_rounded,
          ),

          const SizedBox(height: 12),

          _buildPaymentMethod(
            title: 'E-Wallet',
            icon: Icons.account_balance_wallet_rounded,
          ),

          const SizedBox(height: 12),

          _buildPaymentMethod(
            title: 'QRIS',
            icon: Icons.qr_code_rounded,
          ),
        ],
      ),
    );
  }
}