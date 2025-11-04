// import 'package:get/get.dart';
// import 'package:testemu/core/utils/enum/enum.dart';
// import '../../data/model/html_model.dart';

// class TermsOfServicesController extends GetxController {
//   /// Api status check here
//   Status status = Status.completed;

//   ///  HTML model initialize here
//   HtmlModel data = HtmlModel.fromJson({});

//   /// Terms of services Controller instance create here
//   static TermsOfServicesController get instance =>
//       Get.put(TermsOfServicesController());

//   ///  Terms of services Api call here
//   geTermsOfServicesRepo() async {
//     return;
//     // status = Status.loading;
//     // update();

//     // var response = await ApiService.get(ApiEndPoint.termsOfServices);

//     // if (response.statusCode == 200) {
//     //   data = HtmlModel.fromJson(response.data['data']['attributes']);

//     //   status = Status.completed;
//     //   update();
//     // } else {
//     //   Utils.errorSnackBar(response.statusCode, response.message);
//     //   status = Status.error;
//     //   update();
//     // }
//   }

//   /// Controller on Init here
//   @override
//   void onInit() {
//     geTermsOfServicesRepo();
//     super.onInit();
//   }
// }
