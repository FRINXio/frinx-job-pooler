import 'package:frinx_job_pooler/model/job_description.dart';
import 'package:frinx_job_pooler/rest/requests_broker.dart';

class JobsCache {
  static final JobsCache _instance = JobsCache._internal();

  final RequestsBroker _requestsBroker = RequestsBroker();

  factory JobsCache() {
    return _instance;
  }

  JobsCache._internal();

  Future<List<JobDescription>> actualJobList;

  Future<List<JobDescription>> getCachedJobData() {
    if (actualJobList == null) {
      actualJobList = _requestsBroker.getMyJobData();
    }
    return actualJobList;
  }

  Future<List<JobDescription>> refreshJobData() {
    actualJobList = _requestsBroker.getMyJobData();
    return actualJobList;
  }

  Future<List<JobDescription>> removeJobEntryFromCache(String jobId) {
    actualJobList = actualJobList.then((list) {
      List<JobDescription> tempList = List.of(list);
      tempList.removeWhere((entry) => entry.jobId == jobId);
      return tempList;
    });
    return actualJobList;
  }
}
