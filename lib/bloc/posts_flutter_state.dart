part of 'posts_flutter_bloc.dart';

@immutable
abstract class PostsFlutterState {}

class PostsFlutterInitial extends PostsFlutterState {}

class PostsFlutterStateLoaded extends PostsFlutterState {
  final List<Post> posts;

  PostsFlutterStateLoaded(this.posts);
}

class PostsFlutterStateLoading extends PostsFlutterState {
  final List<Post> oldPosts;
  final bool isFirstFetch;

  PostsFlutterStateLoading(this.oldPosts, {this.isFirstFetch = false});
}
