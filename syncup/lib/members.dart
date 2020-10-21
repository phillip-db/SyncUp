class Members {
  static List<String> members = <String>[
    "User",
    "User",
    "User",
    "User",
    "User",
    "User",
    "User",
    "User",
    "User",
    "User",
    "User",
    "User",
    "User",
    "User",
    "User",
  ];

  static void addUser(String user) {
    members.add(user);
  }

  static void removeUser(int index) {
    members.removeAt(index);
  }
}
