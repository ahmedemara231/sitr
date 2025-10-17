enum CompleteRegisterStatus{
  completed('completed'),
  notSubscribed('not_subscribed'),
  hasSetrCode('has_setr_code'),
  completeChild('complete_child'),
  incomplete('incomplete');

  final String status;
  const CompleteRegisterStatus(this.status);
}

extension Check on CompleteRegisterStatus{
  bool get isCompleted => this == CompleteRegisterStatus.completed;
  bool get isNotSubscribed => this == CompleteRegisterStatus.notSubscribed;
  bool get isHasSetrCode => this == CompleteRegisterStatus.hasSetrCode;
  bool get isCompleteChild => this == CompleteRegisterStatus.completeChild;
  bool get isIncomplete => this == CompleteRegisterStatus.incomplete;
}