abstract class RoleManager {
  /// Clears all stored data and resets the role manager to the initial state.
  void clear();

  /// Adds the inheritance link between two roles. role: name1 and role: name2.
  /// domain is a prefix to the roles.
  ///
  /// [name1] is the first role (or user).
  /// [name2] is the second role.
  /// [domain] is the domain the roles belong to.
  void addLink(String name1, String name2, [String domain]);

  /// Delete the inheritance link between two roles. role: name1 and role: name2.
  /// domain is a prefix to the roles.
  ///
  /// [name1] is the first role (or user).
  /// [name2] is the second role.
  /// [domain] is the domain the roles belong to.
  void deleteLink(String name1, String name2, [String domain]);

  /// Returns whether a link exists between two roles. role: name1 inherits role: name2.
  /// domain is a prefix to the roles.
  ///
  /// [name1] is the first role (or a user).
  /// [name2] is the second role.
  /// [domain] is the domain the roles belong to.
  bool hasLink(String name1, String name2, [String domain]);

  /// Returns the roles that a user inherits.
  /// domain is a prefix to the roles.
  ///
  /// [name] is the user (or a role).
  /// [domain] is the domain the roles belong to.
  List<String> getRoles(String name, [String domain]);

  /// Returns the users that inherits a role.
  ///
  /// [name] is the role.
  List<String> getUsers(String name);

  /// Prints all the roles to log.
  void printRoles();
}
