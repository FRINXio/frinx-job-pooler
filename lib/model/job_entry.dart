import 'job_state.dart';

class JobEntry {
  final String jobId;
  final String jobTitle;
  final String description;
  final String location;
  final JobCoordinates jobCoordinates;
  final JobState jobState;
  final String workflowOutput;

  JobEntry.fromJson(Map<String, dynamic> json, JobState jobState)
      : jobId = json['workflowId'],
        jobTitle = json["input"]["job_name"],
        description = json["input"]["job_description"],
        location = json["input"]["location"],
        jobCoordinates = null,
        workflowOutput = null,
        jobState = jobState;
}

class JobCoordinates {
  final double latitude;
  final double longitude;

  JobCoordinates(this.latitude, this.longitude);
}
