import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlantDisplayScreen extends StatefulWidget {
  const PlantDisplayScreen({super.key});

  @override
  State<PlantDisplayScreen> createState() => _PlantDisplayScreenState();
}

class _PlantDisplayScreenState extends State<PlantDisplayScreen> {
  List<dynamic> _plants = [];
  bool _isLoading = true;
  String? _error;
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchPlants();
  }

  Future<void> _fetchPlants() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
        _currentImageUrl = null;
      });
      
      final url = 'https://api.pexels.com/v1/search?query=plants&per_page=1';
      print('DEBUG: Starting API request to: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'o9CpVjXobuGN3pkdGYCRRapa4ZVnpeShMTp1JDj2KUZ4GLIlhU8SQQOo',
        },
      );

      print('DEBUG: Response status code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('DEBUG: Decoded response data: $data');
        
        if (data['photos'] != null && data['photos'].isNotEmpty) {
          print('DEBUG: Found ${data['photos'].length} photos');
          
          setState(() {
            _plants = data['photos'];
            _currentImageUrl = data['photos'][0]['src']['large']; // Using large size for better quality
            _isLoading = false;
          });
          print('DEBUG: Successfully updated state with ${_plants.length} plants');
        } else {
          print('DEBUG: No photos found in response');
          setState(() {
            _error = 'No images found. Please try again.';
            _isLoading = false;
          });
        }
      } else {
        print('DEBUG: Error response: ${response.body}');
        setState(() {
          _error = 'Failed to load images. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('DEBUG: Exception caught: $e');
      print('DEBUG: Stack trace: $stackTrace');
      setState(() {
        _error = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Nature Gallery',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPlants,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchPlants,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                : _plants.isEmpty
                    ? const Center(child: Text('No images found'))
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _currentImageUrl != null
                                  ? Image.network(
                                      _currentImageUrl!,
                                      fit: BoxFit.cover,
                                      height: 300,
                                      width: double.infinity,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          height: 300,
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        print('DEBUG: Image loading error: $error');
                                        return Container(
                                          height: 300,
                                          color: Colors.grey[200],
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.error, size: 50),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Failed to load image\nTap to retry',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      height: 300,
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Text('No image URL available'),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Photo by ${_plants[0]['photographer']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
} 