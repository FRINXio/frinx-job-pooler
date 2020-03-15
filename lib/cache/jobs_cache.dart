import 'package:frinx_job_pooler/model/job_state.dart';

import '../model/job_entry.dart';
import '../utils/requests_broker.dart';

class JobsCache {
  static final JobsCache _instance = JobsCache._internal();

  final RequestsBroker _requestsBroker = RequestsBroker();

  factory JobsCache() {
    return _instance;
  }

  JobsCache._internal();

  Future<Map<JobEntry, JobState>> actualJobList;

  Future<Map<JobEntry, JobState>> getCachedJobData() {
    if (actualJobList == null) {
      actualJobList = _requestsBroker.getMyJobData();
    }
    return actualJobList;
  }

  Future<Map<JobEntry, JobState>> refreshJobData() {
    actualJobList = _requestsBroker.getMyJobData();
    return actualJobList;
  }

  Future<Map<JobEntry, JobState>> removeJobEntryFromCache(String jobId) {
    actualJobList = actualJobList.then((originalMap) {
      final Map<JobEntry, JobState> tempMap = Map.of(originalMap);
      tempMap.removeWhere((jobEntry, jobState) => jobEntry.jobId == jobId);
      return tempMap;
    });
    return actualJobList;
  }
}
