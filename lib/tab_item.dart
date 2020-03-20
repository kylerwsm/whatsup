import 'package:flutter/material.dart';

/// Represents a page tab.
class TabItem {
  /// The name of the tab.
  final String name;

  /// The icon representing the tab.
  final IconData icon;

  /// The screen to be shown when the tab is active.
  final Widget page;

  /// The default constructor which checks that [name], [icon] and [page]
  /// is not [null] while in development. Note that assert statements
  /// are disabled in production.
  TabItem(this.name, this.icon, this.page)
      : assert(name != null),
        assert(icon != null),
        assert(page != null);
}
