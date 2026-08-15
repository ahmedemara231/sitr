export type Profile = {
  id: string
  name: string
  premium: boolean
  city: string | null
  age: number | null
  weight: number | null
  height: number | null
  marital: string | null
  // details-only fields
  color: string | null
  job: string | null
  education: string | null
  children: string | null
  childrenCount: string | null
  wantsChildren: string | null
  custody: string | null
  weddingType: string | null
  dowry: string | null
  smoking: string | null
  prays: string | null
}

export const profiles: Profile[] = [
  {
    id: 'noura',
    name: 'نورة 2',
    premium: true,
    city: 'منطقة علقان',
    age: 36,
    weight: 88,
    height: 136,
    marital: 'أعزب/عزباء',
    color: 'قمحي',
    job: 'موظفة',
    education: 'بكالوريوس',
    children: 'لا',
    childrenCount: '0 أبناء',
    wantsChildren: 'نعم',
    custody: 'بدون',
    weddingType: 'فعالية متواضعة',
    dowry: 'من 25 إلى 30',
    smoking: 'نعم',
    prays: 'نعم',
  },
  {
    id: 'test-new',
    name: 'تيست جديد جديد ف',
    premium: true,
    city: null,
    age: 44,
    weight: null,
    height: null,
    marital: 'أعزب/عزباء',
    color: null,
    job: null,
    education: null,
    children: null,
    childrenCount: null,
    wantsChildren: null,
    custody: null,
    weddingType: null,
    dowry: null,
    smoking: null,
    prays: null,
  },
  {
    id: 'anash',
    name: 'نجرب الانش',
    premium: false,
    city: 'منطقة حقل',
    age: 35,
    weight: 88,
    height: 155,
    marital: 'مطلق/مطلقة',
    color: 'حنطي',
    job: 'معلمة',
    education: 'ثانوي',
    children: 'نعم',
    childrenCount: '2 أبناء',
    wantsChildren: 'نعم',
    custody: 'مع الأم',
    weddingType: 'فعالية متواضعة',
    dowry: 'من 30 إلى 40',
    smoking: 'لا',
    prays: 'نعم',
  },
  {
    id: 'mona',
    name: 'منه مستعار',
    premium: false,
    city: 'منطقة الطائف',
    age: 30,
    weight: 44,
    height: 150,
    marital: 'أعزب/عزباء',
    color: 'أبيض',
    job: 'طالبة',
    education: 'بكالوريوس',
    children: 'لا',
    childrenCount: '0 أبناء',
    wantsChildren: 'نعم',
    custody: 'بدون',
    weddingType: 'حفل تقليدي',
    dowry: 'من 20 إلى 25',
    smoking: 'لا',
    prays: 'نعم',
  },
  {
    id: 'bint',
    name: 'تيست بنت',
    premium: false,
    city: 'منطقة رجم الطيارة',
    age: 25,
    weight: 60,
    height: 180,
    marital: 'أعزب/عزباء',
    color: 'قمحي',
    job: 'موظفة',
    education: 'دبلوم',
    children: 'لا',
    childrenCount: '0 أبناء',
    wantsChildren: 'نعم',
    custody: 'بدون',
    weddingType: 'فعالية متواضعة',
    dowry: 'من 25 إلى 30',
    smoking: 'لا',
    prays: 'نعم',
  },
]
