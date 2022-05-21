class StatisticsResponse {
  int? id;
  String? fullName;
  String? username;
  String? email;
  String? role;
  String? createdAt;
  String? updatedAt;
  List<Statistics>? statistics;
  List<NewCustomer>? newCustomers;

  StatisticsResponse({
    this.id,
    this.fullName,
    this.username,
    this.email,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.statistics,
    this.newCustomers,
  });

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
    if (json['newCustomers'] != null) {
      newCustomers = [];
      json['newCustomers'].forEach((customer) {
        newCustomers!.add(NewCustomer.fromJson(customer));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['full_name'] = fullName;
    data['username'] = username;
    data['email'] = email;
    data['role'] = role;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (statistics != null) {
      data['statistics'] = statistics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewCustomer {
  int? id;
  String? name;
  String? phoneNumber;
  String? createdAt;
  String? updatedAt;

  NewCustomer(
      {this.id, this.name, this.phoneNumber, this.createdAt, this.updatedAt});

  NewCustomer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
        dailyReport!.add(DailyReport.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['average_all_response_time'] = averageAllResponseTime;
    data['all_unread_message_count'] = allUnreadMessageCount;
    if (dailyReport != null) {
      data['dailyReport'] = dailyReport!.map((v) => v.toJson()).toList();
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
    date = json['date'];
    average = json['average'].toDouble();
    lateResponse = json['late_response'];
    unreadMessage = json['unread_message'];
    if (json['responseTimes'] != null) {
      responseTimes = <ResponseTimes>[];
      json['responseTimes'].forEach((v) {
        responseTimes!.add(ResponseTimes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['date'] = date;
    data['average'] = average;
    data['late_response'] = lateResponse;
    data['unread_message'] = unreadMessage;
    if (responseTimes != null) {
      data['responseTimes'] = responseTimes!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = {};
    data['question'] = question;
    data['answer'] = answer;
    data['formattedString'] = formattedString;
    data['seconds'] = seconds;
    return data;
  }
}
