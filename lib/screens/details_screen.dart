import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../main.dart';
import '../widgets/app_background.dart';

class DetailsScreen extends StatefulWidget { const DetailsScreen({super.key}); @override State<DetailsScreen> createState() => _DetailsScreenState(); }
class _DetailsScreenState extends State<DetailsScreen> {
  String message = ''; bool messageError = false;
  Future<void> save(Map<String, dynamic> post) async {
    final box = Hive.box('favoritesBox'); final key = post['id'];
    if (box.containsKey(key)) { setState(() { message = 'This post is already in your Favorites.'; messageError = false; }); return; }
    try { await box.put(key, {...post, 'note': ''}); if (!mounted) return; setState(() { message = 'Saved to Favorites! Your post is stored on this device.'; messageError = false; }); }
    catch (_) { if (!mounted) return; setState(() { message = 'Could not save this post. Please try again.'; messageError = true; }); }
  }
  @override Widget build(BuildContext context) {
    final args = Map<String, dynamic>.from(ModalRoute.of(context)!.settings.arguments as Map);
    final id = args['id']; final title = (args['title'] ?? 'Untitled post').toString(); final body = (args['body'] ?? '').toString();
    return Scaffold(appBar: AppBar(title: const Text('Post Details'), leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)), actions: [IconButton(onPressed: () => Navigator.pushNamed(context, '/favorites'), icon: const Icon(Icons.favorite_border_rounded, color: pink), tooltip: 'Favorites')]),
      body: AppBackground(child: ListView(padding: const EdgeInsets.fromLTRB(18, 4, 18, 26), children: [
        Container(height: 220, decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), border: Border.all(color: cyan.withOpacity(.6)), boxShadow: [BoxShadow(color: cyan.withOpacity(.12), blurRadius: 20)]), clipBehavior: Clip.antiAlias, child: Stack(fit: StackFit.expand, children: [Image.asset('assets/images/fantasy_background.jpg', fit: BoxFit.cover), Container(color: night.withOpacity(.22)), Center(child: MonsterAvatar(index: ((int.tryParse('$id')) ?? 1) - 1, size: 150))])),
        const SizedBox(height: 18), NeonPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Text('POST #$id', style: const TextStyle(color: cyan, letterSpacing: 1.2, fontWeight: FontWeight.w900)), const Spacer(), const Icon(Icons.auto_awesome, color: violet, size: 19), const SizedBox(width: 5), const Text('STORY', style: TextStyle(color: textMuted, fontSize: 11, fontWeight: FontWeight.w800))]),
          const SizedBox(height: 10), Text(title, style: const TextStyle(fontSize: 25, height: 1.12, fontWeight: FontWeight.w900)), const SizedBox(height: 15),
          Row(children: [const CircleAvatar(backgroundColor: Color(0xFF264D96), child: Icon(Icons.person_rounded, color: cyan)), const SizedBox(width: 9), Text('User ${args['userId'] ?? 1}', style: const TextStyle(fontWeight: FontWeight.w700)), const Spacer(), const Icon(Icons.menu_book_rounded, color: cyan, size: 18), const SizedBox(width: 5), const Text('Reading time · 2 min', style: TextStyle(color: textMuted, fontSize: 11))]),
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(color: Color(0x5535D8FF))),
          Text(body, style: const TextStyle(fontSize: 16, height: 1.75, color: Color(0xFFE0E8FF))),
          const SizedBox(height: 18), Wrap(spacing: 8, runSpacing: 8, children: ['Discover','Stories','Community'].map((s) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(color: violet.withOpacity(.25), borderRadius: BorderRadius.circular(20), border: Border.all(color: violet.withOpacity(.5))), child: Text(s, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)))).toList()),
        ])),
        const SizedBox(height: 14), if (message.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 12), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: messageError ? const Color(0xCC64223B) : const Color(0xCC124D63), borderRadius: BorderRadius.circular(14), border: Border.all(color: messageError ? pink : cyan)), child: Text(message))),
        NeonButton(label: 'Save to Favorites', icon: Icons.favorite_rounded, onPressed: () => save(args), gradient: const [Color(0xFF9D48FF), Color(0xFF315CFF), Color(0xFF21BFFF)]),
      ])), bottomNavigationBar: const AppBottomNav(selected: 0));
  }
}
