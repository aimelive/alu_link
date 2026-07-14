class MatchCalculator {
  /// Returns a 0-100 percentage of how well a student's skills
  /// cover the skills an opportunity requires.
  static int score(List<String> studentSkills, List<String> requiredSkills) {
    if (requiredSkills.isEmpty) return 0;

    final student = studentSkills.map((s) => s.trim().toLowerCase()).toSet();
    final required = requiredSkills.map((s) => s.trim().toLowerCase()).toSet();

    final matched = required.intersection(student).length;
    return ((matched / required.length) * 100).round();
  }
}