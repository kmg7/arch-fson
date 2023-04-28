import 'package:mobx/mobx.dart';
part 'upload_file_view_model.g.dart';

class UploadFileViewModel = UploadFileViewModelBase with _$UploadFileViewModel;

abstract class UploadFileViewModelBase with Store {
  @observable
  double uploadAmount = 0;

  @action
  void updateUploadAmount(double num) {
    uploadAmount = num;
  }

  String get amountPercent => (uploadAmount * 100).toInt().toString();
}
