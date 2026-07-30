import 'package:flutter_base/src/features/promotions/data/models/promotion_data_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PromotionDataModel', () {
    test('parses badges and dashboard-driven sheet content', () {
      final PromotionDataModel model = PromotionDataModel.fromJson(const {
        'promotion_badge': {
          'title': 'Upgrade',
          'subtitle': 'Get more',
          'action_text': 'Start',
        },
        'promoted_badge': {
          'title': 'Promoted',
          'subtitle': 'Shown first',
          'status_text': 'Active',
        },
        'promotion_sheet': {
          'title': 'Premium',
          'subtitle': 'Choose a plan',
          'feature_intro': 'Benefits',
          'subscribe_button_template':
              'Subscribe {duration} - {price} {currency}',
          'subscribed_success_text': 'Subscribed',
          'cancel_anytime_text': 'Cancel anytime',
          'plans': [
            {
              'id': 2,
              'code': 'annual',
              'duration': 'Year',
              'price': 500,
              'currency': 'SAR',
              'period': 'yearly',
              'description': 'Best value',
              'is_default': true,
              'sort_order': 2,
            },
            {
              'id': 1,
              'code': 'monthly',
              'duration': 'Month',
              'price': 50,
              'currency': 'SAR',
              'period': 'monthly',
              'description': 'Flexible',
              'sort_order': 1,
            },
          ],
          'features': [
            {
              'id': 1,
              'code': 'priority',
              'title': 'Search priority',
              'sort_order': 1,
            },
          ],
        },
      });

      expect(model.promotionBadge.title, 'Upgrade');
      expect(model.promotionBadge.actionText, 'Start');
      expect(model.promotedBadge.actionText, 'Active');
      expect(model.promotionSheet.title, 'Premium');
      expect(
        model.promotionSheet.subscribeButtonTemplate,
        'Subscribe {duration} - {price} {currency}',
      );
      expect(model.promotionSheet.plansData.plans.first.id, 1);
      expect(model.promotionSheet.plansData.defaultPlan.id, 2);
      expect(model.promotionSheet.plansData.features.single.code, 'priority');
    });

    test('serializes a cache-safe response with the endpoint keys', () {
      final PromotionDataModel model = PromotionDataModel.fromJson(const {
        'promotion_badge': {
          'title': 'Upgrade',
          'subtitle': 'Get more',
          'action_text': 'Start',
        },
        'promoted_badge': {
          'title': 'Promoted',
          'subtitle': 'Shown first',
          'status_text': 'Active',
        },
        'promotion_sheet': {
          'title': 'Premium',
          'subtitle': 'Choose',
          'feature_intro': 'Benefits',
          'subscribe_button_template': '{duration} {price} {currency}',
          'subscribed_success_text': 'Done',
          'cancel_anytime_text': 'Cancel anytime',
          'plans': [],
          'features': [],
        },
      });

      final Map<String, dynamic> json = model.toJson();

      expect(json['promotion_badge']['action_text'], 'Start');
      expect(json['promoted_badge']['status_text'], 'Active');
      expect(
        json['promotion_sheet']['subscribe_button_template'],
        '{duration} {price} {currency}',
      );
    });
  });
}
