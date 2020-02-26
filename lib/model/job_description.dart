class JobDescription {
  final int jobId;
  final String jobTitle;
  final String description;
  final String location;
  final JobCoordinates jobCoordinates;

  JobDescription(this.jobId, this.jobTitle,
      {this.description, this.location, this.jobCoordinates});
}

class JobCoordinates {
  final double latitude;
  final double longitude;

  JobCoordinates(this.latitude, this.longitude);
}
