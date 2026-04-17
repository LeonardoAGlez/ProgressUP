class UserModel {
  final String id;
  final String? fullName;
  final String? username;
  final String? avatarUrl;
  final String level;
  final int currentXP;
  final int totalXP;
  final int currentStreak;
  final int maxStreak;
  final bool isPro;

  const UserModel({
    required this.id,
    this.fullName,
    this.username,
    this.avatarUrl,
    this.level = 'Basic',
    this.currentXP = 0,
    this.totalXP = 0,
    this.currentStreak = 0,
    this.maxStreak = 0,
    this.isPro = false,
  });

  int get maxXPForCurrentLevel {
    switch (level) {
      case 'Legendary': return 999999;
      case 'Elite Athlete': return 10000;
      case 'Cyber Warrior': return 6000;
      case 'Neon Striker': return 3000;
      default: return 1000; // Basic
    }
  }

  String get displayName => fullName ?? username ?? 'Atleta';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      username: json['username'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      level: json['level'] as String? ?? 'Basic',
      currentXP: json['current_xp'] as int? ?? 0,
      totalXP: json['total_xp'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? 0,
      maxStreak: json['max_streak'] as int? ?? 0,
      isPro: json['is_pro'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'username': username,
      'avatar_url': avatarUrl,
      'level': level,
      'current_xp': currentXP,
      'total_xp': totalXP,
      'current_streak': currentStreak,
      'max_streak': maxStreak,
      'is_pro': isPro,
    };
  }
}

class WorkoutModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final int? durationMinutes;
  final int? caloriesBurned;
  final int xpEarned;
  final DateTime completedAt;

  const WorkoutModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.durationMinutes,
    this.caloriesBurned,
    this.xpEarned = 0,
    required this.completedAt,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      durationMinutes: json['duration_minutes'] as int?,
      caloriesBurned: json['calories_burned'] as int?,
      xpEarned: json['xp_earned'] as int? ?? 0,
      completedAt: DateTime.parse(json['completed_at'] as String),
    );
  }
}

class PostModel {
  final String id;
  final String userId;
  final String content;
  final String? imageUrl;
  final String? tag;
  int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  bool isLiked;

  PostModel({
    required this.id,
    required this.userId,
    required this.content,
    this.imageUrl,
    this.tag,
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
    this.isLiked = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      tag: json['tag'] as String?,
      likesCount: json['likes_count'] as int? ?? 0,
      commentsCount: json['comments_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class LeaderboardEntry {
  final String id;
  final String? fullName;
  final String? username;
  final String? avatarUrl;
  final String level;
  final int currentXP;
  final int rank;

  const LeaderboardEntry({
    required this.id,
    this.fullName,
    this.username,
    this.avatarUrl,
    required this.level,
    required this.currentXP,
    required this.rank,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      username: json['username'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      level: json['level'] as String? ?? 'Basic',
      currentXP: json['current_xp'] as int? ?? 0,
      rank: json['rank'] as int? ?? 0,
    );
  }

  String get displayName => fullName ?? username ?? 'Atleta Neon';
}
