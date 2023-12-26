import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_pagination/bloc/posts_flutter_bloc.dart';
import 'package:flutter_bloc_pagination/data/models/post.dart';

class PostsBlocView extends StatelessWidget {
  final scrollController = ScrollController();
  PostsBlocView({super.key});

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<PostsFlutterBloc>(context).add(LoadPostsEvent());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    BlocProvider.of<PostsFlutterBloc>(context).add(LoadPostsEvent());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paginated Posts Using Bloc"),
      ),
      body: _postList(),
    );
  }

  Widget _postList() {
    return BlocBuilder<PostsFlutterBloc, PostsFlutterState>(
      builder: (context, state) {
        if (state is PostsFlutterStateLoading && state.isFirstFetch) {
          return _loadingIndicator();
        }

        List<Post> posts = [];
        bool isLoading = false;

        if (state is PostsFlutterStateLoading) {
          posts = state.oldPosts;
          isLoading = true;
        } else if (state is PostsFlutterStateLoaded) {
          posts = state.posts;
        }

        return ListView.separated(
          controller: scrollController,
          itemBuilder: (context, index) {
            if (index < posts.length) {
              return _post(posts[index], context);
            } else {
              Timer(const Duration(milliseconds: 30), () {
                scrollController.jumpTo(scrollController.position.maxScrollExtent);
              });

              return _loadingIndicator();
            }
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey[400],
            );
          },
          itemCount: posts.length + (isLoading ? 1 : 0),
        );
      },
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _post(Post post, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${post.id}. ${post.title}",
            style: const TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Text(post.body)
        ],
      ),
    );
  }
}
