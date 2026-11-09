import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShopliminalApp());
}

class ShopliminalApp extends StatelessWidget {
  const ShopliminalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopliminal - Hỗ trợ kéo tâm iOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E17),
        primaryColor: const Color(0xFF00F0FF),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00F0FF),
          secondary: Color(0xFF7000FF),
        ),
      ),
      home: const ShopliminalDashboard(),
    );
  }
}

class ShopliminalDashboard extends StatefulWidget {
  const ShopliminalDashboard({super.key});

  @override
  State<ShopliminalDashboard> createState() => _ShopliminalDashboardState();
}

class _ShopliminalDashboardState extends State<ShopliminalDashboard> {
  // Trạng thái các module tích hợp
  bool _delayXVpn = true;
  bool _realPingHud = true;
  bool _espCrosshair = true;
  bool _aimLagFreeze = true;
  bool _scopeFreeze = true;
  bool _ghostMode = false;
  bool _worldFreeze = false;
  bool _fps120Boost = true;
  bool _lowLatencyWifi = true;
  bool _socks5Tunnel = true;
  
  double _sensitivity = 85.0;
  String _selectedGame = 'freefireth';

  Future<void> _launchGame() async {
    final String scheme = _selectedGame == 'freefireth' 
        ? 'freefireth://' 
        : 'freefiremax://';
    final Uri uri = Uri.parse(scheme);

    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        _showStatus('Không thể mở trò chơi. Hãy kiểm tra cài đặt.');
      }
    } catch (e) {
      if (mounted) {
        _showStatus('Lỗi khởi chạy: $e');
      }
    }
  }

  void _showStatus(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A2234),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1523),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'SHOPLIMINAL - KÉO TÂM IOS',
          style: TextStyle(
            color: Color(0xFF00F0FF),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 14,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFF00F0FF).withOpacity(0.3),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 20),
            
            _buildSectionTitle('🌐 1. DELAYX & REALPING CORE'),
            const SizedBox(height: 8),
            _buildToggleCard('DelayX Gaming VPN (libdelayxcore.so)', 'Điều tiết độ trễ gói tin UDP', _delayXVpn, (v) => setState(() => _delayXVpn = v)),
            const SizedBox(height: 8),
            _buildToggleCard('RealPing Floating HUD', 'Hiển thị Ping, FPS thời gian thực', _realPingHud, (v) => setState(() => _realPingHud = v)),
            const SizedBox(height: 8),
            _buildToggleCard('ESP Reticle & Crosshair', 'Tâm ngắm ảo định tâm chính xác cao', _espCrosshair, (v) => setState(() => _espCrosshair = v)),
            
            const SizedBox(height: 20),
            _buildSectionTitle('⚡ 2. BDZMOD SUITE (HỖ TRỢ KÉO TÂM)'),
            const SizedBox(height: 8),
            _buildToggleCard('Aim Lag (Fire Auto-Freeze)', 'Ghìm tâm tự động khi xả đạn', _aimLagFreeze, (v) => setState(() => _aimLagFreeze = v)),
            const SizedBox(height: 8),
            _buildToggleCard('Scope Freeze (ADS Stabilizer)', 'Ổn định khi bật ống ngắm', _scopeFreeze, (v) => setState(() => _scopeFreeze = v)),
            const SizedBox(height: 8),
            _buildToggleCard('Ghost Mode (Desync Controller)', 'Xử lý bất đồng bộ hình ảnh đối thủ', _ghostMode, (v) => setState(() => _ghostMode = v)),
            const SizedBox(height: 8),
            _buildToggleCard('World Freeze', 'Khóa gói dữ liệu cục bộ khi cận chiến', _worldFreeze, (v) => setState(() => _worldFreeze = v)),
            const SizedBox(height: 8),
            _buildToggleCard('120Hz Peak FPS Boost', 'Ép tần số quét màn hình tối đa', _fps120Boost, (v) => setState(() => _fps120Boost = v)),
            const SizedBox(height: 8),
            _buildToggleCard('Low-Latency WiFi Lock', 'Khóa driver mạng giảm thiểu delay', _lowLatencyWifi, (v) => setState(() => _lowLatencyWifi = v)),
            
            const SizedBox(height: 16),
            _buildSliderCard(),

            const SizedBox(height: 20),
            _buildSectionTitle('🛡 3. PARAMOD VIP SUITE'),
            const SizedBox(height: 8),
            _buildToggleCard('SOCKS5 Tun2Socks (libhev-socks5-tunnel.so)', 'Định hướng lưu lượng qua cổng 1080', _socks5Tunnel, (v) => setState(() => _socks5Tunnel = v)),

            const SizedBox(height: 24),
            _buildSectionTitle('CHỌN TRÒ CHƠI KHỞI CHẠY'),
            const SizedBox(height: 10),
            _buildGameSelector(),
            const SizedBox(height: 28),
            _buildLaunchButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00F0FF).withOpacity(0.4),
          width: 1.2,
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.gps_fixed, color: Color(0xFF00F0FF), size: 32),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BUNDLE: COM.SHOPLIMINAL.IOS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    letterSpacing: 1.1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Hỗ trợ kéo tâm iOS: Đã kích hoạt module',
                  style: TextStyle(
                    color: Color(0xFF00FF88),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF00F0FF),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildToggleCard(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? const Color(0xFF00F0FF).withOpacity(0.5) : Colors.white10,
        ),
      ),
      child: SwitchListTile(
        activeColor: const Color(0xFF00F0FF),
        dense: true,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSliderCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Hệ số hỗ trợ kéo tâm (Sensitivity)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text('${_sensitivity.toInt()}%', style: const TextStyle(color: Color(0xFF00F0FF), fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: _sensitivity,
            min: 0,
            max: 100,
            activeColor: const Color(0xFF00F0FF),
            inactiveColor: Colors.white10,
            onChanged: (val) => setState(() => _sensitivity = val),
          ),
        ],
      ),
    );
  }

  Widget _buildGameSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildChoiceChip(label: 'Free Fire TH', id: 'freefireth'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildChoiceChip(label: 'Free Fire MAX', id: 'freefiremax'),
        ),
      ],
    );
  }

  Widget _buildChoiceChip({required String label, required String id}) {
    final bool isSelected = _selectedGame == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedGame = id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00F0FF).withOpacity(0.15) : const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF00F0FF) : Colors.white12,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF00F0FF) : Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildLaunchButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00F0FF),
        foregroundColor: const Color(0xFF0A0E17),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
      ),
      onPressed: _launchGame,
      icon: const Icon(Icons.rocket_launch),
      label: const Text(
        'KHỞI CHẠY TRÒ CHƠI',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2),
      ),
    );
  }
}
