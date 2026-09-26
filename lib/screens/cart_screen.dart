import 'package:flutter/material.dart';
import '../cart_data.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> get cartItems => CartData.items;

  double get totalPrice {
    double total = 0;

    for (final item in cartItems) {
      final priceText = item['price']
          .toString()
          .replaceAll('Rp', '')
          .replaceAll('.', '')
          .replaceAll(',', '')
          .trim();

      final price = double.tryParse(priceText) ?? 0;
      final quantity = (item['quantity'] as int?) ?? 1;

      total += price * quantity;
    }

    return total;
  }

  String formatPrice(double price) {
    final value = price.toInt().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      if (i > 0 && (value.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(value[i]);
    }

    return 'Rp ${buffer.toString()}';
  }

  void increaseQuantity(int index) {
    if (index < 0 || index >= CartData.items.length) {
      return;
    }

    setState(() {
      CartData.increaseQuantity(index);
    });
  }

  void decreaseQuantity(int index) {
    if (index < 0 || index >= CartData.items.length) {
      return;
    }

    setState(() {
      CartData.decreaseQuantity(index);
    });
  }

  void removeItem(int index) {
    if (index < 0 || index >= CartData.items.length) {
      return;
    }

    setState(() {
      CartData.removeItem(index);
    });
  }

  void _showDeleteDialog(int index) {
    // Cegah error jika index sudah tidak valid
    if (index < 0 || index >= CartData.items.length) {
      return;
    }

    final productName = CartData.items[index]['name'].toString();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Hapus Produk?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF29243A),
            ),
          ),
          content: Text(
            'Produk "$productName" akan dihapus dari keranjang.',
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                if (!mounted) return;

                // Cek lagi index sebelum menghapus
                if (index >= 0 &&
                    index < CartData.items.length) {
                  setState(() {
                    CartData.removeItem(index);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE06B8F),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openCheckout() async {
    // Jangan buka checkout kalau cart kosong
    if (CartData.items.isEmpty) {
      return;
    }

    // Tunggu sampai CheckoutScreen selesai
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CheckoutScreen(),
      ),
    );

    // Setelah kembali dari checkout,
    // refresh CartScreen supaya cart langsung kosong
    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDesktop),

            Expanded(
              child: cartItems.isEmpty
                  ? _buildEmptyCart(isDesktop)
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 50 : 20,
                        vertical: 25,
                      ),
                      child: isDesktop
                          ? Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _buildCartItems(),
                                ),
                                const SizedBox(width: 30),
                                SizedBox(
                                  width: 350,
                                  child: _buildSummary(),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildCartItems(),
                                const SizedBox(height: 25),
                                _buildSummary(),
                              ],
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 50 : 20,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFD85C96),
                  Color(0xFF7656D8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'DigiMart',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF29243A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shopping Cart',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF29243A),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '${cartItems.length} produk dalam keranjang',
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 20),

        ...List.generate(
          cartItems.length,
          (index) {
            final item = cartItems[index];

            final quantity =
                (item['quantity'] as int?) ?? 1;

            final icon =
                item['icon'] as IconData? ??
                    Icons.auto_awesome_rounded;

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF7DCE9),
                          Color(0xFFE8E0FF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      color: const Color(0xFF7656D8),
                      size: 32,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF29243A),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Digital Template',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['price'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD85C96),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      _quantityButton(
                        icon: Icons.remove,
                        onTap: () {
                          decreaseQuantity(index);
                        },
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: Text(
                          '$quantity',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      _quantityButton(
                        icon: Icons.add,
                        onTap: () {
                          increaseQuantity(index);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(width: 10),

                  IconButton(
                    onPressed: () {
                      _showDeleteDialog(index);
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFFF2EFFA),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 17,
          color: const Color(0xFF7656D8),
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final subtotal = totalPrice;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7656D8),
            Color(0xFFD85C96),
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
            'Order Summary',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 22),

          _summaryRow(
            'Subtotal',
            formatPrice(subtotal),
          ),

          const SizedBox(height: 12),

          _summaryRow(
            'Delivery',
            'Gratis',
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Divider(
              color: Colors.white30,
            ),
          ),

          _summaryRow(
            'Total',
            formatPrice(subtotal),
            isTotal: true,
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _openCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF7656D8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    'Checkout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String title,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(
              isTotal ? 1 : 0.8,
            ),
            fontWeight:
                isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 17 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight:
                isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart(bool isDesktop) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFF7DCE9),
                    Color(0xFFE7E0FF),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: Color(0xFF7656D8),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Keranjang Masih Kosong',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF29243A),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Yuk pilih template digital yang kamu butuhkan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF7656D8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Kembali Belanja',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}