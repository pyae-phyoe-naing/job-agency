import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_agency/global.dart';

class CreateJobPostCubit extends Cubit<JobPostState> {
  CreateJobPostCubit([XFile? xFile])
      : super(JobPostInitialState(xFile ?? XFile('')));

  Future<void> imagePick() async {
    XFile? xfile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      emit(JobPostPickImageState(xfile));
    }
  }

  void setXFileInUpdateCond(String file) => emit(JobPostPickImageState(XFile(file)));
  void create() => emit(CreateJobPostState(state.xFile));
  void initial() => emit(JobPostInitialState(XFile('')));
  void error() => emit(JobPostErrorState(state.xFile));
}

abstract class JobPostState {
  final XFile xFile;
  JobPostState(this.xFile);
}

class JobPostInitialState extends JobPostState {
  JobPostInitialState(XFile xFile) : super(xFile);
}

class CreateJobPostState extends JobPostState {
  CreateJobPostState(XFile xFile) : super(xFile);
}

class JobPostPickImageState extends JobPostState {
  JobPostPickImageState(XFile xFile) : super(xFile);
}

class JobPostErrorState extends JobPostState {
  JobPostErrorState(XFile xFile) : super(xFile);
}
