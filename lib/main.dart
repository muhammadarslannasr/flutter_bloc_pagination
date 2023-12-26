import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_pagination/bloc/posts_flutter_bloc.dart';
import 'package:flutter_bloc_pagination/cubit/posts_cubit.dart';
import 'package:flutter_bloc_pagination/data/repositories/posts_respository.dart';
import 'package:flutter_bloc_pagination/data/services/posts_service.dart';
import 'package:flutter_bloc_pagination/presentation/posts_bloc_screen.dart';
import 'package:flutter_bloc_pagination/presentation/posts_screen.dart';

void main() {
  runApp(PaginationApp(
    repository: PostsRepository(PostsService()),
  ));
}

class PaginationApp extends StatelessWidget {
  final PostsRepository repository;

  const PaginationApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PostsCubit(repository),
          ),
          BlocProvider(
            create: (context) => PostsFlutterBloc(repository: repository),
          ),
        ],
        // child: PostsView(),
        child: PostsBlocView(),
      ),
    );
  }
}
