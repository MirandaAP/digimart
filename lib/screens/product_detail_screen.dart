import 'package:flutter/material.dart';

import '../cart_data.dart';
import '../models/product_model.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState
    extends State<ProductDetailScreen> {
  bool isFavorite = false;

  ProductModel get product => widget.product;

  String formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )}';
  }

  void addToCart() {
    CartData.addItem(
      name: product.name,
      price: formatPrice(product.price),
      icon: Icons.auto_awesome_rounded,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${product.name} berhasil ditambahkan ke keranjang',
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF6255E7),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'LIHAT',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ),
            );
          },
        ),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 800) {
              return _buildWideLayout();
            }

            return _buildMobileLayout();
          },
        ),
      ),
    );
  }

  Widget _buildWideLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 30,
        ),
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 35),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: _buildProductImage(),
                ),
                const SizedBox(width: 45),
                Expanded(
                  flex: 5,
                  child: _buildProductInformation(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 25),
            _buildProductImage(),
            const SizedBox(height: 25),
            _buildProductInformation(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        _circleButton(
          icon: Icons.arrow_back_rounded,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        const Spacer(),
        const Text(
          'Product Detail',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF29243A),
          ),
        ),
        const Spacer(),
        _circleButton(
          icon: Icons.shopping_bag_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6255E7),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 380,
        maxHeight: 520,
      ),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF2E9FF),
            Color(0xFFE4F5FF),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          product.image,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 90,
                color: Color(0xFF9B91C8),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductInformation() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFEFEAFF),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              product.category,
              style: const TextStyle(
                color: Color(0xFF6255E7),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            product.name,
            style: const TextStyle(
              fontSize: 32,
              height: 1.2,
              fontWeight: FontWeight.bold,
              color: Color(0xFF29243A),
            ),
          ),

          const SizedBox(height: 15),

          Text(
            formatPrice(product.price),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD85C96),
            ),
          ),

          const SizedBox(height: 22),

          Text(
            product.description,
            style: TextStyle(
              fontSize: 15,
              height: 1.7,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 25),

          _buildFeatures(),

          const SizedBox(height: 30),

          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    final features = [
      'Desain modern dan aesthetic',
      'Mudah digunakan dan diedit',
      'Cocok untuk kebutuhan digital',
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F8F2),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 17,
                  color: Color(0xFF32A875),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  feature,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4D4960),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite
                        ? 'Ditambahkan ke favorit'
                        : 'Dihapus dari favorit',
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
            ),
            label: const Text('Favorit'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6255E7),
              side: const BorderSide(
                color: Color(0xFF6255E7),
              ),
              minimumSize: const Size(0, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: addToCart,
            icon: const Icon(
              Icons.shopping_bag_outlined,
            ),
            label: const Text(
              'Add to Cart',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6255E7),
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 54),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}