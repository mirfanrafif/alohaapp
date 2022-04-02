class AgentEntity {
  int id;
  String fullName;
  String username;
  String email;
  String role;
  String? profilePhoto;

  AgentEntity(
      {required this.id,
        required this.fullName,
        required this.username,
        required this.email,
        required this.role,
        this.profilePhoto});
}