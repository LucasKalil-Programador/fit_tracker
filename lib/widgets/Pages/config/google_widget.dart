import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/states/auth_state.dart';
import 'package:fittrackr/states/state_manager.dart';
import 'package:fittrackr/states/state_manager_extension.dart';
import 'package:fittrackr/utils/cloud/firestore.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

enum ResyncOption{ local, server, none }

class GoogleLoginWidget extends StatefulWidget {

  const GoogleLoginWidget({super.key});

  @override
  State<GoogleLoginWidget> createState() => _GoogleLoginWidgetState();
}

class _GoogleLoginWidgetState extends State<GoogleLoginWidget> {
  late AppLocalizations localization;
  bool hasInternetResult = true;

  bool isSyncing = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    return Column(
      spacing: 5,
      children: [
        Center(child: Text(localization.googleAccount, style: Theme.of(context).textTheme.titleLarge)),
        Consumer2<StateManager, AuthState>(
          builder: (BuildContext context, StateManager manager, AuthState authState, Widget? child) {
              return details(context, manager, authState);
            },
        ),
        Consumer<AuthState>(
          builder: (BuildContext context, AuthState authState, Widget? child) { 
            if(authState.status == AuthStatus.authenticated) {
              return logout(context, authState);
            } else {
              return login(context, authState);
            }
           },
        ),
      ],
    );
  }

  // details

  Widget details(BuildContext context, StateManager manager,  AuthState authState) {
    if(isLoading) {
      return LoadingAnimationWidget.waveDots(color: Theme.of(context).colorScheme.secondary, size: 50);
    }

    var status = manager.lastSaveResult?.status;
    if(status == SaveStatus.error) {
      hasInternet().then((value) => setState(() => hasInternetResult = value));
      status = SaveStatus.disconnected;
    }
    
    if(authState.isLoggedIn) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: getUserAvatar(authState),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(getStatusMessage(manager.lastSaveResult), textAlign: TextAlign.center)
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: getStatusWidget(status, manager, authState),
          )
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(localization.loginWithGoogle, textAlign: TextAlign.center,),
    );
  }

  Widget getStatusWidget(SaveStatus? status, StateManager manager, AuthState authState) {
    if(status != SaveStatus.success) {
      return ElevatedButton.icon(
        onPressed: isSyncing ? null : () => status == SaveStatus.desynchronized ? onResync(manager, authState) : onTryAgain(manager),
        label: isSyncing
            ? LoadingAnimationWidget.threeArchedCircle(
              color: Theme.of(context).colorScheme.secondary,
              size: 32,
            )
            : SaveStatusIcon(status: status, size: 32),
      );
    }
    return SaveStatusIcon(status: status, size: 32);
  }

  String getStatusMessage(SaveResult? lastSaveResult) {
    if (lastSaveResult == null) return localization.notStarted;

    String formattedTime = "";
    if (lastSaveResult.timestamp != null) {
      formattedTime = DateFormat('dd/MM/yyyy HH:mm',).format(lastSaveResult.timestamp!.toDate());
    }

    switch (lastSaveResult.status) {
      case SaveStatus.success:
        return localization.syncCompleted(formattedTime);
      case SaveStatus.desynchronized:
        return localization.outOfSync;
      case SaveStatus.error:
        return localization.saveError;
      case SaveStatus.disconnected:
        return localization.userDisconnected;
    }
  }

  Widget getUserAvatar(AuthState authState) {
    String? photoURL = authState.user?.photoURL;
    Widget avatar = CircleAvatar(backgroundImage: photoURL != null ? Image.network(photoURL).image : null);
    Widget userText = Text(localization.loggedInAs(authState.user?.displayName ?? localization.anonymous));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        avatar,
        Padding(padding: const EdgeInsets.all(8.0), child: userText),
      ],
    );
  }

  // Login/Logout

  Widget login(BuildContext context, AuthState authState) {
    return ElevatedButton.icon(
      icon: Icon(Icons.login),
      label: Text(localization.login),
      onPressed: () => onLogin(authState, context),
    );
  }

  Widget logout(BuildContext context, AuthState authState) {
    return ElevatedButton.icon(
      icon: Icon(Icons.logout),
      label: Text(localization.logout),
      onPressed: () => onLogout(authState, context),
    );
  }

  Future<void> onLogin(AuthState authState, BuildContext context) async {
    if(isLoading) return;
    setState(() => isLoading = true);

    try {
      final success = await authState.signInWithGoogle();
      if(context.mounted) {
        if (success) {
          showSnackMessage(context, localization.loggedInAs(authState.user?.displayName ?? localization.anonymous), true);
        } else {
          showSnackMessage(context, localization.loginFailed, false);
        }
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> onLogout(AuthState authState, BuildContext context) async {
    if(isLoading) return;
    setState(() => isLoading = true);

    try {
      await authState.signOut();
      if(context.mounted) {
        showSnackMessage(context, localization.userLoggedOut, true);
      }
    } catch (e) {
      if(context.mounted) {
        showSnackMessage(context, localization.logoutFailed, true);
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> onTryAgain(StateManager manager) async {
    if(isSyncing) return;
    setState(() => isSyncing = true);
    
    try {
      await Future.delayed(Duration(milliseconds: 500), manager.trySync);
    } finally {
      setState(() => isSyncing = false);
    }
  }

  Future<void> onResync(StateManager manager, AuthState authState) async {
    if(isSyncing) return;
    setState(() => isSyncing = true);

    try {
      final userID = authState.user?.uid;
      if(userID != null) {
        final serverTime = await FirestoreUtils.getServerTimeStamp(userID);
        final localTime = await manager.getLocalTimeStamp();
        if(mounted) {
          final option = await showResyncDialog(context, serverTime, localTime);
          if(option == ResyncOption.local) {
            await manager.forceSyncLocalToCloud();
          } else if(option == ResyncOption.server) {
            await manager.forceSyncCloudToLocal();
          }
        }
      }
    } finally {
      setState(() => isSyncing = false);
    }
  }

  Future<ResyncOption> showResyncDialog(BuildContext context, DateTime? serverTime, DateTime? localTime) async {
    final format = DateFormat('dd/MM/yyyy HH:mm:ss');
    final formattedServerTime = serverTime != null
            ? format.format(serverTime)
            : localization.unableToDetermineDate;
    final formattedLocalTime = localTime != null
            ? format.format(localTime)
            : localization.unableToDetermineDate;
    
    final result = await showDialog<ResyncOption>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(localization.conflictDetectedTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(localization.conflictDetectedMessage),
                const SizedBox(height: 12),
                Text(localization.lastCloudSave(formattedServerTime)),
                Text(localization.lastLocalSave(formattedLocalTime)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(ResyncOption.local),
                child: Text(localization.useLocalData),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(ResyncOption.server),
                child: Text(localization.useCloudData),
              ),
            ],
          ),
    );

    return result ?? ResyncOption.none;
  }

  Future<bool> hasInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    
    try {
      final result = await InternetAddress.lookup('8.8.8.8');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (_) { }
    return false;
  }
}

class SaveStatusIcon extends StatelessWidget {
  final SaveStatus? status;
  final double size;

  const SaveStatusIcon({super.key, required this.status, this.size = 24});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (status) {
      case SaveStatus.success:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case SaveStatus.desynchronized:
        color = Colors.orange;
        icon = Icons.warning;
        break;
      case SaveStatus.disconnected:
        color = Colors.grey;
        icon = Icons.cloud_off;
        break;
      case SaveStatus.error:
        color = Colors.red;
        icon = Icons.error;
        break;
      case null:
        color = Colors.blueGrey;
        icon = Icons.hourglass_empty;
        break;
    }

    return Icon(
      icon,
      color: color,
      size: size,
    );
  }
}