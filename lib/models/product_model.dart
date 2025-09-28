class PostModel {
  final String? id;
  final String? title;
  final String? body;
  PostModel({required this.id, required this.title, required this.body});

  
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: (json['id'] as num).toString(),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }
}