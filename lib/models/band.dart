class Band {
  
  String id;
  String name;
  int votes;

  Band({
    required this.id,
    required this.name,
    required this.votes
  });

  factory Band.fromMap( Map<String, dynamic> data ) {
    return Band(
      id: data['id'], 
      name: data['name'], 
      votes: data['votes']
    );
  }

}