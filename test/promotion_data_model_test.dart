import 'package:flutter_base/src/features/promotions/data/models/promotion_badge_model.dart';
import 'package:flutter_base/src/features/promotions/data/models/promotion_plans_model.dart';
import 'package:flutter_base/src/features/promotions/data/models/promotion_sheet_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('separated promotion endpoint models', () {
    test('parses promotion and promoted badge responses', () {
      final PromotionBadgeDataModel promotionBadge =
          PromotionBadgeDataModel.fromJson(const {
        'title': 'Upgrade',
        'subtitle': 'Get more',
        'action_text': 'Start',
      });
      final PromotionBadgeDataModel promotedBadge =
          PromotionBadgeDataModel.fromJson(const {
        'title': 'Promoted',
        'subtitle': 'Shown first',
        'status_text': 'Active',
      });

      expect(promotionBadge.actionText, 'Start');
      expect(promotedBadge.actionText, 'Active');
      expect(promotionBadge.toJson()['action_text'], 'Start');
      expect(promotedBadge.toJson(isPromoted: true)['status_text'], 'Active');
    });

    test('parses promotion sheet content without plans', () {
      final PromotionSheetDataModel sheet =
          PromotionSheetDataModel.fromJson(const {
        'title': 'Premium',
        'subtitle': 'Choose a plan',
        'feature_intro': 'Benefits',
        'subscribe_button_template':
            'Subscribe {duration} - {price} {currency}',
        'subscribed_success_text': 'Subscribed',
        'cancel_anytime_text': 'Cancel anytime',
      });

      expect(sheet.title, 'Premium');
      expect(sheet.featureIntro, 'Benefits');
      expect(
        sheet.subscribeButtonTemplate,
        'Subscribe {duration} - {price} {currency}',
      );
    });

    test('parses paginated plans and features from one response', () {
      final PromotionPlansPageModel page =
          PromotionPlansPageModel.fromJson(const {
        'plans': {
          'data': [
            {
              'id': 2,
              'code': 'quarterly',
              'duration': '3 months',
              'price': 69,
              'currency': 'SAR',
              'period': 'quarterly',
              'description': 'Most requested',
              'is_highlighted': true,
              'is_default': true,
              'sort_order': 2,
            },
            {
              'id': 1,
              'code': 'monthly',
              'duration': 'Month',
              'price': 29,
              'currency': 'SAR',
              'period': 'monthly',
              'description': 'Basic benefits',
              'is_highlighted': false,
              'is_default': false,
              'sort_order': 1,
            },
          ],
          'pagination': {
            'total_items': 2,
            'count_items': 2,
            'per_page': 10,
            'total_pages': 1,
            'current_page': 1,
            'next_page_url': null,
            'prev_page_url': null,
          },
        },
        'features': [
          {
            'id': 1,
            'code': 'search_priority',
            'title': 'Search priority',
            'sort_order': 1,
          },
        ],
      });

      expect(page.data.plans.first.id, 1);
      expect(page.data.defaultPlan.id, 2);
      expect(page.data.features.single.code, 'search_priority');
      expect(page.pagination.totalPages, 1);
      expect(page.pagination.perPage, 10);
    });
  });
}
