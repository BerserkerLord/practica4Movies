class Actor{
  String? name;
  String? profilePath;
  String? character;

  Actor({
    this.name,
    this.profilePath,
    this.character
  });

  factory Actor.fromMap(Map<String, dynamic> map){
    return Actor(
      name: map['name'],
      profilePath: map['profile_path'],
      character: map['character']
    );
  }
}