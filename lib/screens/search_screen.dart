import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';
import '../models/jasa_model.dart';
import '../services/jasa_service.dart';
import 'jasa_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> categories = ['Semua', 'Tugas & Akademik', 'Desain & Multimedia', 'Teknologi & IT', 'Penulisan & Konten', 'Jasa Rumah Tangga', 'Les & Bimbingan', 'Lainnya'];
  String _selectedCategory = 'Semua';
  List<JasaModel> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchResults = JasaService().getAllJasa();
    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterResults();
  }
  
  void _filterResults() {
    final query = _searchController.text.toLowerCase();
    List<JasaModel> results = JasaService().getAllJasa();
    
    if (_selectedCategory != 'Semua') {
      results = results.where((jasa) => jasa.category == _selectedCategory).toList();
    }
    
    if (query.isNotEmpty) {
      results = results.where((jasa) => 
        jasa.title.toLowerCase().contains(query) || 
        jasa.description.toLowerCase().contains(query)
      ).toList();
    }
    
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.abuMuda,
      appBar: AppBar(
        backgroundColor: AppColors.biruNavy,
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Cari jasa...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat, style: TextStyle(color: isSelected ? Colors.white : AppColors.biruNavy)),
                    selected: isSelected,
                    selectedColor: AppColors.kuningLogo,
                    checkmarkColor: Colors.white,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = cat;
                        _filterResults();
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty 
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Tidak ada jasa yang ditemukan', style: TextStyle(color: AppColors.abuText)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final jasa = _searchResults[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => JasaDetailScreen(jasa: jasa)));
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.image, color: Colors.grey),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.kuningLogo.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        jasa.category,
                                        style: const TextStyle(fontSize: 10, color: AppColors.biruNavy, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      jasa.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formatRupiah(jasa.price),
                                      style: const TextStyle(color: AppColors.kuningLogo, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 14),
                                        const SizedBox(width: 4),
                                        Text('${jasa.rating} (${jasa.totalReviews})', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
