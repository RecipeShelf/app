module default {
  type Instruction {
    property text -> str;

    property decoration -> str {
      constraint one_of ('None','Quote','Heading');
    }
  }
}
