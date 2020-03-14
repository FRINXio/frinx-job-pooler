import 'package:dio/dio.dart';

import '../model/job_entry.dart';
import '../model/job_state.dart';

class RequestsBroker {
  static const DOMAIN = "http://10.103.5.14:8080/api/workflow";
  static const URL_ALL_JOBS = "/running/create_operator_job";
  static const CLIENT_TIMEOUT = 5000;

  static final RequestsBroker _instance = RequestsBroker._internal();

  final Dio _restClient = new Dio(BaseOptions(
      receiveTimeout: CLIENT_TIMEOUT,
      connectTimeout: CLIENT_TIMEOUT));

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

  Future<List<JobEntry>> getMyJobData() async {
    var response = await _restClient.get(DOMAIN + URL_ALL_JOBS);

    List<dynamic> responseAllJobsDynamic =
        response.data.map((dynamic model) => model).toList();
    List<String> responseAllJobs =
        responseAllJobsDynamic.cast<String>().toList();

    List<Future<JobEntry>> jobEntries = [];
    responseAllJobs.forEach((workflow) {
      Future<JobEntry> jobEntry = _getOneMyJobData(workflow);
      jobEntries.add(jobEntry);
    });

    return Future.wait(jobEntries);
  }

  Future<JobEntry> _getOneMyJobData(String workflow) async {
    var response = await _restClient.get(DOMAIN + "/" + workflow);
    JobEntry jobEntry;
    response.data['tasks'].forEach((element) {
      if (element["status"] == "IN_PROGRESS") {
        if (element["taskDefName"] ==
            _getJobStateString(JobState.wait_for_acceptance)) {
          jobEntry =
              JobEntry.fromJson(response.data, JobState.wait_for_acceptance);
        } else if (element["taskDefName"] ==
            _getJobStateString(JobState.wait_for_installation_complete)) {
          jobEntry = JobEntry.fromJson(
              response.data, JobState.wait_for_installation_complete);
        }
      }
    });
    return jobEntry;
  }

  static _getJobStateString(JobState jobState) {
    return jobState
        .toString()
        .substring(JobState.wait_for_acceptance.toString().indexOf('.') + 1);
  }
}
