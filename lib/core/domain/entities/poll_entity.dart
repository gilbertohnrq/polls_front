class PollEntity {
  final String id;
  final String title;
  final List<Option> options;

  PollEntity({required this.id, required this.title, required this.options});

  factory PollEntity.empty() {
    return PollEntity(
      id: '',
      title: '',
      options: [],
    );
  }

  factory PollEntity.fromJson(Map<String, dynamic> json) {
    var list = json['options'] as List<dynamic>;
    List<Option> optionsList =
        list.map((i) => Option.fromJson(i as Map<String, dynamic>)).toList();
    return PollEntity(
      id: json['id'],
      title: json['title'],
      options: optionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'options': options.map((e) => e.toJson()).toList(),
    };
  }
}

class Option {
  final String id;
  final String title;
  int votes;

  Option({required this.id, required this.title, required this.votes});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      votes: json['votes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'votes': votes,
    };
  }
}
