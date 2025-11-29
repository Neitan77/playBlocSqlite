class AudioItem {
  final int? id;
  final String assetPath, title, artist, imagePath;

  AudioItem({
    this.id,
    required this.assetPath,
    required this.title,
    required this.artist,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assetPath': assetPath,
      'title': title,
      'artist': artist,
      'imagePath': imagePath,
    };
  }

  factory AudioItem.fromMap(Map<String, dynamic> map) {
    return AudioItem(
      id: map['id'],
      assetPath: map['assetPath'],
      title: map['title'],
      artist: map['artist'],
      imagePath: map['imagePath'],
    );
  }

  AudioItem copyWith({
    int? id,
    String? assetPath,
    String? title,
    String? artist,
    String? imagePath,
  }) {
    return AudioItem(
      id: id ?? this.id,
      assetPath: assetPath ?? this.assetPath,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
