class ResendCodeBody{
  final String phone;

  ResendCodeBody({required this.phone});

  Map<String, dynamic> toJson() => {
    'iso' : 'SA',
    'country_code' : '+966',
    'phone' : phone,
  };
}