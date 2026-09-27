import 'package:flutter/material.dart';
import 'package:kami_kerjain/utils/colors.dart';
import 'dart:math';

class AIResumeScreen extends StatefulWidget {
  const AIResumeScreen({Key? key}) : super(key: key);

  @override
  _AIResumeScreenState createState() => _AIResumeScreenState();
}

class _AIResumeScreenState extends State<AIResumeScreen> {
  final _cvController = TextEditingController();
  bool _isAnalyzing = false;
  bool _hasResult = false;
  
  int _score = 0;
  List<String> _strengths = [];
  List<String> _improvements = [];
  String _recommendedCategory = '';

  void _analyzeCV() async {
    if (_cvController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan masukkan teks CV/Resume')));
      return;
    }
    
    setState(() {
      _isAnalyzing = true;
      _hasResult = false;
    });

    // Simulate AI processing delay
    await Future.delayed(const Duration(seconds: 3));

    final text = _cvController.text.toLowerCase();
    
    // Simple mock logic for recommendation
    if (text.contains('design') || text.contains('figma') || text.contains('adobe')) {
      _recommendedCategory = 'Desain & Multimedia';
    } else if (text.contains('code') || text.contains('flutter') || text.contains('developer')) {
      _recommendedCategory = 'Teknologi & IT';
    } else if (text.contains('write') || text.contains('content') || text.contains('artikel')) {
      _recommendedCategory = 'Penulisan & Konten';
    } else {
      _recommendedCategory = 'Tugas & Akademik';
    }

    setState(() {
      _score = 60 + Random().nextInt(36); // Random score 60-95
      _strengths = [
        'Struktur pengalaman kerja tertulis dengan jelas.',
        'Keahlian yang relevan dengan industri disebutkan.',
        'Penyampaian informasi yang rapi.'
      ];
      _improvements = [
        'Tambahkan lebih banyak metrik atau angka pencapaian.',
        'Sertakan sertifikasi terbaru jika ada.'
      ];
      _isAnalyzing = false;
      _hasResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.abuMuda,
      appBar: AppBar(
        title: const Text('AI Reviewer CV', style: TextStyle(color: AppColors.putih)),
        backgroundColor: AppColors.biruNavy,
        iconTheme: const IconThemeData(color: AppColors.putih),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Evaluasi CV & Resume Kamu dengan AI',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.biruNavy),
            ),
            const SizedBox(height: 8),
            const Text(
              'Masukkan teks dari CV kamu atau upload dokumen untuk mendapatkan analisis instan dan rekomendasi kategori jasa.',
              style: TextStyle(color: AppColors.abuText),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _cvController,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Tempel teks CV/Resume kamu di sini...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: AppColors.putih,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Simulasi buka file picker')));
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload File CV (PDF/Word)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isAnalyzing ? null : _analyzeCV,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kuningLogo,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isAnalyzing
                  ? const SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(color: AppColors.biruNavy, strokeWidth: 2),
                    )
                  : const Text('Analisis CV', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.biruNavy)),
            ),
            
            if (_hasResult) ...[
              const SizedBox(height: 32),
              const Divider(color: AppColors.abuText),
              const SizedBox(height: 16),
              const Text('Hasil Analisis AI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.biruNavy)),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: _score >= 80 ? AppColors.hijauSukses : Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('$_score', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.putih)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _score >= 80 ? 'Sangat Baik!' : 'Perlu Peningkatan',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Skor dihitung berdasarkan struktur, keyword, dan relevansi industri.',
                          style: const TextStyle(color: AppColors.abuText, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Card(
                color: AppColors.putih,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: AppColors.hijauSukses),
                          SizedBox(width: 8),
                          Text('Kelebihan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ..._strengths.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(child: Text(s)),
                        ]),
                      )).toList(),
                      
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Area Peningkatan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ..._improvements.map((i) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(child: Text(i)),
                        ]),
                      )).toList(),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.biruMuda,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.biruNavy),
                ),
                child: Column(
                  children: [
                    const Text('Rekomendasi Kategori Jasa:', style: TextStyle(color: AppColors.biruNavy)),
                    const SizedBox(height: 8),
                    Text(_recommendedCategory, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.biruNavy)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to search/jasa screen with category pre-filled
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mencari jasa untuk $_recommendedCategory...')));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.biruNavy),
                      child: const Text('Lihat Rekomendasi Jasa', style: TextStyle(color: AppColors.putih)),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
