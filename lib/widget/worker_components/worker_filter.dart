import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/worker/worker_cubit.dart';

class WorkerFilter extends StatefulWidget {
  const WorkerFilter({super.key});

  @override
  State<WorkerFilter> createState() => _WorkerFilterState();
}

class _WorkerFilterState extends State<WorkerFilter> {
  final TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WorkerCubit cubit = context.watch<WorkerCubit>();
    List<String> cities = [];

    for (var worker in cubit.state.workerList) {
      if (worker.city != null) {
        cities.add(worker.city!);
      }
    }
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Sort By'),
          TextButton(
              onPressed: () {
                cubit.emitter(selectCity: "", sortByName: false, amount: 0);
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
              const Text('City'),
              DropdownButton(
                  hint: const Text('Select City'),
                  items: cities
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      cubit.emitter(
                          selectCity:
                              val.toString().replaceAll(' ', '').toLowerCase());
                    }
                  }),
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
