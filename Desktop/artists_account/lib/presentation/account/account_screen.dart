import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/post_entity.dart';
import '../widgets/comment_bottom_sheet.dart';
import '../widgets/share_dialog.dart';
import 'bloc/account_bloc.dart';
import 'bloc/account_event.dart';
import 'bloc/account_state.dart';
import '../../injection_container.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountBloc>()..add(const LoadUserEvent('user123')),
      child: const AccountView(),
    );
  }
}

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  List<PostEntity> _getMockPosts() {
    return [
      const PostEntity(
        id: '1',
        userId: 'user123',
        username: 'Aline Mukarurangwa',
        userProfileImage: '',
        caption: 'Working on a new textile piece that explores migration. Looking for composition feedback — comments welcome!',
        mediaUrls: [],
        tags: ['#critique', '#textile'],
        isFollowing: false,
      ),
      const PostEntity(
        id: '2',
        userId: 'user123',
        username: 'Aline Mukarurangwa',
        userProfileImage: '',
        caption: 'Enjoyed painting this work last week!',
        mediaUrls: ['https://picsum.photos/seed/flower/600/400'],
        tags: [],
        isFollowing: false,
      ),
      const PostEntity(
        id: '3',
        userId: 'user123',
        username: 'Aline Mukarurangwa',
        userProfileImage: '',
        caption: 'Experimenting with different color palettes for my upcoming exhibition. What do you think?',
        mediaUrls: ['https://picsum.photos/seed/palette/600/400'],
        tags: ['#colortheory', '#exhibition'],
        isFollowing: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('My Account'),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            print('Current state: ${state.runtimeType}');
            
            if (state is AccountLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading your profile...'),
                  ],
                ),
              );
            }

            if (state is AccountError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red),
                    SizedBox(height: 16),
                    Text(state.message),
                  ],
                ),
              );
            }

            if (state is AccountLoaded) {
              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildAvatar(state.user.name),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.user.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${state.user.profession} · ${state.user.location}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.blue),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Edit Profile'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            state.user.bio,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const TabBar(
                    indicatorColor: Colors.blue,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: 'Posts'),
                      Tab(text: 'Media'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildPostsList(_getMockPosts(), context, state),
                        _buildMediaGrid(),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildAvatar(String name) {
    final initials = name.split(' ').map((n) => n[0]).take(2).join();
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPostsList(List<PostEntity> posts, BuildContext context, AccountLoaded state) {
    if (posts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.post_add, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No posts yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Share your first artwork!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return _buildPostCard(posts[index], context, state);
      },
    );
  }

  Widget _buildPostCard(PostEntity post, BuildContext context, AccountLoaded state) {
    final followKey = '${post.userId}_${post.id}';
    final isLiked = state.likedPosts[post.id] ?? false;
    final isBookmarked = state.bookmarkedPosts[post.id] ?? false;
    final isFollowing = state.followedPosts[followKey] ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildAvatar(post.username),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const Text(
                        'Visual Artist · Kigali',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<AccountBloc>().add(ToggleFollowPostEvent(followKey));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing ? Colors.grey[300] : Colors.blue,
                    foregroundColor: isFollowing ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                  ),
                  child: Text(isFollowing ? 'Following' : 'Follow'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(post.caption),
          ),
          if (post.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Wrap(
                spacing: 8,
                children: post.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
              ),
            ),
          if (post.mediaUrls.isNotEmpty)
            Image.network(
              post.mediaUrls.first,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                  onPressed: () {
                    context.read<AccountBloc>().add(ToggleLikePostEvent(post.id));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => CommentBottomSheet(
                        postId: post.id,
                        postAuthor: post.username,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ShareDialog(
                        postId: post.id,
                        postAuthor: post.username,
                        postCaption: post.caption,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? Colors.blue : null,
                  ),
                  onPressed: () {
                    context.read<AccountBloc>().add(ToggleBookmarkPostEvent(post.id));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaGrid() {
    return const Center(
      child: Text('Media view - Coming soon'),
    );
  }
}
