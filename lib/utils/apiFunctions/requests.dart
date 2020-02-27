import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frinx_job_pooler/model/job_description.dart';
import 'package:frinx_job_pooler/model/job_state.dart';

const DOMAIN = "http://10.103.5.14:8080/api/workflow/";
const URL_ALL_JOBS = "/running/operator_job_01";

//Future<Response> postRequest(String url, Map<String, String> body, String token) async {
//  Dio dio = new Dio();
//  var _headers;
//  if (token != null) {
//    _headers = {
//      HttpHeaders.authorizationHeader: token,
//      HttpHeaders.contentTypeHeader: "application/json",
//      HttpHeaders.acceptHeader: "*/*"
//    };
//  } else {
//    _headers = {
//      HttpHeaders.contentTypeHeader: "application/json",
//      HttpHeaders.acceptHeader: "*/*"
//    };
//  }
//  return await dio.post(DOMAIN + url, data: body, options: Options(headers: _headers));
//}

Future<List<JobDescription>> getMyJobData() async {
  String DOMAIN = "http://10.103.5.14:8080/api/workflow/";
  String URL_ALL_JOBS = "running/create_operator_job";

  List<JobDescription> jobDescriptions = [];

  try {
    Dio dio = new Dio();
    var response = await dio.get(DOMAIN + URL_ALL_JOBS);

    List<dynamic> responseAllJobsDynamic = response.data.map((dynamic model) => model).toList();
    List<String> responseAllJobs = responseAllJobsDynamic.cast<String>().toList();

    responseAllJobs.forEach((element) async {
      JobDescription _jobDescription = await _getOneMyJobData(element);
      jobDescriptions.add(_jobDescription);
    });


    return jobDescriptions;
  } catch(err) {
    print(err);
    return jobDescriptions;
  }
}

Future<JobDescription> _getOneMyJobData(String key) async {
  String DOMAIN = "http://10.103.5.14:8080/api/workflow/";

  JobDescription jobDescription;
  try {
    Dio dio = new Dio();
    var response = await dio.get(DOMAIN + key);
    response.data['tasks'].forEach((element) {
      if (element["status"] == "IN_PROGRESS") {
        if(element["taskDefName"] == _getJobStateString(JobState.wait_for_acceptance)) {
          jobDescription = JobDescription.fromJson(response.data, JobState.wait_for_acceptance);
        }
        else if(element["taskDefName"] == _getJobStateString(JobState.wait_for_installation_complete)) {
          jobDescription = JobDescription.fromJson(response.data, JobState.wait_for_installation_complete);
        }
      }
    });
    return jobDescription;
  } catch(err) {
    print(err);
    return null;
  }
}

_getJobStateString(JobState jobState) {
  return jobState.toString().substring(JobState.wait_for_acceptance.toString().indexOf('.') + 1);
}