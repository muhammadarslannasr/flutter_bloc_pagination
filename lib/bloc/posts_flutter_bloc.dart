import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_pagination/data/models/post.dart';
import 'package:flutter_bloc_pagination/data/repositories/posts_respository.dart';

part 'posts_flutter_event.dart';
part 'posts_flutter_state.dart';

class PostsFlutterBloc extends Bloc<PostsFlutterEvent, PostsFlutterState> {
  PostsFlutterBloc({required this.repository}) : super(PostsFlutterInitial()) {
    on<LoadPostsEvent>(
      (event, emit) async{
        if (state is PostsFlutterStateLoading) return;

        final currentState = state;

        var oldPosts = <Post>[];
        if (currentState is PostsFlutterStateLoaded) {
          oldPosts = currentState.posts;
        }

        emit(PostsFlutterStateLoading(oldPosts, isFirstFetch: page == 1));

       await repository.fetchPosts(page).then((newPosts) {
          page++;

          final posts = (state as PostsFlutterStateLoading).oldPosts;
          posts.addAll(newPosts);

          emit(PostsFlutterStateLoaded(posts));
        });
      },
    );
  }

  int page = 1;
  final PostsRepository repository;
}
