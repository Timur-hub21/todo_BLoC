import 'package:bloc_new_app/layout/todo_layout.dart';
import 'package:bloc_new_app/shared/bloc_observer.dart';
import 'package:bloc_new_app/shared/cubit/cubit.dart';
import 'package:bloc_new_app/shared/cubit/states.dart';
import 'package:bloc_new_app/shared/network/cache_helper.dart';
import 'package:bloc_new_app/shared/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark');
  BlocOverrides.runZoned(
    () {
      runApp(MyApp(
        isDark: isDark,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final bool? isDark;

   const MyApp({Key? key, 
    this.isDark,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => AppCubit()
              ..changeAppMode(
                fromShared: isDark,
              ),
          ),
        ],
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: AppCubit.get(context).isDark!
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: HomeLayout(),
            );
          },
        ));
  }
}
