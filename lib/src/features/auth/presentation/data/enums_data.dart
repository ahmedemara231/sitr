enum EnumsData {
  chatLanguage([
    MaritalStatus(value: "arabic", title: "اللغة العربية"),
    MaritalStatus(value: "english", title: "اللغة الانجليزية"),
  ]),
  maritalStatus([
    MaritalStatus(value: "single", title: "أعزب/عزباء"),
    MaritalStatus(value: "married", title: "متزوج/متزوجة"),
    MaritalStatus(value: "divorced", title: "مطلق/مطلقة"),
    MaritalStatus(value: "widowed", title: "أرمل/أرملة"),
  ]),

  childCustody([
    ChildCustody(value: "mother", title: "الام"),
    ChildCustody(value: "father", title: "الاب"),
    ChildCustody(value: "none", title: "بدون"),
  ]),

  weddingTypes([
    WeddingTypes(value: "party", title: "حفل"),
    WeddingTypes(value: "simple_event", title: "فعالية متواضعة"),
    WeddingTypes(value: "family_celebration", title: "احتفال عائلي"),
  ]),

  hijab([
    Hijab(value: "hijab", title: "محجبة"),
    Hijab(value: "niqab", title: "نقاب"),
    Hijab(value: "face_cover", title: "لثام"),
    Hijab(value: "burqa", title: "برقع"),
    Hijab(value: "none", title: "بدون"),
  ]),

  skinColors([
    SkinColor(value: "white", title: "ابيض"),
    SkinColor(value: "light_brown", title: "قمحي فاتح"),
    SkinColor(value: "brown", title: "قمحي"),
    SkinColor(value: "black", title: "أسمر"),
    SkinColor(value: "dark_black", title: "أسمر غامق"),
  ]),

  religiousCommitment([
    ReligiousCommitment(value: "strict", title: "متشدد"),
    ReligiousCommitment(value: "moderate", title: "وسطي"),
    ReligiousCommitment(value: "open_minded", title: "متفتح"),
  ]),

  adminApprovalStatus([
    AdminApprovalStatus(value: "pending", title: "قيد الانتظار"),
    AdminApprovalStatus(value: "approved", title: "مقبول"),
    AdminApprovalStatus(value: "rejected", title: "مرفوض"),
  ]);

  final List<TitleValueShape> data;
  const EnumsData(this.data);
}

abstract class TitleValueShape{
  final String title;
  final String value;

  const TitleValueShape({
    required this.title,
    required this.value,
  });
}

class MaritalStatus extends TitleValueShape{
  const MaritalStatus({
    required super.title,
    required super.value,
  });
}

class ChildCustody extends TitleValueShape{
  const ChildCustody({
    required super.title,
    required super.value,
  });
}

class WeddingTypes extends TitleValueShape{
  const WeddingTypes({
    required super.title,
    required super.value,
  });
}

class Hijab extends TitleValueShape{
  const Hijab({
    required super.title,
    required super.value,
  });
}

class SkinColor extends TitleValueShape{
  const SkinColor({
    required super.title,
    required super.value,
  });
}

class ReligiousCommitment extends TitleValueShape{
  const ReligiousCommitment({
    required super.title,
    required super.value,
  });
}

class AdminApprovalStatus extends TitleValueShape{
  const AdminApprovalStatus({
    required super.title,
    required super.value,
  });
}