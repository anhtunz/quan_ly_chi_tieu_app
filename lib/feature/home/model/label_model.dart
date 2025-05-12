class LabelModel {
  int? id;
  String? name;
  bool? isIncome;
  bool? isDeleted;
  String? iconName;
  String? color;

  LabelModel(
      {this.id,
      this.name,
      this.iconName,
      this.color,
      this.isIncome,
      this.isDeleted});
  LabelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iconName = json['icon'];
    color = json['color'];
    isIncome = json['isInCome'];
    isDeleted = json['isDeleted'];
  }

  static List<LabelModel> fromJsonDynamicList(List<dynamic> list) {
    return list.map((e) => LabelModel.fromJson(e)).toList();
  }
}
