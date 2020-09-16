import 'package:flutter_olx/Model/TeamMember.dart';

class Team{
  String name,id;
  List<TeamMember> members=[];





  Team(this.name, this.id);

  static Team fromJson(data){
    return Team(data['team_name'],data['id']);
  }

}
