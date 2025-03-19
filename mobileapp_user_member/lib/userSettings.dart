import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<Settings> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      setState(() {
        _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
        _darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
        _selectedLanguage = prefs.getString('selected_language') ?? 'English';
        _isLoading = false;
      });
    } catch (e) {
      // If preferences can't be loaded, use defaults
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load settings: ${e.toString()}', 
            style: GoogleFonts.poppins())),
        );
      }
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool('notifications_enabled', _notificationsEnabled);
      await prefs.setBool('dark_mode_enabled', _darkModeEnabled);
      await prefs.setString('selected_language', _selectedLanguage);
      
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Settings saved successfully', 
            style: GoogleFonts.poppins())),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save settings: ${e.toString()}', 
            style: GoogleFonts.poppins())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo[900],
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferences',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[900],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildSettingCard(
                      title: 'Account Settings',
                      children: [
                        _buildProfileTile(),
                        const Divider(),
                        _buildPasswordTile(),
                        const Divider(),
                        _buildEmailTile(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSettingCard(
                      title: 'App Settings',
                      children: [
                        _buildNotificationSwitch(),
                        const Divider(),
                        _buildDarkModeSwitch(),
                        const Divider(),
                        _buildLanguageDropdown(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSettingCard(
                      title: 'Privacy & Security',
                      children: [
                        _buildPrivacyTile(),
                        const Divider(),
                        _buildDataManagementTile(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSettingCard(
                      title: 'About',
                      children: [
                        _buildAboutTile(),
                        const Divider(),
                        _buildVersionTile(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _saveSettings,
                        icon: const Icon(Icons.save),
                        label: Text(
                          'Save Changes',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[800],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSettingCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo[900],
                ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.person, color: Colors.indigo[600]),
      title: Text('Profile Information', style: GoogleFonts.poppins()),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edit profile feature coming soon', 
            style: GoogleFonts.poppins())),
        );
      },
    );
  }

  Widget _buildPasswordTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.lock, color: Colors.indigo[600]),
      title: Text('Change Password', style: GoogleFonts.poppins()),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Change password feature coming soon', 
            style: GoogleFonts.poppins())),
        );
      },
    );
  }

  Widget _buildEmailTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.email, color: Colors.indigo[600]),
      title: Text('Email Preferences', style: GoogleFonts.poppins()),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email preferences feature coming soon', 
            style: GoogleFonts.poppins())),
        );
      },
    );
  }

  Widget _buildNotificationSwitch() {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Notifications', style: GoogleFonts.poppins()),
      subtitle: Text(
        'Receive alerts for updates and activities',
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
      ),
      value: _notificationsEnabled,
      activeColor: Colors.indigo[700],
      onChanged: (bool value) {
        setState(() {
          _notificationsEnabled = value;
        });
      },
      secondary: Icon(Icons.notifications, color: Colors.indigo[600]),
    );
  }

  Widget _buildDarkModeSwitch() {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Dark Mode', style: GoogleFonts.poppins()),
      subtitle: Text(
        'Use dark theme for the application',
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
      ),
      value: _darkModeEnabled,
      activeColor: Colors.indigo[700],
      onChanged: (bool value) {
        setState(() {
          _darkModeEnabled = value;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dark mode will be available in a future update', 
            style: GoogleFonts.poppins())),
        );
      },
      secondary: Icon(Icons.dark_mode, color: Colors.indigo[600]),
    );
  }

  Widget _buildLanguageDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.language, color: Colors.indigo[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Language', style: GoogleFonts.poppins()),
                Text(
                  'Choose your preferred language',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            value: _selectedLanguage,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,
            style: GoogleFonts.poppins(color: Colors.black87),
            underline: Container(
              height: 2,
              color: Colors.indigo[700],
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedLanguage = newValue;
                });
              }
            },
            items: <String>['English', 'Hindi', 'Malayalam', 'Tamil']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.privacy_tip, color: Colors.indigo[600]),
      title: Text('Privacy Policy', style: GoogleFonts.poppins()),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Privacy policy will be available soon', 
            style: GoogleFonts.poppins())),
        );
      },
    );
  }

  Widget _buildDataManagementTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.data_usage, color: Colors.indigo[600]),
      title: Text('Manage Your Data', style: GoogleFonts.poppins()),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data management feature coming soon', 
            style: GoogleFonts.poppins())),
        );
      },
    );
  }

  Widget _buildAboutTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.info, color: Colors.indigo[600]),
      title: Text('About Us', style: GoogleFonts.poppins()),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('About us page coming soon', 
            style: GoogleFonts.poppins())),
        );
      },
    );
  }

  Widget _buildVersionTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.update, color: Colors.indigo[600]),
      title: Text('App Version', style: GoogleFonts.poppins()),
      subtitle: Text(
        'v1.0.0',
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are using the latest version', 
            style: GoogleFonts.poppins())),
        );
      },
    );
  }
}