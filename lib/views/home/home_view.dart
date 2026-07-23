import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // ==================== ASSETS & DATA ====================
  static const String promoBanner1 = 'assets/images/images.jpg';
  static const String promoBanner2 = 'assets/images/promo_banner2.jpg';
  

  final List<String> carouselImages = [
    promoBanner1,
    promoBanner2,
    
  ];

  // Popular Categories
  final List<Map<String, dynamic>> popularCategories = [
    {'name': 'Electronics', 'icon': Icons.devices, 'color': Colors.blue},
    {'name': 'Fashion', 'icon': Icons.checkroom, 'color': Colors.pink},
    {'name': 'Beauty', 'icon': Icons.face, 'color': Colors.purple},
    {'name': 'Home & Kitchen', 'icon': Icons.home, 'color': Colors.orange},
    {'name': 'Sports', 'icon': Icons.sports_basketball, 'color': Colors.green},
    {'name': 'Books', 'icon': Icons.menu_book, 'color': Colors.brown},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[50],
        title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.black87),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cart clicked')),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarousel(),
            const SizedBox(height: 24),
            _buildPopularCategories(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ==================== WIDGETS ====================

  Widget _buildAppBarTitle() {
    return const Text('SHOPSAGE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87));
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search products...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: const TextStyle(color: Colors.black87),
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Searching for: $value')),
          );
        }
      },
    );
  }

  void _toggleSearch() {
    setState(() {
      if (_isSearching) _searchController.clear();
      _isSearching = !_isSearching;
    });
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 220,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        viewportFraction: 1.0,
      ),
      items: carouselImages.map((imagePath) {
        return Builder(
          builder: (context) => Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 80),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    'Special Offer',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPopularCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Popular Categories',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: popularCategories.length,
            itemBuilder: (context, index) {
              final cat = popularCategories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${cat['name']} clicked')),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          color: (cat['color'] as Color).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          cat['icon'] as IconData,
                          size: 38,
                          color: cat['color'] as Color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(cat['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}