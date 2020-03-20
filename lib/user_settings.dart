import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/app_state.dart';
import 'package:provider/provider.dart';

class UserSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Take reference of device width for profile photo diameter.
    final photoDiameter = MediaQuery.of(context).size.width * 0.15;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(
          elevation: 0.0,
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('User Settings'),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                // Some padding from the app bar.
                SizedBox(height: 32.0),
                // The profile photo.
                Provider.of<AppState>(context).userPhotoUrl != null
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          height: photoDiameter,
                          width: photoDiameter,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                            image: DecorationImage(
                              image: NetworkImage(
                                Provider.of<AppState>(context).userPhotoUrl,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          height: photoDiameter,
                          width: photoDiameter,
                          child: Icon(
                            Icons.account_circle,
                            size: photoDiameter,
                          ),
                        ),
                      ),
                SizedBox(height: 8.0),
                // Shows the user's name.
                Text(
                  Provider.of<AppState>(context).userDisplayName ?? 'Guest',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Space between name and email.
                SizedBox(height: 8.0),
                // Shows the user's email.
                Text(
                  Provider.of<AppState>(context).userDisplayName ??
                      'Not signed in',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                // Padding between user email and sign in or out button.
                SizedBox(height: 32.0),
                // Sign in or sign out button.
                Provider.of<AppState>(context).userEmail == null
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width - 64.0,
                        height: 55.0,
                        child: FlatButton(
                          color: Color(0xFF4285F4),
                          onPressed: () {
                            Provider.of<AppState>(
                              context,
                              listen: false,
                            ).signInWithGoogle();
                          },
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 22.0,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width - 64.0,
                        height: 55.0,
                        child: FlatButton(
                          color: Color(0xFF4285F4),
                          onPressed: () {
                            Provider.of<AppState>(
                              context,
                              listen: false,
                            ).signOut();
                          },
                          child: Text(
                            'Sign out',
                            style: TextStyle(
                              fontSize: 22.0,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
