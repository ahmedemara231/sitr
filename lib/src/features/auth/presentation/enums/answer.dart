enum Answer{yes, no}

extension Check on Answer{
  bool get isYes => this == Answer.yes;
  bool get isNo => this == Answer.no;
}
