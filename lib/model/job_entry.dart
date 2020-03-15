class JobEntry {
  final String jobId;
  final String jobTitle;
  final String description;
  final String location;
  final JobCoordinates jobCoordinates;
  final String workflowOutput;

  JobEntry.fromJson(Map<String, dynamic> json)
      : jobId = json['workflowId'],
        jobTitle = json["input"]["job_name"],
        description = json["input"]["job_description"],
        location = json["input"]["location"],
        jobCoordinates = null,
        workflowOutput = null;
}

class JobCoordinates {
  final double latitude;
  final double longitude;

  const JobCoordinates(this.latitude, this.longitude);
}
