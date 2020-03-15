import 'package:dio/dio.dart';

import '../model/job_entry.dart';
import '../model/job_state.dart';

class RequestsBroker {
  static const DOMAIN = "http://10.103.5.14:8080/api/workflow";
  static const URL_ALL_JOBS = "/running/create_operator_job";
  static const CLIENT_TIMEOUT = 5000;

  static final RequestsBroker _instance = RequestsBroker._internal();

  final Dio _restClient = new Dio(BaseOptions(
      receiveTimeout: CLIENT_TIMEOUT, connectTimeout: CLIENT_TIMEOUT));

  factory RequestsBroker() {
    return _instance;
  }

  RequestsBroker._internal();

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
    var response = await _restClient.post(DOMAIN, data: body);
    return response;
  }

  Future<Response> postFinishingJob(String id) async {
    Map<String, String> input = {'sourceWorkflowId': id};
    Map<String, dynamic> body = {
      'name': "job_installation_completed",
      'version': 1,
      'input': input
    };
    var response = await _restClient.post(DOMAIN, data: body);
    return response;
  }

  Future<Map<JobEntry, JobState>> getMyJobData() async {
    var response = await _restClient.get(DOMAIN + URL_ALL_JOBS);

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
    var response = await _restClient.get(DOMAIN + "/" + workflow);
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

  static _getJobStateString(JobState jobState) {
    return jobState
        .toString()
        .substring(JobState.wait_for_acceptance.toString().indexOf('.') + 1);
  }
}
