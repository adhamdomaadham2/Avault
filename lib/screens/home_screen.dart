import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart' hide FileType;
import 'package:file_picker/file_picker.dart' as fp show FileType;
import 'package:permission_handler/permission_handler.dart';
import '../services/vault_service.dart';
import '../models/vault_file.dart';
import 'gallery_screen.dart';
import 'files_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  bool _importing = false;

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final vault = VaultService.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الخزنة الآمنة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _importing ? null : _pickAndHideFiles,
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(Icons.insert_drive_file_outlined, 'ملفات', vault.files.length.toString()),
                Container(width: 1, height: 30, color: Colors.white24),
                _buildStat(Icons.photo_outlined, 'صور', vault.getImages().length.toString()),
                Container(width: 1, height: 30, color: Colors.white24),
                _buildStat(Icons.videocam_outlined, 'فيديو', vault.getVideos().length.toString()),
                Container(width: 1, height: 30, color: Colors.white24),
                _buildStat(Icons.storage_outlined, 'حجم', vault.totalSizeFormatted),
              ],
            ),
          ),

          // Tab bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTab(0, Icons.photo_library_outlined, 'صور'),
                const SizedBox(width: 8),
                _buildTab(1, Icons.videocam_outlined, 'فيديوهات'),
                const SizedBox(width: 8),
                _buildTab(2, Icons.folder_outlined, 'ملفات'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(child: _buildContent()),
        ],
      ),
      floatingActionButton: _importing
          ? const FloatingActionButton(
              onPressed: null,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : FloatingActionButton.extended(
              onPressed: _pickAndHideFiles,
              icon: const Icon(Icons.add),
              label: const Text('إخفاء ملفات'),
            ),
    );
  }

  Widget _buildTab(int index, IconData icon, String label) {
    final selected = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? Colors.white : Colors.white54),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white54,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }

  Widget _buildContent() {
    switch (_currentTab) {
      case 0:
        return GalleryScreen(files: VaultService.instance.getImages(), onRefresh: _refresh);
      case 1:
        return GalleryScreen(files: VaultService.instance.getVideos(), onRefresh: _refresh, isVideos: true);
      case 2:
        return FilesScreen(
          files: VaultService.instance.files
              .where((f) => f.type != FileType.image && f.type != FileType.video)
              .toList(),
          onRefresh: _refresh,
        );
      default:
        return const SizedBox();
    }
  }

  Future<void> _pickAndHideFiles() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('محتاج إذن للوصول للملفات')),
        );
      }
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: fp.FileType.any,
    );

    if (result == null || result.files.isEmpty) return;

    setState(() => _importing = true);

    int success = 0;
    for (final file in result.files) {
      if (file.path == null) continue;
      try {
        await VaultService.instance.hideFile(file.path!);
        success++;
      } catch (e) {
        debugPrint('Failed to hide ${file.name}: $e');
      }
    }

    if (mounted) {
      setState(() => _importing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success > 0 ? 'تم إخفاء $success ملف ✓' : 'فشل إخفاء الملفات'),
          backgroundColor: success > 0 ? Colors.green.shade700 : Colors.red.shade700,
        ),
      );
    }
  }
}
