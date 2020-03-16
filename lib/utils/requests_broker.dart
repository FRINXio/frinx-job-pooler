import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/job_entry.dart';
import '../model/job_state.dart';
import 'shared_constants.dart';

class RequestsBroker {
  static final RequestsBroker _instance = RequestsBroker._internal();

  Future<SharedPreferences> sharedPreferencesFuture;
  Future<Dio> _restClientFuture;

  factory RequestsBroker() {
    return _instance;
  }

  RequestsBroker._internal() {
    sharedPreferencesFuture = SharedPreferences.getInstance();
    _restClientFuture = sharedPreferencesFuture.then((prefs) {
      var clientTimeout =
          prefs.getInt(SharedConstants.PREFS_HTTP_CLIENT_TIMEOUT);
      return new Dio(BaseOptions(
          receiveTimeout: clientTimeout, connectTimeout: clientTimeout));
    });
  }

  Future<Response> postAcceptingJob(String id) async {
    Map<String, String> input = {
      'sourceWorkflowId': id,
      'operator_id': "gwieser"
    };
    Map<String, dynamic> body = {
      'name': "accept_operator_job",
      'version': 1,
      'input': input
    };
    var restClient = await _restClientFuture;
    var domain = await _getDomain();
    var response = await restClient.post(domain, data: body);
    return response;
  }

  Future<Response> postFinishingJob(String id) async {
    Map<String, String> input = {'sourceWorkflowId': id};
    Map<String, dynamic> body = {
      'name': "job_installation_completed",
      'version': 1,
      'input': input
    };
    var restClient = await _restClientFuture;
    var domain = await _getDomain();
    var response = await restClient.post(domain, data: body);
    return response;
  }

  Future<Map<JobEntry, JobState>> getMyJobData() async {
    var restClient = await _restClientFuture;
    var domain = await _getDomain();
    var urlAllJobs = await _getUrlOfAllJobs();
    var response = await restClient.get(domain + urlAllJobs);

    final List<dynamic> responseAllJobsDynamic =
        response.data.map((dynamic model) => model).toList();
    final List<String> responseAllJobs =
        responseAllJobsDynamic.cast<String>().toList();

    final List<Future<MapEntry<JobEntry, JobState>>> jobEntries = [];
    responseAllJobs.forEach((workflow) {
      Future<MapEntry<JobEntry, JobState>> jobEntry =
          _getOneMyJobData(workflow);
      jobEntries.add(jobEntry);
    });

    return Future.wait(jobEntries).then((mapEntries) {
      final Map<JobEntry, JobState> outputMap = {};
      mapEntries.forEach(
          (entry) => outputMap.putIfAbsent(entry.key, () => entry.value));
      return outputMap;
    });
  }

  Future<MapEntry<JobEntry, JobState>> _getOneMyJobData(String workflow) async {
    var restClient = await _restClientFuture;
    var domain = await _getDomain();
    var response = await restClient.get(domain + "/" + workflow);
    MapEntry<JobEntry, JobState> jobData;
    response.data['tasks'].forEach((element) {
      if (element["status"] == "IN_PROGRESS") {
        if (element["taskDefName"] ==
            _getJobStateString(JobState.wait_for_acceptance)) {
          jobData = MapEntry(
              JobEntry.fromJson(response.data), JobState.wait_for_acceptance);
        } else if (element["taskDefName"] ==
            _getJobStateString(JobState.wait_for_installation_complete)) {
          jobData = MapEntry(JobEntry.fromJson(response.data),
              JobState.wait_for_installation_complete);
        }
      }
    });
    return jobData;
  }

  Future<String> _getDomain() async {
    var prefs = await sharedPreferencesFuture;
    var ipAddress = prefs.getString(SharedConstants.PREFS_IP_ADDRESS);
    var port = prefs.get(SharedConstants.PREFS_PORT);
    return "http://$ipAddress:$port/api/workflow";
  }

  Future<String> _getUrlOfAllJobs() async {
    var prefs = await sharedPreferencesFuture;
    var jobPoolName = prefs.getString(SharedConstants.PREFS_JOB_POOL_NAME);
    return "/running/$jobPoolName";
  }

  static _getJobStateString(JobState jobState) {
    return jobState
        .toString()
        .substring(JobState.wait_for_acceptance.toString().indexOf('.') + 1);
  }
}
