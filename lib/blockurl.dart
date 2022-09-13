class BlockedUrl {
  final String objectId;
  final String enabled;
  final String url;

  const BlockedUrl(
      {required this.objectId,
        required this.enabled,
        required this.url});

  factory BlockedUrl.fromJson(Map<String, dynamic> json) {
    return BlockedUrl(
      objectId: json['objectId'],
      enabled: json['enabled'],
      url: json['url'],
    );
  }
}