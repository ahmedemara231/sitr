import '../../../../core/shared/models/title_value_shape.dart';

enum EnumsData {
  chatLanguage([
    TitleValueShape(value: "arabic", title: "اللغة العربية"),
    TitleValueShape(value: "english", title: "اللغة الانجليزية"),
  ]),
  maritalStatus([
    TitleValueShape(value: "single", title: "أعزب/عزباء"),
    TitleValueShape(value: "married", title: "متزوج/متزوجة"),
    TitleValueShape(value: "divorced", title: "مطلق/مطلقة"),
    TitleValueShape(value: "widowed", title: "أرمل/أرملة"),
  ]),

  childCustody([
    TitleValueShape(value: "mother", title: "الام"),
    TitleValueShape(value: "father", title: "الاب"),
    // TitleValueShape(value: "none", title: "بدون"),
  ]),

  weddingTypes([
    TitleValueShape(value: "party", title: "حفل"),
    TitleValueShape(value: "simple_event", title: "فعالية متواضعة"),
    TitleValueShape(value: "family_celebration", title: "احتفال عائلي"),
  ]),

  hijab([
    TitleValueShape(value: "hijab", title: "محجبة"),
    TitleValueShape(value: "niqab", title: "نقاب"),
    TitleValueShape(value: "face_cover", title: "لثام"),
    TitleValueShape(value: "burqa", title: "برقع"),
    TitleValueShape(value: "none", title: "بدون"),
  ]),

  skinColors([
    TitleValueShape(value: "white", title: "ابيض"),
    TitleValueShape(value: "light_brown", title: "قمحي فاتح"),
    TitleValueShape(value: "brown", title: "قمحي"),
    TitleValueShape(value: "black", title: "أسمر"),
    TitleValueShape(value: "dark_black", title: "أسمر غامق"),
  ]),

  religiousCommitment([
    TitleValueShape(value: "strict", title: "متشدد"),
    TitleValueShape(value: "moderate", title: "وسطي"),
    TitleValueShape(value: "open_minded", title: "متفتح"),
  ]),

  adminApprovalStatus([
    TitleValueShape(value: "pending", title: "قيد الانتظار"),
    TitleValueShape(value: "approved", title: "مقبول"),
    TitleValueShape(value: "rejected", title: "مرفوض"),
  ]);

  final List<TitleValueShape> data;
  const EnumsData(this.data);
}