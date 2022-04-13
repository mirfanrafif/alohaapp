class StatisticsResponse {
  int? id;
  String? fullName;
  String? username;
  String? email;
  String? role;
  String? createdAt;
  String? updatedAt;
  List<Statistics>? statistics;

  StatisticsResponse(
      {this.id,
      this.fullName,
      this.username,
      this.email,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.statistics});

  StatisticsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    username = json['username'];
    email = json['email'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['statistics'] != null) {
      statistics = <Statistics>[];
      json['statistics'].forEach((v) {
        statistics!.add(Statistics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['username'] = this.username;
    data['email'] = this.email;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.statistics != null) {
      data['statistics'] = this.statistics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Statistics {
  int? id;
  String? name;
  String? phoneNumber;
  String? createdAt;
  String? updatedAt;
  double? averageAllResponseTime;
  int? allUnreadMessageCount;
  List<DailyReport>? dailyReport;

  Statistics(
      {this.id,
      this.name,
      this.phoneNumber,
      this.createdAt,
      this.updatedAt,
      this.averageAllResponseTime,
      this.allUnreadMessageCount,
      this.dailyReport});

  Statistics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    averageAllResponseTime = json['average_all_response_time'].toDouble();
    allUnreadMessageCount = json['all_unread_message_count'];
    if (json['dailyReport'] != null) {
      dailyReport = <DailyReport>[];
      json['dailyReport'].forEach((v) {
        dailyReport!.add(new DailyReport.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['average_all_response_time'] = this.averageAllResponseTime;
    data['all_unread_message_count'] = this.allUnreadMessageCount;
    if (this.dailyReport != null) {
      data['dailyReport'] = this.dailyReport!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyReport {
  String? date;
  double? average;
  int? lateResponse;
  int? unreadMessage;
  List<ResponseTimes>? responseTimes;

  DailyReport(
      {this.date,
      this.average,
      this.lateResponse,
      this.unreadMessage,
      this.responseTimes});

  DailyReport.fromJson(Map<String, dynamic> json) {
    print(json);
    date = json['date'];
    average = json['average'].toDouble();
    lateResponse = json['late_response'];
    unreadMessage = json['unread_message'];
    if (json['responseTimes'] != null) {
      responseTimes = <ResponseTimes>[];
      json['responseTimes'].forEach((v) {
        responseTimes!.add(new ResponseTimes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['average'] = this.average;
    data['late_response'] = this.lateResponse;
    data['unread_message'] = this.unreadMessage;
    if (this.responseTimes != null) {
      data['responseTimes'] =
          this.responseTimes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseTimes {
  String? question;
  String? answer;
  String? formattedString;
  double? seconds;

  ResponseTimes(
      {this.question, this.answer, this.formattedString, this.seconds});

  ResponseTimes.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
    formattedString = json['formattedString'];
    seconds = json['seconds'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['formattedString'] = this.formattedString;
    data['seconds'] = this.seconds;
    return data;
  }
}
