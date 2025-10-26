enum Answer{
  yes,
  no,
}

extension Check on Answer?{
  bool get isYes => this == Answer.yes;
  bool get isNo => this == Answer.no;
}

extension ConvertBool on bool{
  Answer get toAnswer {
    if(this){
      return Answer.yes;
    }

    return Answer.no;
  }
}

extension ConvertAnswer on Answer?{
  bool get toBool {
    if(this == Answer.yes){
      return true;
    }

    return false;
  }
}

extension ConvertAnswerToBinary on Answer?{
  int get toBinary {
    if(this == Answer.yes){
      return 1;
    }

    return 0;
  }
}
