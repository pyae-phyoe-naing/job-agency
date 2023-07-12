import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/job_post/job_post_cubit.dart';

class WorkFilter extends StatefulWidget {
  const WorkFilter({super.key});

  @override
  State<WorkFilter> createState() => _WorkFilterState();
}

class _WorkFilterState extends State<WorkFilter> {
  final TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    JobPostCubit cubit = context.watch<JobPostCubit>();
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Sort By'),
          TextButton(
              onPressed: () {
                cubit.emitter(sortByDate: false, sortByName: false, amount: 0);
                controller.clear();
              },
              child: const Text('Reset Sort'))
        ],
      ),
      content: SizedBox(
        height: 150,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Name'),
              Switch(
                  value: cubit.state.sortByName,
                  onChanged: (val) {
                    cubit.emitter(sortByName: val);
                  })
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Date'),
              Switch(
                  value: cubit.state.sortByDate,
                  onChanged: (val) {
                    cubit.emitter(sortByDate: val);
                  })
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Salary'),
              const SizedBox(
                width: 80,
              ),
              Expanded(
                  child: TextFormField(
                controller: controller,
                onFieldSubmitted: (amount) {
                  cubit.emitter(
                      amount: double.parse(amount.isEmpty
                          ? '0'
                          : double.tryParse(amount) == null
                              ? '0'
                              : amount));
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'amount'),
              ))
            ],
          ),
        ]),
      ),
    );
  }
}
