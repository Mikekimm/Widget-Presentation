class PostEntity {
  final String id;
  final String userId;
  final String username;
  final String userProfileImage;
  final String caption;
  final List<String> mediaUrls;
  final List<String> tags;
  final bool isFollowing;

  const PostEntity({
    required this.id,
    required this.userId,
    required this.username,
    required this.userProfileImage,
    required this.caption,
    required this.mediaUrls,
    required this.tags,
    this.isFollowing = false,
  });
}
