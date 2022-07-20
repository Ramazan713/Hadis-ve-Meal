import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/features/list/bloc/blocs/list_archive_bloc.dart';
import 'package:hadith/features/list/bloc/blocs/list_hadith_bloc.dart';
import 'package:hadith/features/list/bloc/blocs/list_verse_bloc.dart';
import 'package:hadith/features/premium/bloc/premium_bloc.dart';
import 'package:hadith/bloc/visibility_bloc/visibility_bloc.dart';
import 'package:hadith/constants/enums/theme_enum.dart';
import 'package:hadith/db/repos/backup_meta_repo.dart';
import 'package:hadith/db/repos/backup_repo.dart';
import 'package:hadith/db/repos/history_repo.dart';
import 'package:hadith/db/repos/save_point_repo.dart';
import 'package:hadith/db/repos/topic_savepoint_repo.dart';
import 'package:hadith/db/repos/user_info_repo.dart';
import 'package:hadith/features/add_to_list/bloc/list_bloc.dart';
import 'package:hadith/db/database.dart';
import 'package:hadith/db/repos/cuz_repo.dart';
import 'package:hadith/db/repos/hadith_repo.dart';
import 'package:hadith/db/repos/list_repo.dart';
import 'package:hadith/db/repos/section_repo.dart';
import 'package:hadith/db/repos/surah_repo.dart';
import 'package:hadith/db/repos/topic_repo.dart';
import 'package:hadith/db/repos/verse_repo.dart';
import 'package:hadith/features/backup/backup_meta/bloc/backup_meta_bloc.dart';
import 'package:hadith/features/backup/user_info/bloc/user_info_bloc.dart';
import 'package:hadith/features/history/bloc/history_bloc.dart';
import 'package:hadith/features/save_point/bloc/save_point_bloc.dart';
import 'package:hadith/features/search/bloc/search_bloc.dart';
import 'package:hadith/features/topic/bloc/section_bloc.dart';
import 'package:hadith/features/topic/bloc/topic_bloc.dart';
import 'package:hadith/features/topic_savepoint/bloc/topic_savepoint_bloc.dart';
import 'package:hadith/themes/bloc/theme_bloc.dart';
import 'package:hadith/themes/bloc/theme_state.dart';
import 'package:hadith/themes/dark_theme.dart';
import 'package:hadith/themes/light_theme.dart';
import 'features/bottom_nav/bloc/bottom_nav_bloc.dart';
import 'features/bottom_nav/bottom_navbar.dart';
import 'features/paging/bloc/paging_bloc.dart';
import 'features/premium/bloc/premium_event.dart';
import 'features/verse/cuz/bloc/cuz_bloc.dart';
import 'features/verse/surah/bloc/surah_bloc.dart';
import 'features/save_point/bloc/save_point_edit_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class MyApp extends StatelessWidget {

  const MyApp({Key? key, required this.appDatabase})
      : super(key: key);

  final AppDatabase appDatabase;

  @override
  Widget build(BuildContext context) {

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ListRepo>(
            create: (context) => ListRepo(listDao: appDatabase.listDao)),
        RepositoryProvider<HadithRepo>(
            create: (context) => HadithRepo(hadithDao: appDatabase.hadithDao)),
        RepositoryProvider<CuzRepo>(
            create: (context) => CuzRepo(cuzDao: appDatabase.cuzDao)),
        RepositoryProvider<SectionRepo>(
            create: (context) => SectionRepo(sectionDao: appDatabase.sectionDao)),
        RepositoryProvider<SurahRepo>(
            create: (context) => SurahRepo(surahDao: appDatabase.surahDao)),
        RepositoryProvider<TopicRepo>(
            create: (context) => TopicRepo(topicDao: appDatabase.topicDao)),
        RepositoryProvider<VerseRepo>(
            create: (context) => VerseRepo(verseDao: appDatabase.verseDao)),
        RepositoryProvider<SavePointRepo>(
            create: (context) =>
                SavePointRepo(savePointDao:appDatabase.savePointDao)),
        RepositoryProvider<HistoryRepo>(
            create: (context) => HistoryRepo(historyDao: appDatabase.historyDao)),
        RepositoryProvider(
            create: (context) =>
                UserInfoRepo(userInfoDao: appDatabase.userInfoDao)),
        RepositoryProvider(
            create: (context) => BackupRepo(backupDao: appDatabase.backupDao)),
        RepositoryProvider(
            create: (context) =>
                BackupMetaRepo(backupMetaDao: appDatabase.backupMetaDao)),
        RepositoryProvider(
            create: (context) =>
                TopicSavePointRepo(savePointDao: appDatabase.topicSavePointDao)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  TopicBloc(topicRepo: context.read<TopicRepo>())),
          BlocProvider(
              create: (context) =>
                  SectionBloc(topicRepo: context.read<TopicRepo>())),
          BlocProvider(create: (context) => ListBloc()),
          BlocProvider(
              create: (context) => CuzBloc(cuzRepo: context.read<CuzRepo>())),
          BlocProvider(
              create: (context) =>
                  SurahBloc(surahRepo: context.read<SurahRepo>())),
          BlocProvider(
              create: (context) =>
                  SavePointBloc(savePointRepo: context.read<SavePointRepo>())),
          BlocProvider(
              create: (context) => SavePointEditBloc(
                  savePointRepo: context.read<SavePointRepo>())),
          BlocProvider(
              create: (context) =>
                  ListHadithBloc(listRepo: context.read<ListRepo>(),
                      savePointRepo: context.read<SavePointRepo>())),
          BlocProvider(
              create: (context) => SearchBloc(
                  hadithRepo: context.read<HadithRepo>(),
                  verseRepo: context.read<VerseRepo>())),
          BlocProvider(
              create: (context) =>
                  ListVerseBloc(listRepo: context.read<ListRepo>(),
                      savePointRepo: context.read<SavePointRepo>())),
          BlocProvider(
              create: (context) =>
                  HistoryBloc(historyRepo: context.read<HistoryRepo>())),
          BlocProvider(create: (context) => BottomNavBloc()),
          BlocProvider(create: (context)=>ListArchiveBloc(listRepo: context.read<ListRepo>(),savePointRepo: context.read<SavePointRepo>())),
          BlocProvider(create: (context)=>ThemeBloc()),
          BlocProvider(create: (context)=>PremiumBloc(), lazy: false,),
          BlocProvider(create: (context)=>UserInfoBloc(userInfoRepo: context.read<UserInfoRepo>())),
          BlocProvider(create: (context)=>VisibilityBloc()),
          BlocProvider(create: (context)=>BackupMetaBloc(backupMetaRepo: context.read<BackupMetaRepo>())),
          BlocProvider(create: (context)=>TopicSavePointBloc(savePointRepo: context.read<TopicSavePointRepo>()))
        ],
        child: BlocBuilder<ThemeBloc,ThemeState>(
          builder: (context,state){
            context.read<PremiumBloc>().add(PremiumEventRestorePurchase());

            return Phoenix(
              child: MaterialApp(
                title: 'Hadis ve Meal',
                debugShowCheckedModeBanner: false,
                themeMode: state.themeEnum.mode,
                theme: getLightThemeData(),
                darkTheme: getDarkThemeData(),
                home: const BottomNavBar(),
              ),
            );
          },
        ),
      ),
    );
  }
}
