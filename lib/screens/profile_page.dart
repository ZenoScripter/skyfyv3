/*
 * SKYFY profile hub. Settings and account actions continue to use upstream routes.
 */
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

const _profileBg = Color(0xFF080610);
const _profileSurface = Color(0xFF171126);
const _profilePurple = Color(0xFFA778FF);
const _profileMuted = Color(0xFFAAA1BC);

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _profileBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
              sliver: SliverToBoxAdapter(
                child: Row(children: [
                  const Text('Profile', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  _iconButton(Icons.settings_outlined, () => context.push('/settings/preferences')),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 26),
              sliver: SliverToBoxAdapter(child: _profileHeader()),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              sliver: SliverToBoxAdapter(
                child: Column(children: [
                  _group([
                    _item(Icons.person_outline_rounded, 'Edit Profil', 'Ubah nama dan foto profil', () => _message(context, 'Profil lokal')),
                    _item(Icons.palette_outlined, 'Appearance', 'Tema, warna, dan tampilan', () => context.push('/settings/preferences')),
                    _item(Icons.equalizer_rounded, 'Playback', 'Kualitas audio & pemutaran', () => context.push('/settings/equalizer')),
                    _item(Icons.download_outlined, 'Download', 'Lokasi, kualitas, dan penyimpanan', () => context.push('/settings/preferences')),
                    _item(Icons.info_outline_rounded, 'Tentang SKYFY', 'Informasi aplikasi dan developer', () => context.push('/settings/about')),
                  ]),
                  const SizedBox(height: 18),
                  _group([
                    _item(Icons.favorite_border_rounded, 'Liked Songs', 'Koleksi lagu favorit', () => context.go('/library')),
                    _item(Icons.library_music_outlined, 'Your Library', 'Playlist dan musik tersimpan', () => context.go('/library')),
                  ]),
                  const SizedBox(height: 22),
                  const Text('SKYFY MUSIC  •  INDEPENDENT OPEN-SOURCE BUILD', style: TextStyle(color: _profileMuted, fontSize: 9, letterSpacing: 1.1)),
                  const SizedBox(height: 22),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader() => Column(children: [
    Container(
      width: 104, height: 104,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_profilePurple, Color(0xFF34204F)]),
        border: Border.all(color: _profilePurple.withOpacity(.65), width: 2),
        boxShadow: [BoxShadow(color: _profilePurple.withOpacity(.22), blurRadius: 30, spreadRadius: 2)],
      ),
      child: const Icon(Icons.person_rounded, color: Colors.white, size: 56),
    ),
    const SizedBox(height: 13),
    const Text('Listener', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
    const SizedBox(height: 5),
    const Text('Your music space', style: TextStyle(color: _profileMuted, fontSize: 12)),
    const SizedBox(height: 16),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      decoration: BoxDecoration(color: _profilePurple.withOpacity(.13), borderRadius: BorderRadius.circular(30), border: Border.all(color: _profilePurple.withOpacity(.3))),
      child: const Text('SKYFY MEMBER', style: TextStyle(color: Color(0xFFD8C4FF), fontSize: 9, letterSpacing: 1.4, fontWeight: FontWeight.w800)),
    ),
  ]);

  Widget _group(List<Widget> children) => Container(
    decoration: BoxDecoration(color: _profileSurface, borderRadius: BorderRadius.circular(19), border: Border.all(color: Colors.white.withOpacity(.045))),
    child: Column(children: [
      for (var i = 0; i < children.length; i++) ...[
        children[i],
        if (i != children.length - 1) Divider(height: 1, indent: 56, color: Colors.white.withOpacity(.055)),
      ],
    ]),
  );

  Widget _item(IconData icon, String title, String subtitle, VoidCallback action) => InkWell(
    onTap: action,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: _profilePurple.withOpacity(.13), borderRadius: BorderRadius.circular(11)), child: Icon(icon, color: _profilePurple, size: 19)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(subtitle, style: const TextStyle(color: _profileMuted, fontSize: 10)),
        ])),
        const Icon(Icons.chevron_right_rounded, color: _profileMuted, size: 20),
      ]),
    ),
  );

  Widget _iconButton(IconData icon, VoidCallback action) => InkWell(
    onTap: action, borderRadius: BorderRadius.circular(30),
    child: Container(width: 38, height: 38, decoration: const BoxDecoration(color: _profileSurface, shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 19)),
  );

  void _message(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
