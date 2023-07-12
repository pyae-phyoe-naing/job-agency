import 'package:flutter/material.dart';
import 'package:job_agency/model/job_post_model.dart';
import 'package:job_agency/utils/theme.dart';
import 'package:starlight_utils/starlight_utils.dart';

class TodayCard extends StatelessWidget {
  final JobPostModel post;
  const TodayCard({super.key,required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        child:  Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               post.title,
                style:const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ThemeUtils.buttonColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${post.salary.currencyFormat}MMK",
                    style:const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ThemeUtils.buttonColor),
                  ),
                  Text(
                     DateTime.now().differenceTimeInString(post.createdAt ?? DateTime.now()),
                    style:const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ThemeUtils.buttonColor),
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
