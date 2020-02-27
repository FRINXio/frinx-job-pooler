import 'package:dio/dio.dart';
import 'package:frinx_job_pooler/model/job_description.dart';
import 'package:frinx_job_pooler/model/job_state.dart';

const String DOMAIN = "http://10.103.5.14:8080/api/workflow";
const String URL_ALL_JOBS = "/running/create_operator_job";

/*

Start workflow for accepting job (click on accept job button):

POST [http://%7b%7bhost%7d%7d:8080/api/workflow]http://{{host}}:8080/api/workflow

{

  "name": "accept_operator_job",

  "version": 1,

  "input": {

                  "sourceWorkflowId": "00de7fab-e6f1-4f89-8db7-e9c1539cf7dd",

                  "operator_id": "gwieser"

  }

}

 */

Future<Response> postAcceptingJob(String id) async {
//  String url = "http://10.103.5.14:8080/api/workflow";
  try {
    Dio dio = new Dio();

    Map<String, String> input = {
      'sourceWorkflowId': id,
      'operator_id': "gwieser"
    };
    Map<String, dynamic> body = {
      'name': "accept_operator_job",
      'version': 1,
      'input': input
    };
    var response = await dio.post(DOMAIN, data: body);
    return response;
  } catch(err) {
    print(err);
  }
}

Future<Response> postFinishingJob(String id) async {
  try {
    Dio dio = new Dio();
    Map<String, String> input = {
      'sourceWorkflowId': id
    };
    Map<String, dynamic> body = {
      'name': "job_installation_completed",
      'version': 1,
      'input': input
    };
    var response =  await dio.post(DOMAIN, data: body);
    return response;
  } catch(err) {
    print(err);
  }
}

Future<List<JobDescription>> getMyJobData() async {
  List<Future<JobDescription>> jobDescriptions = [];

  try {
    Dio dio = new Dio();
    var response = await dio.get(DOMAIN + URL_ALL_JOBS);

    List<dynamic> responseAllJobsDynamic =
        response.data.map((dynamic model) => model).toList();
    List<String> responseAllJobs =
        responseAllJobsDynamic.cast<String>().toList();

    responseAllJobs.forEach((element) {
      Future<JobDescription> _jobDescription = _getOneMyJobData(element);
      jobDescriptions.add(_jobDescription);
    });

    return Future.wait(jobDescriptions);
  } catch (err) {
    print(err);
    return  Future.wait(jobDescriptions);
  }
}

Future<JobDescription> _getOneMyJobData(String key) async {

  JobDescription jobDescription;
  try {
    Dio dio = new Dio();
    var response = await dio.get(DOMAIN + "/" + key);
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