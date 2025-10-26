class Job {
  final String title;
  final String description;
  final String location;
  final String? wage;        // wage field
  final String? feedback;    // feedback field
  final double? rating;      // rating field
  final String? contactNo;   // contact no field
  final String skillRequired;

  Job({
    required this.title,
    required this.description,
    required this.location,
    this.wage,
    this.feedback,
    this.rating,
    this.contactNo,
    required this.skillRequired,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'location': location,
    'wage': wage,
    'feedback': feedback,
    'rating': rating,
    'contactNo': contactNo,
    'skillRequired': skillRequired,
  };

  factory Job.fromMap(Map<dynamic, dynamic> map) => Job(
    title: map['title'] as String,
    description: map['description'] as String,
    location: map['location'] as String,
    wage: map['wage'] as String?,
    feedback: map['feedback'] as String?,
    rating: (map['rating'] as num?)?.toDouble(),
    contactNo: map['contactNo'] as String?,
    skillRequired: map['skillRequired'] as String,
  );
}
