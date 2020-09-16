class TeamMember {
  TeamMember({
    this.id,
    this.teamId,
    this.subUserId,
    this.name,
    this.email,
    this.teamName,
    this.role,
    this.password,
    this.date,
  });

  String id;
  String teamId;
  String subUserId;
  String name;
  String email;
  String teamName;
  String role;
  String password;
  DateTime date;

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
    id: json["id"],
    teamId: json["team_id"],
    subUserId: json["sub_user_id"],
    name: json["name"],
    email: json["email"],
    teamName: json["team_name"],
    role: json["role"],
    password: json["password"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "team_id": teamId,
    "sub_user_id": subUserId,
    "name": name,
    "email": email,
    "team_name": teamName,
    "role": role,
    "password": password,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}
