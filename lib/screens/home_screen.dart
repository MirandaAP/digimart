import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/product_data.dart';
import 'about_developer_screen.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _templatesKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  String searchQuery = '';
  bool showFavoritesOnly = false;

  final Set<String> favoriteProducts = {};

  final Color pink = const Color(0xFFD85C96);
  final Color purple = const Color(0xFF7656D8);
  final Color blue = const Color(0xFF4BB9D5);
  final Color darkText = const Color(0xFF29243A);
  final Color background = const Color(0xFFF8F7FF);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  void _openAbout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AboutDeveloperScreen(),
      ),
    );
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CartScreen(),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void _showSearchDialog() {
    final controller = TextEditingController(
      text: searchQuery,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Cari Template',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Cari produk...',
              prefixIcon: const Icon(
                Icons.search_rounded,
              ),
              filled: true,
              fillColor: background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (_) {
              setState(() {
                searchQuery = controller.text.trim();
              });

              Navigator.pop(dialogContext);
              _scrollTo(_templatesKey);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  color: purple,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  searchQuery = controller.text.trim();
                });

                Navigator.pop(dialogContext);
                _scrollTo(_templatesKey);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Cari'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // FILTER
  // ============================================================

  List<ProductModel> get filteredProducts {
    return ProductData.products.where((product) {
      final matchesSearch =
          searchQuery.isEmpty ||
          product.name.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
          product.category.toLowerCase().contains(
                searchQuery.toLowerCase(),
              );

      final matchesFavorite =
          !showFavoritesOnly ||
          favoriteProducts.contains(product.id);

      return matchesSearch && matchesFavorite;
    }).toList();
  }

  void _toggleFavorite(ProductModel product) {
    setState(() {
      if (favoriteProducts.contains(product.id)) {
        favoriteProducts.remove(product.id);
      } else {
        favoriteProducts.add(product.id);
      }
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildNavbar(isDesktop),
                _buildHero(isDesktop),
                _buildCategories(isDesktop),
                _buildTemplatesSection(isDesktop),
                _buildWhyDigiMart(isDesktop),
                _buildContactSection(isDesktop),
                _buildFooter(isDesktop),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // NAVBAR
  // ============================================================

  Widget _buildNavbar(bool isDesktop) {
    if (isDesktop) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildLogo(),

            const Spacer(),

            _navText(
              'Home',
              _scrollToTop,
            ),

            const SizedBox(width: 30),

            _navText(
              'Templates',
              () => _scrollTo(_templatesKey),
            ),

            const SizedBox(width: 30),

            _navText(
              'About',
              _openAbout,
            ),

            const SizedBox(width: 30),

            _navText(
              'Contact',
              () => _scrollTo(_contactKey),
            ),

            const SizedBox(width: 35),

            _iconButton(
              Icons.search_rounded,
              _showSearchDialog,
            ),

            const SizedBox(width: 8),

            _iconButton(
              showFavoritesOnly
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              () {
                setState(() {
                  showFavoritesOnly = !showFavoritesOnly;
                });

                _scrollTo(_templatesKey);
              },
              active: showFavoritesOnly,
            ),

            const SizedBox(width: 8),

            _iconButton(
              Icons.shopping_bag_outlined,
              _openCart,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      color: Colors.white,
      child: Row(
        children: [
          _buildLogo(),

          const Spacer(),

          _iconButton(
            Icons.search_rounded,
            _showSearchDialog,
          ),

          const SizedBox(width: 5),

          _iconButton(
            Icons.shopping_bag_outlined,
            _openCart,
          ),

          const SizedBox(width: 5),

          PopupMenuButton<String>(
            icon: Icon(
              Icons.menu_rounded,
              color: darkText,
            ),
            onSelected: (value) {
              if (value == 'home') {
                _scrollToTop();
              } else if (value == 'templates') {
                _scrollTo(_templatesKey);
              } else if (value == 'about') {
                _openAbout();
              } else if (value == 'contact') {
                _scrollTo(_contactKey);
              } else if (value == 'favorite') {
                setState(() {
                  showFavoritesOnly = !showFavoritesOnly;
                });

                _scrollTo(_templatesKey);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'home',
                child: Text('Home'),
              ),
              PopupMenuItem(
                value: 'templates',
                child: Text('Templates'),
              ),
              PopupMenuItem(
                value: 'favorite',
                child: Text('Favourite'),
              ),
              PopupMenuItem(
                value: 'about',
                child: Text('About'),
              ),
              PopupMenuItem(
                value: 'contact',
                child: Text('Contact'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return GestureDetector(
      onTap: _scrollToTop,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  pink,
                  purple,
                ],
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'DIGIMART',
            style: TextStyle(
              color: darkText,
              fontSize: 19,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navText(
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 8,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: darkText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _iconButton(
    IconData icon,
    VoidCallback onTap, {
    bool active = false,
  }) {
    return Material(
      color: active
          ? pink.withValues(alpha: 0.10)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: active ? pink : darkText,
            size: 21,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _buildHero(bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 70 : 25,
        vertical: isDesktop ? 75 : 45,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFF4FA),
            const Color(0xFFF3F0FF),
            const Color(0xFFEEF9FC),
          ],
        ),
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _buildHeroText(),
                ),
                const SizedBox(width: 40),
                Expanded(
                  flex: 5,
                  child: _buildHeroPreview(),
                ),
              ],
            )
          : Column(
              children: [
                _buildHeroText(),
                const SizedBox(height: 40),
                _buildHeroPreview(),
              ],
            ),
    );
  }

  Widget _buildHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: pink.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            'DIGITAL TEMPLATES',
            style: TextStyle(
              color: pink,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),

        const SizedBox(height: 22),

        Text(
          'Make Your Ideas\nLook More Amazing.',
          style: TextStyle(
            color: darkText,
            fontSize: 46,
            height: 1.08,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'Temukan berbagai template digital aesthetic '
          'dan modern untuk kebutuhan kuliah, bisnis, '
          'social media, hingga produktivitas.',
          style: TextStyle(
            color: darkText.withValues(alpha: 0.65),
            fontSize: 16,
            height: 1.7,
          ),
        ),

        const SizedBox(height: 30),

        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                _scrollTo(_templatesKey);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Explore Templates',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 19,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            OutlinedButton(
              onPressed: _openAbout,
              style: OutlinedButton.styleFrom(
                foregroundColor: purple,
                side: BorderSide(
                  color: purple.withValues(alpha: 0.35),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'About Me',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // 3 FOTO HERO - BAGIAN YANG DIPERBAIKI
  // ============================================================

  Widget _buildHeroPreview() {
    final products = ProductData.products;

    return SizedBox(
      height: 390,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // FOTO PRODUK KIRI
          Positioned(
            left: 5,
            top: 75,
            child: Transform.rotate(
              angle: -0.055,
              child: _smallPreviewCard(
                products[1],
              ),
            ),
          ),

          // FOTO PRODUK KANAN
          Positioned(
            right: 5,
            top: 60,
            child: Transform.rotate(
              angle: 0.055,
              child: _smallPreviewCard(
                products[2],
              ),
            ),
          ),

          // FOTO PRODUK UTAMA
          Positioned(
            top: 15,
            child: _mainPreviewCard(
              products[0],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainPreviewCard(
    ProductModel product,
  ) {
    return Container(
      width: 225,
      height: 305,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.16),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(
          product.image,
          fit: BoxFit.cover,
          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return Container(
              color: const Color(0xFFF1EEFA),
              child: Icon(
                Icons.image_not_supported_rounded,
                color: purple,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _smallPreviewCard(
    ProductModel product,
  ) {
    return Container(
      width: 125,
      height: 170,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          product.image,
          fit: BoxFit.cover,
          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return Container(
              color: const Color(0xFFF1EEFA),
              child: Icon(
                Icons.image_not_supported_rounded,
                color: purple,
                size: 32,
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORIES
  // ============================================================

  Widget _buildCategories(bool isDesktop) {
    final categories = [
      {
        'title': 'Social Media',
        'icon': Icons.camera_alt_outlined,
      },
      {
        'title': 'CV & Resume',
        'icon': Icons.description_outlined,
      },
      {
        'title': 'Planner',
        'icon': Icons.calendar_month_outlined,
      },
      {
        'title': 'Presentation',
        'icon': Icons.slideshow_outlined,
      },
      {
        'title': 'Business',
        'icon': Icons.business_center_outlined,
      },
      {
        'title': 'Study',
        'icon': Icons.menu_book_outlined,
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 70 : 20,
        vertical: 55,
      ),
      child: Column(
        children: [
          Text(
            'Browse by Category',
            style: TextStyle(
              color: darkText,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Pilih template sesuai kebutuhanmu.',
            style: TextStyle(
              color: darkText.withValues(alpha: 0.55),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 30),

          Wrap(
            spacing: 14,
            runSpacing: 14,
            alignment: WrapAlignment.center,
            children: categories.map((category) {
              return InkWell(
                onTap: () {
                  setState(() {
                    searchQuery =
                        category['title'] as String;
                  });

                  _scrollTo(_templatesKey);
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 160,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: purple.withValues(alpha: 0.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            purple.withValues(alpha: 0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        category['icon'] as IconData,
                        color: purple,
                        size: 28,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        category['title'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: darkText,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TEMPLATES
  // ============================================================

  Widget _buildTemplatesSection(bool isDesktop) {
    final products = filteredProducts;

    return Container(
      key: _templatesKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 70 : 20,
        vertical: 60,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  'Explore Templates',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Template digital yang siap digunakan.',
                  style: TextStyle(
                    color:
                        darkText.withValues(alpha: 0.55),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search templates...',
                      prefixIcon: Icon(
                        Icons.search_rounded,
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: showFavoritesOnly
                      ? pink
                      : background,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      showFavoritesOnly =
                          !showFavoritesOnly;
                    });
                  },
                  icon: Icon(
                    showFavoritesOnly
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: showFavoritesOnly
                        ? Colors.white
                        : pink,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          if (products.isEmpty)
            _buildEmptySearch()
          else
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount;

                if (constraints.maxWidth >= 1100) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth >= 700) {
                  crossAxisCount = 2;
                } else {
                  crossAxisCount = 1;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredProducts.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    return _buildProductCard(product);
                  },
                );
              },
            )
        ],
      ),
    );
  }

  Widget _buildEmptySearch() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 60,
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 65,
            color: purple.withValues(alpha: 0.35),
          ),

          const SizedBox(height: 15),

          Text(
            'Template tidak ditemukan',
            style: TextStyle(
              color: darkText,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Coba gunakan kata kunci lainnya.',
            style: TextStyle(
              color: darkText.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    ProductModel product,
  ) {
    final isFavorite =
        favoriteProducts.contains(product.id);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
              product: product,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: purple.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: purple.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Image.asset(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return Container(
                            color: const Color(0xFFF1EEFA),
                            child: Center(
                              child: Icon(
                                Icons
                                    .image_not_supported_rounded,
                                color: purple,
                                size: 45,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Positioned(
                    top: 12,
                    right: 12,
                    child: Material(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          _toggleFavorite(product);
                        },
                        borderRadius:
                            BorderRadius.circular(12),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(9),
                          child: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons
                                    .favorite_border_rounded,
                            color: isFavorite
                                ? pink
                                : darkText,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                14,
                16,
                16,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category,
                    style: TextStyle(
                      color: pink,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: darkText,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Text(
                        'Rp${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: purple,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding:
                            const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: purple.withValues(
                            alpha: 0.08,
                          ),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: purple,
                          size: 17,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // WHY DIGIMART
  // ============================================================

  Widget _buildWhyDigiMart(bool isDesktop) {
    final features = [
      {
        'icon': Icons.auto_awesome_rounded,
        'title': 'Modern Design',
        'description':
            'Template dibuat dengan desain modern dan aesthetic.',
      },
      {
        'icon': Icons.bolt_rounded,
        'title': 'Ready to Use',
        'description':
            'Template siap digunakan dan mudah disesuaikan.',
      },
      {
        'icon': Icons.devices_rounded,
        'title': 'Flexible',
        'description':
            'Cocok untuk kebutuhan kuliah, bisnis, maupun personal.',
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 70 : 20,
        vertical: 70,
      ),
      child: Column(
        children: [
          Text(
            'Why DigiMart?',
            style: TextStyle(
              color: darkText,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Kenapa memilih template dari DigiMart?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkText.withValues(alpha: 0.55),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 35),

          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 800) {
                return Row(
                  children: features.map((feature) {
                    return Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: _featureCard(feature),
                      ),
                    );
                  }).toList(),
                );
              }

              return Column(
                children: features.map((feature) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15),
                    child: _featureCard(feature),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _featureCard(
    Map<String, dynamic> feature,
  ) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: purple.withValues(alpha: 0.07),
        ),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  pink.withValues(alpha: 0.15),
                  purple.withValues(alpha: 0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              feature['icon'] as IconData,
              color: purple,
              size: 28,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            feature['title'] as String,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkText,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            feature['description'] as String,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkText.withValues(alpha: 0.58),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTACT
  // ============================================================

  Widget _buildContactSection(bool isDesktop) {
    return Container(
      key: _contactKey,
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: isDesktop ? 70 : 20,
        vertical: 30,
      ),
      padding: EdgeInsets.all(
        isDesktop ? 50 : 30,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            purple,
            pink,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(
                  child: _contactText(),
                ),
                _contactButtons(),
              ],
            )
          : Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _contactText(),
                const SizedBox(height: 25),
                _contactButtons(),
              ],
            ),
    );
  }

  Widget _contactText() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Let’s Create Something\nAmazing Together.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            height: 1.15,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'Punya pertanyaan atau ingin menghubungi developer?',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.82),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _contactButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _contactButton(
          Icons.camera_alt_outlined,
          'Instagram',
          _showInstagram,
        ),

        const SizedBox(width: 10),

        _contactButton(
          Icons.email_outlined,
          'Email',
          _showEmail,
        ),
      ],
    );
  }

  Widget _contactButton(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 18,
      ),
      label: Text(title),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(
          color: Colors.white.withValues(alpha: 0.45),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ============================================================
  // CONTACT DIALOG
  // ============================================================

  void _showInstagram() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Instagram',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            '@joismrnda',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Tutup',
                style: TextStyle(
                  color: purple,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEmail() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Contact',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Email: joismiranda023@gmail.com',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Tutup',
                style: TextStyle(
                  color: purple,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

    // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooter(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF29243A),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 70 : 25,
        vertical: 35,
      ),
      child: isDesktop
          ? Row(
              children: [
                const Text(
                  'DIGIMART',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),

                const Spacer(),

                Text(
                  'Digital Templates • Made with Flutter',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 12,
                  ),
                ),
              ],
            )
          : Column(
              children: [
                const Text(
                  'DIGIMART',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Digital Templates • Made with Flutter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
    );
  }
}