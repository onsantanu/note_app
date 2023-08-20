class DailyFinance {
  int id;
  String title;
  String content;
  double amount;
  String createdat;

  DailyFinance(
      {this.id = 0,
      this.title = "Note",
      this.content = "Text",
      this.amount = 0.0,
      this.createdat = ''});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};
    if (id != 0) {
      data['id'] = id;
    }
    data['title'] = title;
    data['content'] = content;
    data['amount'] = amount;
    data['createdat'] = createdat;

    return data;
  }

  @override
  toString() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'amount': amount,
      'createdat': createdat,
    }.toString();
  }
}
