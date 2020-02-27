import 'package:frinx_job_pooler/model/job_state.dart';

class JobDescription {
  final String jobId;
  final String jobTitle;
  final String description;
  final String location;
  final JobCoordinates jobCoordinates;
  final JobState jobState;
  String workflowOutput;

  JobDescription(this.jobId, this.jobTitle,
      {this.description, this.location, this.jobCoordinates, this.jobState});

  JobDescription.myJobs(this.jobId, this.jobTitle,
      {this.description, this.location, this.jobCoordinates,
        this.workflowOutput, this.jobState});

  JobDescription.fromJson(Map<String, dynamic> json, JobState jobState)
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
