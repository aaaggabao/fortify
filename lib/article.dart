class Article {
  final String objectId;
  final String author;
  final String title;
  final String content;

  const Article(
      {required this.objectId,
      required this.author,
      required this.title,
      required this.content});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      objectId: json['objectId'],
      author: json['author'],
      title: json['title'],
      content: json['content'],
    );
  }
}
