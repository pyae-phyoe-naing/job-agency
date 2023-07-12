import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/pro_exp/pro_exp_cubit.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ProButtonSheet extends StatefulWidget {
  final bool isUpdate;
  const ProButtonSheet({super.key, this.isUpdate = false});

  @override
  State<ProButtonSheet> createState() => ProButtonSheetState();
}

class ProButtonSheetState extends State<ProButtonSheet> {
  late final AuthBloc authBloc = context.read<AuthBloc>();

  late final ProExpCubit _proExpCubit = context.read<ProExpCubit>();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _proExpCubit.dispose();
    _globalKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: SizedBox(
     
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pro Exp',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _globalKey,
              child: TextFormField(
                controller: _proExpCubit.controller,
                validator: (value) =>
                    value?.isEmpty == true ? 'Name is require' : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                    label: Text('Name'), border: OutlineInputBorder()),
              ),
            ),
            BlocBuilder<ProExpCubit, double>(
              builder: (context, state) {
                //   print('Sheet state $state');
                return Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    children: [
                      const Text('Level'),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                              inactiveTrackColor: Colors.white,
                              activeTrackColor: Colors.grey.shade600,
                              trackShape: const RectangularSliderTrackShape(),
                              trackHeight: 25,
                              overlayColor: Colors.transparent,
                              thumbShape: SliderComponentShape.noOverlay),
                          child: Slider(
                            value: state,
                            onChanged: _proExpCubit.onSlide,
                            label: (state * 100).toStringAsFixed(0),
                          ),
                        ),
                      ),
                      SizedBox(
                          width: 40, child: Text("${(state * 100).toInt()}%"))
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  if (_globalKey.currentState?.validate() == true &&
                      authBloc.state.userModel?.user?.uid != null) {
                    StarlightUtils.pop();

                    if (widget.isUpdate) {
                      await _proExpCubit.update(
                        authBloc.state.userModel!.user!.uid,
                      );
                    } else {
                      await _proExpCubit
                          .create(authBloc.state.userModel!.user!.uid);
                    }
                  }
                },
                child: Text(
                  widget.isUpdate ? 'Update' : 'Add',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
