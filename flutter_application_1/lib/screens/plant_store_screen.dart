import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/plant.dart';
import '../providers/cart_provider.dart';
import '../data/plant_data.dart';
import 'plant_details_screen.dart';
import 'cart_screen.dart';

class PlantStoreScreen extends StatefulWidget {
  const PlantStoreScreen({super.key});

  @override
  State<PlantStoreScreen> createState() => _PlantStoreScreenState();
}

class _PlantStoreScreenState extends State<PlantStoreScreen> {
  String _selectedCategory = 'All';
  
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'All',
      'icon': Icons.category,
      'color': Color(0xFF2E7D32),
    },
    {
      'name': 'Indoor',
      'icon': Icons.home,
      'color': Color(0xFF1976D2),
    },
    {
      'name': 'Outdoor',
      'icon': Icons.landscape,
      'color': Color(0xFFF57C00),
    },
    {
      'name': 'Succulents',
      'icon': Icons.spa,
      'color': Color(0xFF7B1FA2),
    },
    {
      'name': 'Flowering',
      'icon': Icons.local_florist,
      'color': Color(0xFFC2185B),
    },
    {
      'name': 'Herbs',
      'icon': Icons.eco,
      'color': Color(0xFF00796B),
    },
  ];

  List<Plant> get _filteredPlants {
    if (_selectedCategory == 'All') {
      return plants;
    }
    return plants.where((plant) => plant.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFF1F8E9).withOpacity(0.8),
              Color(0xFFE8F5E9).withOpacity(0.9),
              Color(0xFFC8E6C9).withOpacity(0.7),
            ],
            stops: const [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative elements
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF81C784).withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF4CAF50).withOpacity(0.1),
                ),
              ),
            ),
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.white.withOpacity(0.9),
                  elevation: 0,
                  title: Text(
                    'Plant Barn',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 10, 12, 10),
                    ),
                  ),
                  actions: [
                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return Stack(
                          children: [
                            IconButton(
                              icon: Icon(Icons.shopping_cart_outlined, 
                                color: Color(0xFF2E7D32)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CartScreen()),
                                );
                              },
                            ),
                            if (cart.itemCount > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2E7D32),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '${cart.itemCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catergories',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 33, 33, 33),
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              final category = _categories[index];
                              final isSelected = category['name'] == _selectedCategory;
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = category['name'];
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: isSelected 
                                              ? category['color'].withOpacity(0.2)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            color: isSelected 
                                                ? category['color']
                                                : Colors.grey[200]!,
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          category['icon'],
                                          color: isSelected 
                                              ? category['color']
                                              : Colors.grey[600],
                                          size: 30,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        category['name'],
                                        style: TextStyle(
                                          color: isSelected 
                                              ? category['color']
                                              : Colors.grey[600],
                                          fontWeight: isSelected 
                                              ? FontWeight.bold 
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                     
                        if (_selectedCategory == 'All')
                          const SizedBox(height: 0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: MasonryGridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            itemCount: _filteredPlants.length,
                            itemBuilder: (context, index) {
                              final plant = _filteredPlants[index];
                              return PlantCard(plant: plant);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final Plant plant;

  const PlantCard({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailsScreen(plant: plant),
          ),
        );
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      plant.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.error_outline, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
                  if (plant.isNew)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 214, 251, 0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'New',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plant.category,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${plant.price.toStringAsFixed(2)}',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 40, 40, 40),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_shopping_cart_outlined,
                          color: Color(0xFF8B4513)),
                        onPressed: () {
                          Provider.of<CartProvider>(context, listen: false)
                              .addItem(plant);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${plant.name} added to cart'),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
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
} 