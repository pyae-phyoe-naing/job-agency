import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/job_post/job_post_cubit.dart';
import 'package:job_agency/widget/work_components/work_card.dart';

class ManageJobPost extends StatelessWidget {
  const ManageJobPost({super.key});

  @override
  Widget build(BuildContext context) {
    final JobPostCubit jobPostCubit = context.watch<JobPostCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          splashRadius: 20,
        ),
        title: const Text(
          ' Manage Job Post',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        itemCount: jobPostCubit.state.jobPostModelList.length,
        itemBuilder: ((context, index) => WorkCard(
              jobPostModel: jobPostCubit.state.jobPostModelList[index],
              visitor: false,
            )),
      ),
    );
  }
}
