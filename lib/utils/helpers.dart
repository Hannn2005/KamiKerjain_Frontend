String formatRupiah(double amount) {
  String result = amount.toStringAsFixed(0);
  final chars = result.split('');
  String formatted = '';
  for (int i = 0; i < chars.length; i++) {
    if (i > 0 && (chars.length - i) % 3 == 0) formatted += '.';
    formatted += chars[i];
  }
  return 'Rp $formatted';
}

String getStatusLabel(String status) {
  switch (status) {
    case 'pending':
      return 'Menunggu';
    case 'accepted':
      return 'Diterima';
    case 'in_progress':
      return 'Berlangsung';
    case 'completed':
      return 'Selesai';
    case 'rejected':
      return 'Ditolak';
    case 'cancelled':
      return 'Dibatalkan';
    default:
      return 'Tidak Diketahui';
  }
}

String formatTanggal(DateTime date) {
  const months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String _dua(int n) => n.toString().padLeft(2, '0');

/// 'HH:mm' untuk hari ini, 'Kemarin', atau 'dd/MM/yyyy'.
String formatWaktuChat(DateTime time) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(time.year, time.month, time.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return '${_dua(time.hour)}:${_dua(time.minute)}';
  if (diff == 1) return 'Kemarin';
  return '${_dua(time.day)}/${_dua(time.month)}/${time.year}';
}

/// Waktu relatif: 'Baru saja', '5 menit yang lalu', '3 jam yang lalu', dst.
String formatWaktuRelatif(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return 'Baru saja';
  if (diff.inMinutes < 60) return '${diff.inMinutes} menit yang lalu';
  if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
  if (diff.inDays < 7) return '${diff.inDays} hari yang lalu';
  return formatTanggal(time);
}
