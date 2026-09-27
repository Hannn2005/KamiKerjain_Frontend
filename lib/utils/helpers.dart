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
