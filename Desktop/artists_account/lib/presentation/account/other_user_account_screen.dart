import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/post_entity.dart';
import '../widgets/comment_bottom_sheet.dart';
import '../widgets/share_dialog.dart';
import 'bloc/account_bloc.dart';
import 'bloc/account_event.dart';
import 'bloc/account_state.dart';
import '../../injection_container.dart';

class OtherUserAccountScreen extends StatelessWidget {
  final String userId;
  final String name;
  final String profession;
  final String location;
  final String bio;

  const OtherUserAccountScreen({
    super.key,
    required this.userId,
    required this.name,
    required this.profession,
    required this.location,
    required this.bio,
  });

  List<PostEntity> _getUserPosts() {
    if (userId == 'user456') {
      return [
        const PostEntity(
          id: '101',
          userId: 'user456',
          username: 'Jean Claude Niyonsenga',
          userProfileImage: '',
          caption: 'Just finished this sculpture inspired by Rwandan heritage. Feedback appreciated!',
          mediaUrls: ['assets/images/african_woman_portrait.png'],
          tags: ['#sculpture', '#heritage'],
          isFollowing: false,
        ),
        const PostEntity(
          id: '102',
          userId: 'user456',
          username: 'Jean Claude Niyonsenga',
          userProfileImage: '',
          caption: 'Working with clay is therapeutic. Here is my process.',
          mediaUrls: [],
          tags: ['#process', '#clay'],
          isFollowing: false,
        ),
      ];
    } else if (userId == 'user789') {
      return [
        const PostEntity(
          id: '201',
          userId: 'user789',
          username: 'Grace Uwase',
          userProfileImage: '',
          caption: 'New digital art series exploring urban Kigali. Thoughts?',
          mediaUrls: ['assets/images/house_with_tree.png'],
          tags: ['#digitalart', '#kigali'],
          isFollowing: false,
        ),
        const PostEntity(
          id: '202',
          userId: 'user789',
          username: 'Grace Uwase',
          userProfileImage: '',
          caption: 'Collaborating with local musicians for an art installation. Excited!',
          mediaUrls: ['assets/images/birds_sunset.png'],
          tags: ['#collaboration', '#installation'],
          isFollowing: false,
        ),
        const PostEntity(
          id: '203',
          userId: 'user789',
          username: 'Grace Uwase',
          userProfileImage: '',
          caption: 'Study of light and shadow in traditional architecture.',
          mediaUrls: [],
          tags: ['#study', '#architecture'],
          isFollowing: false,
        ),
      ];
    } else if (userId == 'user101') {
      return [
        const PostEntity(
          id: '301',
          userId: 'user101',
          username: 'Samuel Mugisha',
          userProfileImage: '',
          caption: 'Street photography series capturing everyday moments in Kigali.',
          mediaUrls: ['assets/images/orange_rocks.png'],
          tags: ['#photography', '#street'],
          isFollowing: false,
        ),
        const PostEntity(
          id: '302',
          userId: 'user101',
          username: 'Samuel Mugisha',
          userProfileImage: '',
          caption: 'Portrait session with local artisans. Their stories inspire me.',
          mediaUrls: ['assets/images/starry_night_river.png'],
          tags: ['#portrait', '#artisan'],
          isFollowing: false,
        ),
      ];
    } else {
      return [
        const PostEntity(
          id: '401',
          userId: 'user202',
          username: 'Diane Iradukunda',
          userProfileImage: '',
          caption: 'Fashion design inspired by traditional imigongo patterns.',
          mediaUrls: ['assets/images/colorful_abstract_strokes.png'],
          tags: ['#fashion', '#imigongo'],
          isFollowing: false,
        ),
        const PostEntity(
          id: '402',
          userId: 'user202',
          username: 'Diane Iradukunda',
          userProfileImage: '',
          caption: 'Sustainable fashion is the future. Using locally sourced materials.',
          mediaUrls: [],
          tags: ['#sustainable', '#local'],
          isFollowing: false,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountBloc>()..add(LoadUserEvent(userId)),
      child: OtherUserAccountView(
        userId: userId,
        name: name,
        profession: profession,
        location: location,
        bio: bio,
        posts: _getUserPosts(),
      ),
    );
  }
}

class OtherUserAccountView extends StatelessWidget {
  final String userId;
  final String name;
  final String profession;
  final String location;
  final String bio;
  final List<PostEntity> posts;

  const OtherUserAccountView({
    super.key,
    required this.userId,
    required this.name,
    required this.profession,
    required this.location,
    required this.bio,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(name),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _showOptionsMenu(context);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildAvatar(name),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$profession · $location',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<AccountBloc, AccountState>(
                        builder: (context, state) {
                          final isFollowing = (state is AccountLoaded) 
                              ? (state.followedPosts[userId] ?? false)
                              : false;
                          return ElevatedButton(
                            onPressed: () {
                              context.read<AccountBloc>().add(ToggleFollowPostEvent(userId));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isFollowing ? Colors.grey[300] : Colors.blue,
                              foregroundColor: isFollowing ? Colors.black : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(isFollowing ? 'Following' : 'Follow'),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      bio,
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
              child: BlocBuilder<AccountBloc, AccountState>(
                builder: (context, state) {
                  if (state is AccountLoaded) {
                    return TabBarView(
                      children: [
                        _buildPostsList(posts, context, state),
                        _buildMediaGrid(),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
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
    final postFollowKey = '${post.userId}_${post.id}';
    final isLiked = state.likedPosts[post.id] ?? false;
    final isBookmarked = state.bookmarkedPosts[post.id] ?? false;
    final isPostFollowing = state.followedPosts[postFollowKey] ?? false;

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
                      Text(
                        '$profession · $location',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<AccountBloc>().add(ToggleFollowPostEvent(postFollowKey));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPostFollowing ? Colors.grey[300] : Colors.blue,
                    foregroundColor: isPostFollowing ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                  ),
                  child: Text(isPostFollowing ? 'Following' : 'Follow'),
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
            Image.asset(
              post.mediaUrls.first,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                );
              },
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

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share, color: Colors.blue),
              title: const Text('Share Profile'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sharing $name\'s profile')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.orange),
              title: const Text('Block User'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Block User'),
                    content: Text('Are you sure you want to block $name?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$name has been blocked'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('Block'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.report, color: Colors.red),
              title: const Text('Report User'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Report User'),
                    content: Text('Report $name for inappropriate content?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Report submitted. Thank you!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Report'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
