/*
 * SKYFY visual redesign. Upstream Musify GPL-3.0 functionality retained.
 */
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:musify/services/common_services.dart';
import 'package:musify/services/playlists_manager.dart';
import 'package:musify/widgets/mini_player_bottom_space.dart';
import 'package:musify/widgets/playlist_cube.dart';
import 'package:musify/widgets/recommended_songs_section.dart';

const _bg = Color(0xFF080610);
const _surface = Color(0xFF171126);
const _purple = Color(0xFFA778FF);
const _muted = Color(0xFFAAA1BC);

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<List> _mixes = getPlaylists(playlistsNum: 8);
  late final Future<List<dynamic>> _recommended = getRecommendedSongs();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              sliver: SliverToBoxAdapter(child: _header()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
              sliver: SliverToBoxAdapter(child: _searchBox()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
              sliver: SliverToBoxAdapter(child: _hero()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              sliver: SliverToBoxAdapter(
                child: _sectionTitle('Recently Played', action: 'Lihat semua'),
              ),
            ),
            SliverToBoxAdapter(child: _recentMixes()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              sliver: SliverToBoxAdapter(
                child: _sectionTitle('For You', action: 'Made for you'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: FutureBuilder<List<dynamic>>(
                  future: _recommended,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return _emptyCard('Rekomendasi belum tersedia');
                    }
                    if (!snapshot.hasData) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.data!.isEmpty) {
                      return _emptyCard('Cari musik untuk mulai membangun rekomendasi');
                    }
                    return RecommendedSongsSection(
                      title: 'Daily Mix',
                      songs: snapshot.data!,
                      listKeyPrefix: 'skyfy_daily_mix',
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: MiniPlayerBottomSpace()),
          ],
        ),
      ),
    );
  }

  Widget _header() => Row(
    children: [
      Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          gradient: const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFFD9C5FF), _purple, Color(0xFF6535C8)],
          ),
          boxShadow: [BoxShadow(color: _purple.withOpacity(.28), blurRadius: 18)],
        ),
        child: const Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 23),
      ),
      const SizedBox(width: 10),
      const Text('SKYFY', style: TextStyle(
        color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800,
        letterSpacing: 2.0,
      )),
      const Spacer(),
      _roundIcon(Icons.notifications_none_rounded, () => context.push('/settings')),
      const SizedBox(width: 10),
      GestureDetector(
        onTap: () => context.push('/settings'),
        child: Container(
          width: 36, height: 36,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [_purple, Color(0xFF44226F)]),
          ),
          child: const Icon(Icons.person_rounded, color: Colors.white, size: 20),
        ),
      ),
    ],
  );

  Widget _searchBox() => InkWell(
    onTap: () => context.go('/search'),
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: _surface, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.055)),
      ),
      child: const Row(children: [
        Icon(Icons.search_rounded, color: _muted, size: 21),
        SizedBox(width: 10),
        Expanded(child: Text('Cari lagu, artis, atau album...', style: TextStyle(color: _muted, fontSize: 13))),
      ]),
    ),
  );

  Widget _hero() => Container(
    height: 190,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: const LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [Color(0xFF513078), Color(0xFF241638), Color(0xFF100D1C)],
      ),
      border: Border.all(color: _purple.withOpacity(.24)),
    ),
    child: Stack(children: [
      Positioned(right: -35, top: -55, child: _glow(180, const Color(0xFFB77BFF))),
      Positioned(right: 28, bottom: -70, child: _glow(180, const Color(0xFF7041C6))),
      Positioned(right: 25, top: 22, child: Icon(Icons.graphic_eq_rounded, size: 125, color: Colors.white.withOpacity(.12))),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Colors.white.withOpacity(.12), borderRadius: BorderRadius.circular(20)),
            child: const Text('YOUR DAILY SOUND', style: TextStyle(color: Color(0xFFE5D5FF), fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
          ),
          const Spacer(),
          const Text('Chill Mix', style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('Kumpulan lagu santai untuk\\nmenemani harimu.', style: TextStyle(color: Color(0xFFE0D5EF), height: 1.35, fontSize: 12)),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => context.go('/search'),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
              decoration: BoxDecoration(color: _purple, borderRadius: BorderRadius.circular(30)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                SizedBox(width: 5),
                Text('Explore music', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11)),
              ]),
            ),
          ),
        ]),
      ),
    ]),
  );

  Widget _recentMixes() => SizedBox(
    height: 150,
    child: FutureBuilder<List>(
      future: _mixes,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(
            height: 125,
            child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20), children: [
              _genreTile('The Marías', Icons.album_rounded, const Color(0xFF6C4B91)),
              _genreTile('Daniel Caesar', Icons.music_note_rounded, const Color(0xFF985F74)),
              _genreTile('Frank Ocean', Icons.nightlight_round, const Color(0xFF405B83)),
            ]),
          );
        }
        final items = snapshot.data!.take(8).toList();
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  final id = item['ytid']?.toString();
                  if (id != null && id.isNotEmpty) context.push('/home/playlist/$id');
                },
                child: SizedBox(width: 112, child: PlaylistCube(item, size: 112)),
              ),
            );
          },
        );
      },
    ),
  );

  Widget _genreTile(String title, IconData icon, Color color) => Container(
    width: 112, margin: const EdgeInsets.only(right: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(17),
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color, _surface]),
    ),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, color: Colors.white, size: 35),
      const SizedBox(height: 9),
      Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
    ]),
  );

  Widget _sectionTitle(String title, {String? action}) => Row(
    children: [
      Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
      const Spacer(),
      if (action != null) Text(action, style: const TextStyle(color: _muted, fontSize: 10)),
    ],
  );

  Widget _emptyCard(String text) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(18)),
    child: Text(text, style: const TextStyle(color: _muted, fontSize: 12)),
  );

  Widget _roundIcon(IconData icon, VoidCallback onTap) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(30),
    child: Container(
      width: 36, height: 36,
      decoration: BoxDecoration(color: _surface, shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(.06))),
      child: Icon(icon, color: Colors.white70, size: 19),
    ),
  );

  Widget _glow(double size, Color color) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(.15),
      boxShadow: [BoxShadow(color: color.withOpacity(.25), blurRadius: 65, spreadRadius: 25)]),
  );
}
