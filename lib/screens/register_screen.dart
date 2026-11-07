import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/auth_footer.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Khusus Penyedia Jasa
  final _portfolioController = TextEditingController();
  String? _selectedCategory = 'Teknologi & IT';
  String? _uploadedCvName; // Nama file CV yang diunggah
  
  final List<String> _categories = [
    'Tugas & Akademik',
    'Desain & Multimedia',
    'Teknologi & IT',
    'Penulisan & Konten',
    'Jasa Rumah Tangga',
    'Les & Bimbingan',
    'Lainnya'
  ];

  String _selectedRole = 'customer';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  void _simulateUploadCv() {
    // Simulasi pemilihan file dokumen CV
    setState(() {
      final name = _usernameController.text.trim().isNotEmpty 
          ? _usernameController.text.trim().replaceAll(' ', '_') 
          : 'Mitra';
      _uploadedCvName = 'CV_Portofolio_$name.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berkas "$_uploadedCvName" berhasil dilampirkan!'),
        backgroundColor: AppColors.hijauSukses,
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRole == 'penyedia' && _uploadedCvName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan upload berkas CV / Sertifikat Bukti Pekerjaan terlebih dahulu!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    bool success = false;
    if (_selectedRole == 'penyedia') {
      success = await AuthService().registerPenyedia(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
        category: _selectedCategory ?? 'Lainnya',
        portfolioText: _portfolioController.text.trim(),
        cvFileName: _uploadedCvName ?? 'CV_Dokumen.pdf',
      );
    } else {
      success = await AuthService().register(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _phoneController.text.trim(),
        _selectedRole,
      );
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      if (_selectedRole == 'penyedia') {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Row(
              children: const [
                Icon(Icons.hourglass_bottom, color: Colors.orange, size: 28),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Pendaftaran Diajukan!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.biruNavy)),
                ),
              ],
            ),
            content: const Text(
              'Terima kasih telah mendaftar sebagai mitra KamiKerjain.\n\n'
              'Berkas CV dan portofolio Anda sedang dalam antrean verifikasi oleh Administrator. Akun Anda dapat digunakan setelah mendapatkan persetujuan (ACC) dari Admin.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context); // Kembali ke login
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.biruNavy),
                child: const Text('OK, Mengerti', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan login'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email sudah terdaftar. Gunakan email lain.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPenyedia = _selectedRole == 'penyedia';

    return Scaffold(
      backgroundColor: AppColors.putih,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                      Image.asset('assets/logo.png', height: 70),
                      const SizedBox(height: 12),
                      const Text(
                        'Buat Akun Baru',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.biruNavy,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isPenyedia 
                            ? 'Lengkapi data verifikasi & berkas keahlian mitra'
                            : 'Pilih role dan isi data diri Anda',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Role Selector
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: AppColors.biruNavy, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedRole = 'customer'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _selectedRole == 'customer'
                                          ? AppColors.biruNavy
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 18,
                                          color: _selectedRole == 'customer'
                                              ? AppColors.putih
                                              : AppColors.biruNavy,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Customer',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: _selectedRole == 'customer'
                                                ? AppColors.putih
                                                : AppColors.biruNavy,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedRole = 'penyedia'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _selectedRole == 'penyedia'
                                          ? AppColors.biruNavy
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.handyman,
                                          size: 18,
                                          color: _selectedRole == 'penyedia'
                                              ? AppColors.putih
                                              : AppColors.biruNavy,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Penyedia Jasa',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: _selectedRole == 'penyedia'
                                                ? AppColors.putih
                                                : AppColors.biruNavy,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Basic Info Fields
                      CustomTextField(
                        hintText: isPenyedia ? 'Nama Lengkap / Nama Bisnis' : 'Username',
                        controller: _usernameController,
                        prefixIcon: const Icon(Icons.person_outline, color: AppColors.biruNavy),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          if (value.length < 3) {
                            return 'Nama minimal 3 karakter';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hintText: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined, color: AppColors.biruNavy),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hintText: 'Nomor WhatsApp / HP',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.biruNavy),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor telepon wajib diisi untuk verifikasi';
                          }
                          return null;
                        },
                      ),

                      // KHUSUS PENYEDIA: Form Keahlian & Upload CV
                      if (isPenyedia) ...[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.biruMuda.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.biruNavy.withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.verified_outlined, color: AppColors.biruNavy, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Kualifikasi & Dokumen Mitra',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.biruNavy),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Kategori Bidang Jasa
                              DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                decoration: const InputDecoration(
                                  labelText: 'Bidang Keahlian Utama',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))).toList(),
                                onChanged: (val) => setState(() => _selectedCategory = val),
                              ),
                              const SizedBox(height: 12),

                              // Portofolio / Pengalaman
                              TextFormField(
                                controller: _portfolioController,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: 'Portofolio & Bukti Pengalaman',
                                  hintText: 'Contoh: Berpengalaman 3 tahun mengerjakan servis AC & renovasi, memiliki sertifikat teknisi...',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  alignLabelWithHint: true,
                                ),
                                validator: (val) {
                                  if (isPenyedia && (val == null || val.isEmpty)) {
                                    return 'Jelaskan riwayat pengalaman/portofolio Anda';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // Upload CV Box
                              GestureDetector(
                                onTap: _simulateUploadCv,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: _uploadedCvName != null ? AppColors.hijauSukses : AppColors.biruNavy.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _uploadedCvName != null ? Icons.check_circle : Icons.upload_file,
                                        color: _uploadedCvName != null ? AppColors.hijauSukses : AppColors.biruNavy,
                                        size: 28,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _uploadedCvName ?? 'Unggah Berkas CV / Sertifikat (PDF)',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: _uploadedCvName != null ? AppColors.hijauSukses : AppColors.biruNavy,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              _uploadedCvName != null ? 'Berkas berhasil dilampirkan' : 'Klik untuk memilih file CV/Portofolio',
                                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.biruNavy,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text('Pilih', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Info Alert
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.amber.shade300),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.info_outline, size: 16, color: Colors.amber),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Akun mitra memerlukan persetujuan (ACC) Admin sebelum dapat mulai menjual jasa.',
                                        style: TextStyle(fontSize: 11, color: Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      CustomTextField(
                        hintText: 'Password',
                        isPassword: _obscurePassword,
                        controller: _passwordController,
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.biruNavy),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.biruNavy,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hintText: 'Konfirmasi Password',
                        isPassword: _obscureConfirmPassword,
                        controller: _confirmPasswordController,
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.biruNavy),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.biruNavy,
                          ),
                          onPressed: () {
                            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password tidak boleh kosong';
                          }
                          if (value != _passwordController.text) {
                            return 'Password tidak cocok';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPenyedia ? AppColors.kuningLogo : AppColors.biruNavy,
                              disabledBackgroundColor: AppColors.biruNavy.withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: AppColors.biruNavy,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    isPenyedia ? 'Ajukan Pendaftaran Mitra' : 'Buat Akun Customer',
                                    style: TextStyle(
                                      color: isPenyedia ? AppColors.biruNavy : AppColors.putih,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            AuthFooter(
              text: 'Sudah punya akun?',
              buttonText: 'Login',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
