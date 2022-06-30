import '../../features/hadith/hadith_page_scrollable.dart';
import '../../features/list/list_archive_screen.dart';
import '../../features/search/search_page.dart';
import '../../features/topic/section_screen.dart';
import '../../features/topic/topic_screen.dart';
import '../../features/verse/cuz/cuz_screen.dart';
import '../../features/verse/surah/surah_screen.dart';
import '../../features/verse/verse_screen.dart';
import '../../screens/setting_screen.dart';
import 'bottom_navbar.dart';

final kRouters={
  BottomNavBar.id: (context) => const BottomNavBar(),
  VerseScreen.id: (context) => const VerseScreen(),
  TopicScreen.id: (context) => const TopicScreen(),
  SectionScreen.id: (context) => const SectionScreen(),
  HadithPageScrollable.id: (context) => const HadithPageScrollable(),
  CuzScreen.id: (context) => const CuzScreen(),
  SearchPage.id: (context) => const SearchPage(),
  SurahScreen.id: (context) => const SurahScreen(),
  SettingScreen.id:(context)=>const SettingScreen(),
  ListArchiveScreen.id:(context)=>const ListArchiveScreen(),
};