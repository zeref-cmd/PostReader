import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../widgets/app_background.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});
  @override State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Map<String, dynamic>> posts = [];
  bool loading = true;
  String errorMessage = '';
  String feedback = '';
  bool feedbackError = false;
  String search = '';

  @override void initState() { super.initState(); fetchPosts(); }

  Future<void> fetchPosts() async {
    setState(() { loading = true; errorMessage = ''; });
    try {
      final response = await http.get(Uri.parse('https://6acca26cb406cb8ec0c61c55.mockapi.io/posts')).timeout(const Duration(seconds: 18));
      if (response.statusCode != 200) throw Exception('Server returned ${response.statusCode}');
      final data = jsonDecode(response.body) as List<dynamic>;
      if (!mounted) return;
      setState(() { posts = data.map((item) => Map<String, dynamic>.from(item as Map)).toList(); loading = false; });
    } catch (_) {
      if (!mounted) return;
      setState(() { loading = false; errorMessage = 'Could not load posts. Check your internet connection, then try again.'; });
    }
  }

  List<Map<String, dynamic>> get filtered => posts.where((p) {
    final q = search.toLowerCase().trim();
    return q.isEmpty || '${p['title']} ${p['body']}'.toLowerCase().contains(q);
  }).toList();

  Future<void> showCreateDialog() async {
    final title = TextEditingController(); final body = TextEditingController(); String validation = '';
    await showDialog<void>(context: context, builder: (dialogContext) => StatefulBuilder(builder: (context, setDialogState) => AlertDialog(
      backgroundColor: const Color(0xFF10265A), title: const Text('Create a post'),
      content: SizedBox(width: 420, child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: title, decoration: const InputDecoration(labelText: 'Title', hintText: 'Enter a clear title')),
        const SizedBox(height: 12), TextField(controller: body, minLines: 3, maxLines: 5, decoration: const InputDecoration(labelText: 'Body', hintText: 'Write your post...')),
        if (validation.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10), child: Text(validation, style: const TextStyle(color: Color(0xFFFF819A)))),
      ])),
      actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')), FilledButton(
        onPressed: () { if (title.text.trim().isEmpty || body.text.trim().isEmpty) { setDialogState(() => validation = 'Both title and body are required.'); return; } Navigator.pop(dialogContext); submitPost(title.text.trim(), body.text.trim()); },
        child: const Text('Send post'),
      )],
    )));
    title.dispose(); body.dispose();
  }

  Future<void> submitPost(String title, String body) async {
    setState(() { feedback = 'Submitting your post...'; feedbackError = false; });
    try {
      final response = await http.post(Uri.parse('https://6acca26cb406cb8ec0c61c55.mockapi.io/posts'), headers: {'Content-Type':'application/json; charset=UTF-8'}, body: jsonEncode({'title':title,'body':body,'userId':1})).timeout(const Duration(seconds: 18));
      if (!mounted) return;
      if (response.statusCode == 201) {
        final created = Map<String, dynamic>.from(jsonDecode(response.body) as Map);
        setState(() { posts.insert(0, created); feedback = 'Post created successfully (demo API response 201).'; feedbackError = false; });
      } else { setState(() { feedback = 'Post failed. Server status: ${response.statusCode}.'; feedbackError = true; }); }
    } catch (_) { if (!mounted) return; setState(() { feedback = 'Post failed. Check your connection and try again.'; feedbackError = true; }); }
  }

  @override Widget build(BuildContext context) => Scaffold(
    body: AppBackground(child: RefreshIndicator(
      color: cyan, onRefresh: fetchPosts,
      child: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(18, 12, 18, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('Post Reader', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: textLight)), SizedBox(height: 4), Text('Explore posts from the world', style: TextStyle(color: textMuted))])),
            IconButton.filled(onPressed: () => Navigator.pushNamed(context, '/favorites'), style: IconButton.styleFrom(backgroundColor: violet), icon: const Icon(Icons.favorite_rounded), tooltip: 'Favorites'),
          ]),
          const SizedBox(height: 16),
          NeonPanel(padding: const EdgeInsets.fromLTRB(15, 12, 15, 10), child: Row(children: [
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('A little world of stories', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), SizedBox(height: 4), Text('Read • Discover • Keep your favorites', style: TextStyle(fontSize: 12, color: textMuted))])),
            const SizedBox(width: 8), SizedBox(width: 84, height: 82, child: Image.asset('assets/images/monsters/golden_bear.png', fit: BoxFit.contain)),
          ])),
          const SizedBox(height: 14),
          TextField(onChanged: (v) => setState(() => search = v), decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded, color: cyan), hintText: 'Search posts...', isDense: true)),
          const SizedBox(height: 11),
          const SizedBox(height: 18),
          Row(children: [const Expanded(child: Text('Latest posts', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900))), Text('${filtered.length} posts', style: const TextStyle(color: textMuted, fontSize: 12)), const SizedBox(width: 8), IconButton(onPressed: fetchPosts, icon: const Icon(Icons.refresh_rounded, color: cyan), tooltip: 'Refresh posts')]),
          if (feedback.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 7, bottom: 8), child: statusBanner(feedback, error: feedbackError)),
        ]))),
        if (loading) const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator(color: cyan)))
        else if (errorMessage.isNotEmpty) SliverFillRemaining(hasScrollBody: false, child: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.cloud_off_rounded, size: 48, color: pink), const SizedBox(height: 12), Text(errorMessage, textAlign: TextAlign.center), const SizedBox(height: 12), FilledButton.icon(onPressed: fetchPosts, icon: const Icon(Icons.refresh), label: const Text('Try again'))]))))
        else if (filtered.isEmpty) const SliverFillRemaining(hasScrollBody: false, child: Center(child: Text('No matching posts found.')))
        else SliverPadding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 108), sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) {
          final post = filtered[index]; final id = int.tryParse('${post['id']}') ?? index + 1;
          return Padding(padding: const EdgeInsets.only(bottom: 10), child: Card(child: InkWell(borderRadius: BorderRadius.circular(22), onTap: () => Navigator.pushNamed(context, '/details', arguments: {'id': id, 'title': post['title'], 'body': post['body'], 'userId': post['userId'] ?? 1}), child: Padding(padding: const EdgeInsets.all(11), child: Row(children: [
            MonsterAvatar(index: id - 1, size: 78), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('POST #$id', style: const TextStyle(color: cyan, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text((post['title'] ?? 'Untitled').toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)), const SizedBox(height: 5), Text((post['body'] ?? '').toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: textMuted, fontSize: 12, height: 1.3))])), const Icon(Icons.chevron_right_rounded, color: cyan, size: 27),
          ])))));
        }, childCount: filtered.length))),
      ]),
    )),
    floatingActionButton: FloatingActionButton.extended(onPressed: showCreateDialog, backgroundColor: violet, foregroundColor: Colors.white, icon: const Icon(Icons.add_rounded), label: const Text('Create post', style: TextStyle(fontWeight: FontWeight.w800))),
    bottomNavigationBar: const AppBottomNav(selected: 0),
  );
}
