import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/english_today.dart';
import 'package:my_app/packages/quote/quote.dart';
import 'package:my_app/packages/quote/quote_model.dart';
import 'package:my_app/pages/all_words_page.dart';
import 'package:my_app/pages/control_page.dart';
import 'package:my_app/values/app_assets.dart';
import 'package:my_app/values/app_colors.dart';
import 'package:my_app/values/app_styles.dart';
import 'package:my_app/values/share_keys.dart';
import 'package:my_app/widgets/app_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  List<EnglishToday> words = [];
  String quote = Quotes().getRandom().content!;

  List<int> fixedListRandom({int n = 1, int max = 120, int min = 1}) {
    if (n > max || n < min) {
      return [];
    }
    List<int> randomList = [];
    Random random = Random();
    int count = 0;
    while (count < n) {
      int num = random.nextInt(max);
      if (randomList.contains(num)) {
        continue;
      } else {
        randomList.add(num);
        count++;
      }
    }
    return randomList;
  }

  getEnglishToday() async {
    print('before await');
    final prefs = await SharedPreferences.getInstance();
    print('after await');
    int len = prefs.getInt(ShareKeys.counter) ?? 5;
    List<String> nounList = [];
    List<int> rans = fixedListRandom(n: len, max: nouns.length);
    for (var index in rans) {
      nounList.add(nouns[index]);
    }

    setState(() {
      words = nounList.map((e) => getQuote(e)).toList();
    });
    print('has data');
  }

  EnglishToday getQuote(String noun) {
    Quote? quote;
    quote = Quotes().getByWord(noun);
    return EnglishToday(noun: noun, quote: quote?.content, id: quote?.id);
  }

  final GlobalKey<ScaffoldState> _scalloldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();
    getEnglishToday();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scalloldKey,
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        title: Text('English today',
            style: AppStyles.h3
                .copyWith(color: AppColors.textColor, fontSize: 36)),
        leading: InkWell(
            onTap: () {
              _scalloldKey.currentState?.openDrawer();
            },
            child: Image.asset(AppAssets.menu)),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(children: [
          Container(
            height: size.height * 1 / 11,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.centerLeft,
            child: Text(
              '"$quote"',
              style: AppStyles.h5
                  .copyWith(fontSize: 12, color: AppColors.textColor),
            ),
          ),
          SizedBox(
            height: size.height * 2 / 3,
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: words.length,
                itemBuilder: ((context, index) {
                  String word =
                      words[index].noun != null ? words[index].noun! : '';

                  String firstLetter = word.substring(0, 1);
                  String leftLetter = word.substring(1, word.length);

                  String quoteDefault =
                      "Think of all the beauty still left around you and be happy";
                  String quote = words[index].quote != null
                      ? words[index].quote!
                      : quoteDefault;
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Material(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      color: AppColors.primaryColor,
                      elevation: 4,
                      child: InkWell(
                        onDoubleTap: () {
                          setState(() {
                            words[index].isFavorite = !words[index].isFavorite;
                          });
                        },
                        splashColor: Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  alignment: Alignment.centerRight,
                                  child: Image.asset(
                                    AppAssets.heart,
                                    color: words[index].isFavorite
                                        ? Colors.red
                                        : Colors.white,
                                  )),
                              RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                      text: firstLetter,
                                      style: const TextStyle(
                                          fontFamily: FontFamily.sen,
                                          fontSize: 89,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            BoxShadow(
                                                color: Colors.black38,
                                                offset: Offset(3, 6),
                                                blurRadius: 6)
                                          ]),
                                      children: [
                                        TextSpan(
                                          text: leftLetter,
                                          style: const TextStyle(
                                              fontFamily: FontFamily.sen,
                                              fontSize: 56,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                BoxShadow(
                                                    color: Colors.black38,
                                                    offset: Offset(3, 6),
                                                    blurRadius: 6)
                                              ]),
                                        )
                                      ])),
                              Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: AutoSizeText(
                                  '"$quote"',
                                  maxFontSize: 26,
                                  style: AppStyles.h4.copyWith(
                                      letterSpacing: 1,
                                      color: AppColors.textColor),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })),
          ),
          _currentIndex >= 5
              ? buildShowMore()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    height: size.height * 1 / 11,
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: ((context, index) {
                            return buildIndicator(index == _currentIndex, size);
                          })),
                    ),
                  ),
                )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          setState(() {
            getEnglishToday();
          });
        },
        child: Image.asset(AppAssets.exchange),
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.lightBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 16),
                child: Text('Your mind',
                    style: AppStyles.h3.copyWith(
                      color: AppColors.textColor,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                    label: 'Favorites',
                    onTap: () {
                      print('Favorites');
                    }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                    label: 'Your control',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ControlPage()));
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      curve: Curves.bounceOut,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
          color: isActive ? AppColors.lightBlue : AppColors.lightGrey,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
          ]),
    );
  }

  Widget buildShowMore() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      alignment: Alignment.centerLeft,
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        elevation: 4,
        color: AppColors.primaryColor,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AllWordsPage(words: words)),
            );
          },
          splashColor: Colors.black38,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              'Show more',
              style: AppStyles.h5,
            ),
          ),
        ),
      ),
    );
  }
}
