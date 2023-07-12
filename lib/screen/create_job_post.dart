import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/create_job/create_job_post_cubit.dart';

import 'package:job_agency/global.dart';
import 'package:job_agency/model/job_post_model.dart';

import 'package:job_agency/utils/theme.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateJobPost extends StatefulWidget {
  final JobPostModel? jobPostModel;
  const CreateJobPost({super.key, this.jobPostModel});

  @override
  State<CreateJobPost> createState() => _CreateJobPostState();
}

class _CreateJobPostState extends State<CreateJobPost> {
  late final CreateJobPostCubit _cubit = context.read<CreateJobPostCubit>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleCon = TextEditingController();
  final FocusNode _titleFoc = FocusNode();

  final TextEditingController _requireCon = TextEditingController();
  final FocusNode _requireFoc = FocusNode();

  final TextEditingController _statusCon = TextEditingController();
  final FocusNode _statusFoc = FocusNode();

  final TextEditingController _salaryCon = TextEditingController();
  final FocusNode _salaryFoc = FocusNode();

  final TextEditingController _descCon = TextEditingController();
  final FocusNode _descFoc = FocusNode();

  final TextEditingController _phoneCon = TextEditingController();
  final FocusNode _phoneFoc = FocusNode();

  final TextEditingController _emailCon = TextEditingController();
  final FocusNode _emailFoc = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.jobPostModel != null) {
      final JobPostModel post = widget.jobPostModel!;
      _titleCon.text = post.title;
      _requireCon.text = post.requirement.join(',');
      _statusCon.text = post.status;
      _salaryCon.text = post.salary.toString();
      _descCon.text = post.desc;
      _phoneCon.text = post.phone;
      _emailCon.text = post.email;
      _cubit.setXFileInUpdateCond(post.photo);
      // print(_cubit.state.xFile.path);
    }
  }

  Future<void> create() async {
    if (_formKey.currentState?.validate() == false) return;

    if (_cubit.state.xFile.path.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select photo'),
        backgroundColor: Colors.indigo,
      ));
      _cubit.initial();
      return;
    }
    try {
      _cubit.create();

      if (_cubit.state.xFile.path != widget.jobPostModel?.photo) {
        // Pick Image => Update PickImage and New Create Both Cond
        await firebaseHelper.uploadJobFile(
            xFile: _cubit.state.xFile,
            firestore: (String downloadUrl) async {
              final JobPostModel jobPostModel = JobPostModel(
                  id: widget.jobPostModel?.id ?? '',
                  title: _titleCon.text,
                  photo: widget.jobPostModel?.photo != _cubit.state.xFile.path
                      ? downloadUrl
                      : _cubit.state.xFile.path,
                  desc: _descCon.text,
                  salary: double.parse(_salaryCon.text),
                  requirement: _requireCon.text.split(',').toList(),
                  views: widget.jobPostModel == null
                      ? []
                      : widget.jobPostModel!.views,
                  likes: widget.jobPostModel == null
                      ? null
                      : widget.jobPostModel!.likes,
                  status: _statusCon.text,
                  phone: _phoneCon.text,
                  email: _emailCon.text,
                  createdAt: widget.jobPostModel == null
                      ? DateTime.now()
                      : widget.jobPostModel!.createdAt);

              if (widget.jobPostModel == null) {
                // Create
                await firebaseHelper.create(
                    collectionPath: 'job-post', data: jobPostModel.toJson());
              } else {
                //Update
                await firebaseHelper.update(
                    collectionPath: 'job-post',
                    docPath: widget.jobPostModel!.id,
                    data: jobPostModel.toJson());
              }

              _cubit.initial();
              if (context.mounted) {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: const Text('Success'),
                          content: const Text('Job post uploaded!'),
                          actions: [
                            ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Ok'))
                          ],
                        )).then((value) => Navigator.pop(context));
              }
            });
      } else {
        // Update without Pick Image
        final JobPostModel jobPostModel = JobPostModel(
            id: widget.jobPostModel?.id ?? '',
            title: _titleCon.text,
            photo: _cubit.state.xFile.path,
            desc: _descCon.text,
            salary: double.parse(_salaryCon.text),
            requirement: _requireCon.text.split(',').toList(),
            views: widget.jobPostModel!.views,
            likes: widget.jobPostModel!.likes,
            status: _statusCon.text,
            phone: _phoneCon.text,
            email: _emailCon.text,
            createdAt: widget.jobPostModel!.createdAt);

        await firebaseHelper.update(
            collectionPath: 'job-post',
            docPath: widget.jobPostModel!.id,
            data: jobPostModel.toJson());

        _cubit.initial();
        if (context.mounted) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('Success'),
                    content: const Text('Job post uploaded!'),
                    actions: [
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Ok'))
                    ],
                  )).then((value) => Navigator.pop(context));
        }
      }
    } catch (e) {
      // ToDo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: ThemeUtils.buttonColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          splashRadius: 20,
        ),
        title: Text(
          widget.jobPostModel == null ? 'Create Job Post' : "Update Job Post",
          style: const TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: create,
            child: BlocBuilder<CreateJobPostCubit, JobPostState>(
              builder: (context, state) {
                if (state is CreateJobPostState) {
                  return const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Colors.blue,
                    ),
                  );
                }

                return const Text('Save');
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _cubit.imagePick(),
                    child: BlocBuilder<CreateJobPostCubit, JobPostState>(
                      builder: (context, state) {
                        return Container(
                          width: 100,
                          height: 115,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image:
                                // Is Not Update
                                state.xFile.path.isEmpty
                                    ? null
                                    : DecorationImage(
                                        fit: BoxFit.cover,
                                        image: (widget.jobPostModel == null
                                                ? FileImage(
                                                    File(state.xFile.path),
                                                  )
                                                : widget.jobPostModel?.photo !=
                                                        _cubit.state.xFile.path
                                                    ? FileImage(
                                                        File(state.xFile.path),
                                                      )
                                                    : CachedNetworkImageProvider(
                                                        widget.jobPostModel!
                                                            .photo))
                                            as ImageProvider,
                                      ),
                          ),
                          child: state.xFile.path.isEmpty &&
                                  widget.jobPostModel == null
                              ? const Icon(
                                  Icons.image,
                                  color: Colors.blueAccent,
                                  size: 30,
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleCon,
                          focusNode: _titleFoc,
                          validator: (_) =>
                              _?.isEmpty == true ? "Title is require!" : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onEditingComplete: _requireFoc.requestFocus,
                          cursorColor: Colors.yellow,
                          cursorWidth: 4,
                          decoration: ThemeUtils.inputDec.copyWith(
                            hintText: 'Title',
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _requireCon,
                          focusNode: _requireFoc,
                          validator: (_) => _?.isEmpty == true
                              ? "Requirements is require!"
                              : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onEditingComplete: _statusFoc.requestFocus,
                          cursorColor: Colors.yellow,
                          cursorWidth: 4,
                          decoration: ThemeUtils.inputDec.copyWith(
                              hintText: 'Requirements',
                              helperText: "Engineer , Teacher , Doctor"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _statusCon,
                focusNode: _statusFoc,
                validator: (_) =>
                    _?.isEmpty == true ? "Status is require!" : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onEditingComplete: _salaryFoc.requestFocus,
                keyboardType: TextInputType.number,
                cursorColor: Colors.yellow,
                cursorWidth: 4,
                decoration: ThemeUtils.inputDec.copyWith(
                  hintText: 'Status',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _salaryCon,
                focusNode: _salaryFoc,
                validator: (_) => _?.isEmpty == true
                    ? "Salary is require!"
                    : double.tryParse(_!) == null
                        ? 'Salary must be number!'
                        : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onEditingComplete: _descFoc.requestFocus,
                keyboardType: TextInputType.number,
                cursorColor: Colors.yellow,
                cursorWidth: 4,
                decoration: ThemeUtils.inputDec.copyWith(
                  hintText: 'Salary',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _descCon,
                focusNode: _descFoc,
                validator: (_) =>
                    _?.isEmpty == true ? "Description is require!" : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLines: 7,
                cursorColor: Colors.yellow,
                cursorWidth: 4,
                decoration: ThemeUtils.inputDec.copyWith(
                  hintText: 'Description',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _phoneCon,
                focusNode: _phoneFoc,
                validator: (_) =>
                    _?.isEmpty == true ? "Phone is require!" : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onEditingComplete: _emailFoc.requestFocus,
                keyboardType: TextInputType.phone,
                cursorColor: Colors.yellow,
                cursorWidth: 4,
                decoration: ThemeUtils.inputDec.copyWith(
                  hintText: 'Phone',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _emailCon,
                focusNode: _emailFoc,
                validator: (_) => _?.isEmpty == true
                    ? "Email is require!"
                    : _!.isEmail == false
                        ? 'Not email format!'
                        : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onEditingComplete: _emailFoc.unfocus,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.yellow,
                cursorWidth: 4,
                decoration: ThemeUtils.inputDec.copyWith(
                  hintText: 'Email',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
