enum ProfileType { profile, partnerProfile }

extension ProfileTypeCheck on ProfileType {
  bool get isProfile => this == ProfileType.profile;

  bool get isPartnerProfile => this == ProfileType.partnerProfile;
}
