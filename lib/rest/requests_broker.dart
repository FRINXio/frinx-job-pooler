import 'package:dio/dio.dart';
import 'package:frinx_job_pooler/model/job_description.dart';
import 'package:frinx_job_pooler/model/job_state.dart';

class RequestsBroker {
  static const String DOMAIN = "http://10.103.5.14:8080/api/workflow";
  static const String URL_ALL_JOBS = "/running/create_operator_job";

  static final RequestsBroker _instance = RequestsBroker._internal();

  final Dio _restClient = new Dio(BaseOptions(
      receiveTimeout: 5000,
      connectTimeout: 5000));

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

  Future<List<JobDescription>> getMyJobData() async {
    var response = await _restClient.get(DOMAIN + URL_ALL_JOBS);

    List<dynamic> responseAllJobsDynamic =
        response.data.map((dynamic model) => model).toList();
    List<String> responseAllJobs =
        responseAllJobsDynamic.cast<String>().toList();

    List<Future<JobDescription>> jobDescriptions = [];
    responseAllJobs.forEach((workflow) {
      Future<JobDescription> _jobDescription = _getOneMyJobData(workflow);
      jobDescriptions.add(_jobDescription);
    });

    return Future.wait(jobDescriptions);
  }

  Future<JobDescription> _getOneMyJobData(String workflow) async {
    var response = await _restClient.get(DOMAIN + "/" + workflow);
    JobDescription jobDescription;
    response.data['tasks'].forEach((element) {
      if (element["status"] == "IN_PROGRESS") {
        if (element["taskDefName"] ==
            _getJobStateString(JobState.wait_for_acceptance)) {
          jobDescription = JobDescription.fromJson(
              response.data, JobState.wait_for_acceptance);
        } else if (element["taskDefName"] ==
            _getJobStateString(JobState.wait_for_installation_complete)) {
          jobDescription = JobDescription.fromJson(
              response.data, JobState.wait_for_installation_complete);
        }
      }
    });
    return jobDescription;
  }

  static _getJobStateString(JobState jobState) {
    return jobState
        .toString()
        .substring(JobState.wait_for_acceptance.toString().indexOf('.') + 1);
  }
}
