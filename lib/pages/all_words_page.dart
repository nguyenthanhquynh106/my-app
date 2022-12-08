import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/english_today.dart';

import '../values/app_assets.dart';
import '../values/app_colors.dart';
import '../values/app_styles.dart';

class AllWordsPage extends StatelessWidget {
  final List<EnglishToday> words;
  const AllWordsPage({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.secondColor,
        appBar: AppBar(
          backgroundColor: AppColors.secondColor,
          elevation: 0,
          title: Text('English today',
              style: AppStyles.h3
                  .copyWith(color: AppColors.textColor, fontSize: 36)),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(AppAssets.leftArrow)),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: words
                  .map((e) => Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: AutoSizeText(
                          e.noun ?? '',
                          style: AppStyles.h3.copyWith(shadows: [
                            const BoxShadow(
                                color: Colors.black38,
                                offset: Offset(3, 6),
                                blurRadius: 6)
                          ]),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ))
                  .toList()),
        ));
  }
}
