import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/onbording/model/on_boarding_page_data.dart';

List<OnBoardingPageData> pages = [
  const OnBoardingPageData(
    onBoardingTitle: LangKeys.titleOnbording1,
    onBoardingDescription: LangKeys.descriptionOnbording1,
    onBoardingImage: AppImages.onbording1,
  ),
  const OnBoardingPageData(
    onBoardingTitle: LangKeys.titleOnbording2,
    onBoardingDescription: LangKeys.descriptionOnbording2,
    onBoardingImage: AppImages.onbording2,
  ),
  const OnBoardingPageData(
    onBoardingTitle: LangKeys.titleOnbording3,
    onBoardingDescription: LangKeys.descriptionOnbording3,
    onBoardingImage: AppImages.onbording3,
  ),
];
