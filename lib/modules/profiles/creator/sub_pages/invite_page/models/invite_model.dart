class InviteModel{
  int id,inviter;
  String inviteEmail,createdAt;
  InviteModel({this.id,this.inviteEmail,this.createdAt,this.inviter});
  factory InviteModel.fromMap(Map<String,dynamic> json){
    return new InviteModel(
      createdAt: json['created_at'],
      id: json['id'],
      inviteEmail: json['invite_email'],
      inviter: json['inviter']
    );
  }
}