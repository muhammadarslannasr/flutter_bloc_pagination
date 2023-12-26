
import 'package:flutter_bloc_pagination/data/models/post.dart';
import 'package:flutter_bloc_pagination/data/services/posts_service.dart';

class PostsRepository {

  final PostsService service;

  PostsRepository(this.service);

  Future<List<Post>> fetchPosts(int page) async {
    final posts = await service.fetchPosts(page);
    return posts.map((e) => Post.fromJson(e)).toList();
  }

}