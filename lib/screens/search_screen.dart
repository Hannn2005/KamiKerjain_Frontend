import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';
import '../models/jasa_model.dart';
import '../services/jasa_service.dart';
import '../services/api_client.dart';
import '../widgets/jasa_image.dart';
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
  bool _isLoading = true;
  String? _error;
  Timer? _debounce;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _filterResults();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _filterResults);
  }

  Future<void> _filterResults() async {
    final requestId = ++_requestId;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await JasaService().getAllJasa(
        query: _searchController.text,
        category: _selectedCategory,
      );
      // Abaikan respons lama jika sudah ada pencarian yang lebih baru.
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    }
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
                      });
                      _filterResults();
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!, textAlign: TextAlign.center))
              : _searchResults.isEmpty 
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
                              JasaImage(
                                url: jasa.imageUrl,
                                width: 80,
                                height: 80,
                                iconSize: 30,
                                borderRadius: BorderRadius.circular(8),
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
                                      '${jasa.formattedPriceType} ${formatRupiah(jasa.price)}',
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
