import 'package:flutter/material.dart';
import '../main.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child, this.padding = EdgeInsets.zero});
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Image.asset('assets/images/fantasy_background.jpg', fit: BoxFit.cover),
      Container(color: night.withOpacity(.72)),
      Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x331A7DFF), Color(0xAA061338)]))),
      SafeArea(child: Padding(padding: padding, child: child)),
    ],
  );
}

const List<String> monsterAssets = [
  'golden_bear','mushroom_monster','blue_hat_monster','ghost_skull','lime_monster','purple_bat',
  'pink_one_eye','blue_horn_monster','purple_eye_orb','cloud_monster','pumpkin_monster','leaf_baby',
  'mushroom_friend','purple_spike','blue_slime','orange_crab','fire_monster','angel_pink',
  'blue_bat','green_monster','hooded_skull','blue_whale','rock_golem','purple_snail',
];

class MonsterAvatar extends StatelessWidget {
  const MonsterAvatar({super.key, required this.index, this.size = 84, this.glow = true});
  final int index;
  final double size;
  final bool glow;
  @override
  Widget build(BuildContext context) {
    final name = monsterAssets[index.abs() % monsterAssets.length];
    return Container(
      width: size, height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xAA142D68), borderRadius: BorderRadius.circular(size * .25),
        border: Border.all(color: const Color(0x7735D8FF)),
        boxShadow: glow ? [BoxShadow(color: cyan.withOpacity(.16), blurRadius: 16, spreadRadius: 1)] : const [],
      ),
      child: Image.asset('assets/images/monsters/$name.png', fit: BoxFit.contain),
    );
  }
}

class NeonPanel extends StatelessWidget {
  const NeonPanel({super.key, required this.child, this.padding = const EdgeInsets.all(14), this.borderColor = const Color(0x5535D8FF)});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: const Color(0xE90A2055), borderRadius: BorderRadius.circular(22),
      border: Border.all(color: borderColor),
      boxShadow: [BoxShadow(color: borderColor.withOpacity(.10), blurRadius: 18, spreadRadius: 1)],
    ), child: child,
  );
}

class NeonButton extends StatelessWidget {
  const NeonButton({super.key, required this.label, required this.icon, required this.onPressed, this.gradient = const [cyan, violet]});
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final List<Color> gradient;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity, height: 52,
    child: DecoratedBox(
      decoration: BoxDecoration(gradient: LinearGradient(colors: gradient), borderRadius: BorderRadius.circular(17), boxShadow: [BoxShadow(color: gradient.last.withOpacity(.26), blurRadius: 14, offset: const Offset(0, 5))]),
      child: FilledButton.icon(
        onPressed: onPressed, icon: Icon(icon, size: 20), label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        style: FilledButton.styleFrom(backgroundColor: Colors.transparent, disabledBackgroundColor: Colors.transparent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17))),
      ),
    ),
  );
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.selected});
  final int selected;
  @override
  Widget build(BuildContext context) => NavigationBar(
    height: 70, backgroundColor: const Color(0xF8081940), indicatorColor: violet.withOpacity(.30),
    selectedIndex: selected,
    onDestinationSelected: (index) {
      if (index == 0 && selected != 0) Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      if (index == 1 && selected != 1) Navigator.pushNamed(context, '/favorites');
    },
    destinations: const [
      NavigationDestination(icon: Icon(Icons.auto_stories_outlined), selectedIcon: Icon(Icons.auto_stories), label: 'Posts'),
      NavigationDestination(icon: Icon(Icons.favorite_border_rounded), selectedIcon: Icon(Icons.favorite_rounded), label: 'Favorites'),
    ],
  );
}

Widget statusBanner(String message, {bool error = false}) => Container(
  width: double.infinity, padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(color: error ? const Color(0xCC64223B) : const Color(0xCC124D63), borderRadius: BorderRadius.circular(14), border: Border.all(color: error ? const Color(0xFFFF7892) : cyan.withOpacity(.5))),
  child: Text(message, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
);
