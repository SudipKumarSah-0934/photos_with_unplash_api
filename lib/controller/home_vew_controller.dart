import 'package:get/get.dart';
import 'package:photos_with_unplash_api/models/photos_model.dart';
import 'package:photos_with_unplash_api/service/api_service.dart';

class HomeViewController extends GetxController{
  var selectedIndex = 0.obs;
  RxList<PhotosModel> photos =RxList();
  RxBool isLoading = true.obs;
  RxString ordersBy = 'latest'.obs;
  List<String>orders=[
    'latest','oldest','popular','views',
  ];
  getPhotos() async{
    isLoading.value =true;
    var response = await ApiService().getMethod('https://api.unsplash.com/photos/?per_page=30&order_by=${ordersBy.value}&client_id=dmBjIcTCWhQ7wKqk8X6xix44b75p-H9dpxVlQScGFfc');
    photos=RxList();
    if(response.statusCode==200){
      response.data.forEach((elm){
        photos.add(PhotosModel.fromJson(elm));
      });
      isLoading.value =false;
    }
  }
  orderFunc(String newVal){
    ordersBy.value=newVal;
    getPhotos();
  }
  @override
  void onInit() {
    getPhotos();
    super.onInit();
  }
}