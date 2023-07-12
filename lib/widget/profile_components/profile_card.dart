import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/utils/string.dart';
import 'package:job_agency/widget/profile_components/update_city_dialog.dart';
import 'package:job_agency/widget/profile_components/update_price_dialog.dart';
import 'package:job_agency/widget/profile_components/update_username_dialog.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      // print(state.userModel?.user);
      return UserAccountsDrawerHeader(
        margin: EdgeInsets.zero,
        decoration: const BoxDecoration(color: Colors.white),
        accountName: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Text(
                state.userModel?.user?.displayName ??
                    '${StringUtils.appName} User',
                style: const TextStyle(color: Colors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => const UpdateUsernameDialog());
                },
                //    padding: EdgeInsets.zero,
                child: const Icon(
                  Icons.edit,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        otherAccountsPicturesSize: const Size(
          150,
          40,
        ),
        otherAccountsPictures: [
          Row(
            children: state.userModel?.role != 'user'
                ? [
                    const Text(
                      'Admin',
                      style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 1,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Icon(
                      Icons.star,
                      size: 20,
                    ),
                  ]
                : [
                    Expanded(
                      child: Text(
                        '${(state.userModel?.price ?? 0).currencyFormat} MMK',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => const UpdatePriceDialog());
                      },
                      //    padding: EdgeInsets.zero,
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    ),
                  ],
          )
        ],
        accountEmail: Row(
          children: [
            Text(
              state.userModel?.city ?? 'Your City',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => const UpdateCityDialog());
              },
              //    padding: EdgeInsets.zero,
              child: const Icon(
                Icons.edit,
                size: 20,
              ),
            ),
          ],
        ),
        currentAccountPictureSize: const Size(72, 72),
        currentAccountPicture: GestureDetector(
          onTap: () async {
            if (state.userModel?.user != null) {
              await firebaseHelper.uploadFile(user: state.userModel!.user!);
            }
          },
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: state.userModel?.user?.photoURL != null
                    ? CachedNetworkImageProvider(
                        state.userModel?.user?.photoURL ?? '')
                    : null,
              ),
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.bottomCenter,
                decoration: const BoxDecoration(
                    color: Colors.white24, shape: BoxShape.circle),
                child: const Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
