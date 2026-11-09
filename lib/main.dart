import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShopLiminalApp());
}

class ShopLiminalApp extends StatelessWidget {
  const ShopLiminalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopLiminal iOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E17),
        primaryColor: const Color(0xFF00F0FF),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00F0FF),
          secondary: Color(0xFF7000FF),
        ),
      ),
      home: const LiminalDashboard(),
    );
  }
}

class LiminalDashboard extends StatefulWidget {
  const LiminalDashboard({super.key});

  @override
  State<LiminalDashboard> createState() => _LiminalDashboardState();
}

class _LiminalDashboardState extends State<LiminalDashboard> {
  bool _optimizeNetwork = false;
  bool _touchBoost = false;
  double _sensitivity = 50.0;
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
        _showStatus('Không thể mở ứng dụng. Hãy kiểm tra xem game đã cài đặt chưa.');
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
          'SHOPLIMINAL DASHBOARD',
          style: TextStyle(
            color: Color(0xFF00F0FF),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.8,
            fontSize: 16,
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('CẤU HÌNH TIỆN ÍCH'),
            const SizedBox(height: 12),
            _buildToggleCard(
              title: 'Tối ưu hiển thị khung hình',
              subtitle: 'Đồng bộ hóa tần số quét giao diện',
              value: _optimizeNetwork,
              onChanged: (val) => setState(() => _optimizeNetwork = val),
            ),
            const SizedBox(height: 12),
            _buildToggleCard(
              title: 'Độ nhạy phản hồi cảm ứng',
              subtitle: 'Tùy chỉnh tốc độ nhận diện vuốt màn hình',
              value: _touchBoost,
              onChanged: (val) => setState(() => _touchBoost = val),
            ),
            const SizedBox(height: 16),
            _buildSliderCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('CHỌN PHIÊN BẢN KHỞI CHẠY'),
            const SizedBox(height: 12),
            _buildGameSelector(),
            const SizedBox(height: 32),
            _buildLaunchButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00F0FF).withOpacity(0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F0FF).withOpacity(0.08),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_outlined, color: Color(0xFF00F0FF), size: 36),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BUNDLE: COM.SHOPLIMINAL.IOS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    letterSpacing: 1.1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Trạng thái: Sẵn sàng hoạt động',
                  style: TextStyle(
                    color: Color(0xFF00FF88),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.4,
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: value
              ? const Color(0xFF00F0FF).withOpacity(0.6)
              : Colors.white12,
        ),
      ),
      child: SwitchListTile(
        activeColor: const Color(0xFF00F0FF),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSliderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mức cân chỉnh tâm ảo',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              Text(
                '${_sensitivity.toInt()}%',
                style: const TextStyle(
                  color: Color(0xFF00F0FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
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
          child: _buildChoiceChip(
            label: 'Free Fire TH',
            id: 'freefireth',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildChoiceChip(
            label: 'Free Fire MAX',
            id: 'freefiremax',
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceChip({required String label, required String id}) {
    final bool isSelected = _selectedGame == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedGame = id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00F0FF).withOpacity(0.15) : const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(12),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 8,
      ),
      onPressed: _launchGame,
      icon: const Icon(Icons.rocket_launch),
      label: const Text(
        'KHỞI CHẠY TRÒ CHƠI',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
