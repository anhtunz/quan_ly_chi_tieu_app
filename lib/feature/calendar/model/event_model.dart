// class BaseEventModel {
//   int? totalIncome;
//   int? totalOutcome;
//   BaseEventModel({this.totalIncome, this.totalOutcome});
//   BaseEventModel.fromJson(Map<String, dynamic> json) {
//     totalIncome = json['totalInCome'];
//     totalOutcome = json['totlaOutCome'];
//   }
// }

// class Event extends BaseEventModel {
//   int? id;
//   int? name;
//   Event({this.id, this.name, super.totalIncome, super.totalOutcome});

//   Event.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
//     id = json['id'];
//     name = json['name'];
//   }
// }

class EventModel {
  int? totalIncome;
  int? totalOutcome;
  List<Events>? events;

  EventModel({this.totalIncome, this.totalOutcome, this.events});

  EventModel.fromJson(Map<String, dynamic> json) {
    totalIncome = json['totalInCome'];
    totalOutcome = json['totlaOutCome'];
    if (json['datas'] != null) {
      events = [];
      json['datas'].forEach((v) {
        events!.add(Events.fromJson(v));
      });
    }
  }
}

class Events {
  int? id;
  String? name;
  int? money;
  String? labelName;
  int? labelId;
  String? icon;
  String? color;
  bool? isIncome;
  DateTime? inDate;
  List<EventImages>? images;

  Events(
      {this.id,
      this.name,
      this.money,
      this.labelId,
      this.labelName,
      this.icon,
      this.color,
      this.isIncome,
      this.images});

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['description'];
    money = json['money'];
    labelName = json['labelName'];
    labelId = json['labelId'];
    icon = json['icon'];
    color = json['color'];
    isIncome = json['isInCome'];
    inDate = DateTime.parse(json['dateUse']);
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images!.add(EventImages.fromJson(v));
      });
    }
  }
  static List<Events> fromJsonDynamicList(List<dynamic> list) {
    return list.map((e) => Events.fromJson(e)).toList();
  }
}

class EventImages {
  int? id;
  String? imageUrl;
  EventImages({this.id, this.imageUrl});
  EventImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['url'];
  }
}

class YearlyDataModel {
  int? totalIncome;
  int? totalOutcome;
  List<MonthInYearData>? monthData;
  YearlyDataModel({this.totalIncome, this.totalOutcome, this.monthData});

  YearlyDataModel.fromJson(Map<String, dynamic> json) {
    totalIncome = json['totalInCome'];
    totalOutcome = json['totalOutCome'];
    if (json['datas'] != null) {
      monthData = [];
      json['datas'].forEach(
        (v) {
          monthData!.add(MonthInYearData.fromJson(v));
        },
      );
    }
  }
}

class MonthInYearData {
  int? month;
  int? totalIncome;
  int? totalOutcome;

  MonthInYearData({this.month, this.totalIncome, this.totalOutcome});

  MonthInYearData.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    totalIncome = json['totalInCome'];
    totalOutcome = json['totalOutCome'];
  }
  static List<MonthInYearData> fromJsonDynamicList(List<dynamic> list) {
    return list.map((e) => MonthInYearData.fromJson(e)).toList();
  }
}
