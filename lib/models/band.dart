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
      id:    data.containsKey('id') ? data['id'] : 'no-id', 
      name:  data.containsKey('name') ? data['name'] : 'no-name', 
      votes: data.containsKey('votes') ? data['votes'] : 0
    );
  }

}