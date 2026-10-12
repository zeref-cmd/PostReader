import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../main.dart';
import '../widgets/app_background.dart';

class FavoritesScreen extends StatefulWidget { const FavoritesScreen({super.key}); @override State<FavoritesScreen> createState() => _FavoritesScreenState(); }
class _FavoritesScreenState extends State<FavoritesScreen> {
  String feedback = ''; bool feedbackError = false;
  Future<void> editNote(dynamic key, Map post) async {
    final controller = TextEditingController(text: (post['note'] ?? '').toString());
    final result = await showDialog<String>(context: context, builder: (dialogContext) => AlertDialog(backgroundColor: const Color(0xFF10265A), title: const Text('Personal note'), content: TextField(controller: controller, autofocus: true, minLines: 3, maxLines: 5, decoration: const InputDecoration(hintText: 'Write a short note about this post...')), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(dialogContext, controller.text.trim()), child: const Text('Save note'))]));
    controller.dispose(); if (result == null) return;
    try { final updated = Map<String, dynamic>.from(post); updated['note'] = result; await Hive.box('favoritesBox').put(key, updated); if (!mounted) return; setState(() { feedback = 'Personal note updated.'; feedbackError = false; }); }
    catch (_) { if (!mounted) return; setState(() { feedback = 'Unable to update the note. Please try again.'; feedbackError = true; }); }
  }
  Future<void> removeFavorite(dynamic key, Map post) async {
    final yes = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(backgroundColor: const Color(0xFF10265A), title: const Text('Remove favorite?'), content: Text('Remove “${post['title']}” from your saved posts?'), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')), FilledButton(style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD94371)), onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Remove'))]));
    if (yes != true) return;
    try { await Hive.box('favoritesBox').delete(key); if (!mounted) return; setState(() { feedback = 'Favorite removed.'; feedbackError = false; }); }
    catch (_) { if (!mounted) return; setState(() { feedback = 'Unable to remove this favorite.'; feedbackError = true; }); }
  }
  @override Widget build(BuildContext context) {
    final box = Hive.box('favoritesBox');
    return Scaffold(appBar: AppBar(title: const Text('Favorites'), leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)), actions: [IconButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false), icon: const Icon(Icons.home_rounded, color: cyan), tooltip: 'Posts')]),
      body: AppBackground(child: ValueListenableBuilder(valueListenable: box.listenable(), builder: (context, Box<dynamic> favorites, _) {
        final entries = favorites.toMap().entries.toList().reversed.toList();
        return ListView(padding: const EdgeInsets.fromLTRB(16, 5, 16, 24), children: [
          NeonPanel(padding: const EdgeInsets.all(17), borderColor: const Color(0x779B55FF), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Your saved stories', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)), const SizedBox(height: 5), const Text('Your favorites stay on this device.', style: TextStyle(color: textMuted, fontSize: 12)), const SizedBox(height: 11), Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6), decoration: BoxDecoration(color: violet.withOpacity(.3), borderRadius: BorderRadius.circular(20)), child: Text('${entries.length} saved posts', style: const TextStyle(color: textLight, fontWeight: FontWeight.w800, fontSize: 12)))])), const SizedBox(width: 8), const SizedBox(width: 90, height: 88, child: Image(image: AssetImage('assets/images/monsters/purple_bat.png'), fit: BoxFit.contain))])),
          if (feedback.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 12), child: Container(padding: const EdgeInsets.all(11), decoration: BoxDecoration(color: feedbackError ? const Color(0xCC64223B) : const Color(0xCC124D63), borderRadius: BorderRadius.circular(13), border: Border.all(color: feedbackError ? pink : cyan)), child: Text(feedback))),
          const SizedBox(height: 18), const Text('Saved posts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), const SizedBox(height: 12),
          if (entries.isEmpty) NeonPanel(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28), child: Column(children: [const MonsterAvatar(index: 8, size: 100), const SizedBox(height: 12), const Text('No favorites yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), const SizedBox(height: 6), const Text('Open any post and tap Save to Favorites.', textAlign: TextAlign.center, style: TextStyle(color: textMuted)), const SizedBox(height: 14), NeonButton(label: 'Explore posts', icon: Icons.auto_stories_rounded, onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false))]))
          else ...entries.map((entry) {
            final post = Map<String, dynamic>.from(entry.value as Map); final id = int.tryParse('${post['id']}') ?? 1; final note = (post['note'] ?? '').toString();
            return Padding(padding: const EdgeInsets.only(bottom: 11), child: Card(child: Padding(padding: const EdgeInsets.all(11), child: Column(children: [
              Row(children: [MonsterAvatar(index: id - 1, size: 78), const SizedBox(width: 11), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('POST #$id', style: const TextStyle(color: cyan, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text((post['title'] ?? 'Untitled').toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)), const SizedBox(height: 5), Text((post['body'] ?? '').toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: textMuted, fontSize: 11, height: 1.3))])), IconButton(onPressed: () => removeFavorite(entry.key, post), tooltip: 'Delete favorite', icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFFF6687), size: 25))]),
              const SizedBox(height: 9), Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9), decoration: BoxDecoration(color: const Color(0xAA142D68), borderRadius: BorderRadius.circular(13), border: Border.all(color: const Color(0x5535D8FF))), child: Row(children: [const Icon(Icons.sticky_note_2_outlined, size: 17, color: cyan), const SizedBox(width: 8), Expanded(child: Text(note.isEmpty ? 'Add a personal note...' : note, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: textMuted, fontSize: 12))), IconButton(constraints: const BoxConstraints(minWidth: 35, minHeight: 35), padding: EdgeInsets.zero, onPressed: () => editNote(entry.key, post), icon: const Icon(Icons.edit_rounded, color: cyan, size: 19), tooltip: 'Edit note')]))
            ]))));
          }),
        ]);
      })), bottomNavigationBar: const AppBottomNav(selected: 1));
  }
}
