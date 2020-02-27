import 'package:frinx_job_pooler/model/job_description.dart';
import 'package:frinx_job_pooler/model/job_state.dart';
import 'package:frinx_job_pooler/utils/apiFunctions/requests.dart';

class JobsCache {
  static final JobsCache _instance = JobsCache._internal();

  factory JobsCache() {
    return _instance;
  }

  JobsCache._internal();

  Future<List<JobDescription>> actualJobList;

  Future<List<JobDescription>> getCachedJobData() {
    if (actualJobList == null) {
      actualJobList = getMyJobData();
    }
    return actualJobList;
  }

  Future<List<JobDescription>> refreshJobData() {
    actualJobList = getMyJobData();
    return actualJobList;
  }

  Future<List<JobDescription>> removeJobEntryFromCache(int jobId) {
    actualJobList = actualJobList.then((list) {
      list.removeWhere((entry) => entry.jobId == jobId);
      return list;
    });
    return actualJobList;
  }

  Future<List<JobDescription>> _getMyJobData() async {
    return [
      JobDescription.myJobs(1.toString(), 'Job 1',
          description: 'This is the first job',
          location: 'Mlynské nivy 4959/48,\n821 09 Bratislava,\Slovakia',
          jobCoordinates: JobCoordinates(-3.823216, -38.481700),
          workflowOutput: "Configuration completed successfully.\n"
              "Post installation checks completed successfully.\n"
              "Job duration: 1hr 23min\n"
              "Job is finished. Thank you!",
          jobState: JobState.wait_for_installation_complete),
      JobDescription.myJobs(2.toString(), 'Job 2',
          description: 'This is the second job',
          location: 'Mlynské nivy 4959/48,\n821 09 Bratislava,\Slovakia',
          jobCoordinates: JobCoordinates(-3.823216, -38.481700),
          workflowOutput: "Configuration completed successfully.\n"
              "Post installation checks completed successfully.\n"
              "Job duration: 1hr 23min\n"
              "Job is finished. Thank you!",
          jobState: JobState.wait_for_installation_complete)
    ];
  }
}
