import 'package:flutter/material.dart';
import 'package:flutter_base/src/core/widgets/sheets/promotion_plans/promotion_plans_content.dart';
import 'package:flutter_base/src/features/promotions/data/models/promotion_data_model.dart';
import 'package:flutter_base/src/features/promotions/data/models/promotion_plans_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders plans and forwards the selected plan', (
    WidgetTester tester,
  ) async {
    PromotionPlanModel? selectedPlan;
    const PromotionPlansModel plans = PromotionPlansModel(
      plans: [
        PromotionPlanModel(
          id: 1,
          code: 'monthly',
          duration: 'شهري',
          price: 50,
          currency: 'ر.س',
          period: 'شهريًا',
          description: 'مرونة أكبر',
          sortOrder: 1,
        ),
        PromotionPlanModel(
          id: 2,
          code: 'annual',
          duration: 'سنوي',
          price: 500,
          currency: 'ر.س',
          period: 'سنويًا',
          description: 'أفضل قيمة',
          isDefault: true,
          sortOrder: 2,
        ),
      ],
      features: [
        PromotionFeatureModel(
          id: 1,
          code: 'priority',
          title: 'ظهور بأولوية',
        ),
      ],
    );
    const PromotionSheetDataModel content = PromotionSheetDataModel(
      title: 'التميّز',
      subtitle: 'اختر خطتك',
      featureIntro: 'المميزات',
      subscribeButtonTemplate: 'اشترك في {duration} مقابل {price} {currency}',
      subscribedSuccessText: 'تم الاشتراك',
      cancelAnytimeText: 'يمكنك الإلغاء في أي وقت',
      plansData: plans,
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: PromotionPlansContent(
                data: plans,
                content: content,
                selectedPlanId: null,
                isSubscribing: false,
                isSubscribed: false,
                onPlanSelected: (PromotionPlanModel plan) {
                  selectedPlan = plan;
                },
                onSubscribe: (_) {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('شهري'), findsOneWidget);
    expect(find.text('سنوي'), findsOneWidget);
    expect(find.text('ظهور بأولوية'), findsOneWidget);
    expect(
      find.text('اشترك في سنوي مقابل 500 ر.س'),
      findsOneWidget,
    );

    await tester.tap(find.text('شهري'));
    await tester.pump();

    expect(selectedPlan?.id, 1);
    expect(tester.takeException(), isNull);
  });
}
