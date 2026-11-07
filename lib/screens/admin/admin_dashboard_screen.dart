import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';
import '../../utils/routes.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _authService = AuthService();

  List<UserModel> _pendingProviders = [];
  List<UserModel> _approvedProviders = [];
  List<UserModel> _allUsers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  void _loadData() {
    setState(() {
      _pendingProviders = _authService.getPendingProviders();
      _approvedProviders = _authService.getApprovedProviders();
      _allUsers = _authService.getAllUsers();
    });
  }

  void _showApproveDialog(UserModel provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Setujui Calon Penyedia?', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.biruNavy)),
        content: Text(
          'Apakah Anda yakin ingin menyetujui akun "${provider.username}" sebagai Penyedia Jasa resmi KamiKerjain?\n\n'
          'Setelah disetujui, mitra dapat langsung login dan mempublikasikan layanan jasanya.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppColors.abuText)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _authService.approveProvider(provider.id);
              _loadData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Akun mitra "${provider.username}" BERHASIL DISETUJUI!'),
                  backgroundColor: AppColors.hijauSukses,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.hijauSukses),
            child: const Text('Setujui (Approve)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(UserModel provider) {
    final reasonController = TextEditingController(text: 'Dokumen CV / Portofolio belum memenuhi standar kualifikasi.');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tolak Pendaftaran Mitra', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.merahError)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tulis alasan penolakan untuk "${provider.username}":', style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 10),
              TextFormField(
                controller: reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Alasan Penolakan',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Alasan wajib diisi' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppColors.abuText)),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx);
                _authService.rejectProvider(provider.id, reasonController.text.trim());
                _loadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Pendaftaran mitra "${provider.username}" telah ditolak.'),
                    backgroundColor: AppColors.merahError,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.merahError),
            child: const Text('Tolak Pendaftaran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDocumentPreview(UserModel provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.picture_as_pdf, color: Colors.red),
            SizedBox(width: 8),
            Text('Verifikasi Dokumen CV', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.biruNavy)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama Berkas: ${provider.cvFileName ?? "CV_Dokumen.pdf"}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Kategori: ${provider.category ?? "Umum"}'),
            const SizedBox(height: 8),
            const Text('Portofolio & Riwayat Pengalaman:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.abuMuda,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                provider.portfolioText ?? 'Tidak ada deskripsi portofolio yang dilampirkan.',
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.green.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user, color: Colors.green, size: 16),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Telah terunggah & siap diverifikasi oleh Administrator.',
                      style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup', style: TextStyle(color: AppColors.biruNavy)),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    _authService.logout();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.abuMuda,
      appBar: AppBar(
        title: const Text('Panel Administrator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.biruNavy,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout Admin',
            onPressed: _handleLogout,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.kuningLogo,
          labelColor: AppColors.kuningLogo,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Verifikasi'),
                  if (_pendingProviders.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.red,
                      child: Text(
                        _pendingProviders.length.toString(),
                        style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(text: 'Mitra Aktif'),
            const Tab(text: 'Semua User'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stat summary banner
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                _buildStatItem('Menunggu Verifikasi', _pendingProviders.length.toString(), Colors.orange),
                _buildStatItem('Mitra Terdaftar', _approvedProviders.length.toString(), AppColors.hijauSukses),
                _buildStatItem('Total Pengguna', _allUsers.length.toString(), AppColors.biruNavy),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPendingTab(),
                _buildApprovedTab(),
                _buildAllUsersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppColors.abuText)),
        ],
      ),
    );
  }

  // TAB 1: PENDING PROVIDERS
  Widget _buildPendingTab() {
    if (_pendingProviders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle_outline, size: 64, color: AppColors.hijauSukses),
            SizedBox(height: 12),
            Text('Semua Pengajuan Telah Ditinjau!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 4),
            Text('Tidak ada calon penyedia jasa yang menunggu verifikasi.', style: TextStyle(color: AppColors.abuText, fontSize: 13)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pendingProviders.length,
      itemBuilder: (context, index) {
        final provider = _pendingProviders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        provider.username,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.biruNavy),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Menunggu ACC', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Email: ${provider.email} • Telp: ${provider.phone}', style: const TextStyle(color: AppColors.abuText, fontSize: 12)),
                const SizedBox(height: 8),

                // Kategori
                Row(
                  children: [
                    const Icon(Icons.category_outlined, size: 16, color: AppColors.biruNavy),
                    const SizedBox(width: 6),
                    Text(
                      'Bidang: ${provider.category ?? "Umum"}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.biruNavy),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Portofolio Box
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.abuMuda,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Portofolio & Pengalaman Kerja:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.biruNavy)),
                      const SizedBox(height: 4),
                      Text(
                        provider.portfolioText ?? 'Tidak dicantumkan.',
                        style: const TextStyle(fontSize: 12, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // CV Document Button
                OutlinedButton.icon(
                  onPressed: () => _showDocumentPreview(provider),
                  icon: const Icon(Icons.attach_file, size: 16, color: AppColors.biruNavy),
                  label: Text('Lampiran: ${provider.cvFileName ?? "CV_Berkas.pdf"}', style: const TextStyle(fontSize: 12, color: AppColors.biruNavy)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.biruNavy),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),

                // Actions: Reject & Approve
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => _showRejectDialog(provider),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.merahError),
                      child: const Text('Tolak'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _showApproveDialog(provider),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.hijauSukses),
                      child: const Text('Setujui Akun (ACC)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // TAB 2: APPROVED PROVIDERS
  Widget _buildApprovedTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _approvedProviders.length,
      itemBuilder: (context, index) {
        final p = _approvedProviders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.kuningLogo,
              child: Text(
                p.username.isNotEmpty ? p.username[0].toUpperCase() : 'M',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.biruNavy),
              ),
            ),
            title: Text(p.username, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${p.category ?? "Penyedia Jasa"} • ${p.email}'),
            trailing: const Chip(
              label: Text('Aktif', style: TextStyle(color: Colors.white, fontSize: 11)),
              backgroundColor: AppColors.hijauSukses,
              visualDensity: VisualDensity.compact,
            ),
          ),
        );
      },
    );
  }

  // TAB 3: ALL USERS
  Widget _buildAllUsersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _allUsers.length,
      itemBuilder: (context, index) {
        final u = _allUsers[index];
        Color roleColor = Colors.grey;
        if (u.role == 'admin') roleColor = Colors.purple;
        if (u.role == 'penyedia') roleColor = AppColors.biruNavy;
        if (u.role == 'customer') roleColor = AppColors.kuningLogo;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(u.username, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${u.email} • Status: ${u.status.toUpperCase()}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: roleColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                u.role.toUpperCase(),
                style: TextStyle(color: roleColor, fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
          ),
        );
      },
    );
  }
}
