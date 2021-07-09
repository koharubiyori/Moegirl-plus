import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:moegirl_plus/constants.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/prefs/index.dart';
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/providers/settings.dart';
import 'package:moegirl_plus/themes.dart';
import 'package:moegirl_plus/utils/check_new_version.dart';
import 'package:moegirl_plus/utils/provider_change_checker.dart';
import 'package:moegirl_plus/utils/ui/dialog/alert.dart';
import 'package:moegirl_plus/utils/ui/set_status_bar.dart';
import 'package:moegirl_plus/utils/watch_list_manager.dart';
import 'package:url_launcher/url_launcher.dart';

mixin AppInit<T extends StatefulWidget> on 
  State<T>, 
  AfterLayoutMixin<T>, 
  ProviderChangeChecker<T>
{
  Timer _notificationCheckingTimer;

  @override
  void initState() { 
    super.initState();
  }

  @override
  void dispose() { 
    // 停止通知轮询检查
    if (_notificationCheckingTimer != null) _notificationCheckingTimer.cancel();
    super.dispose();
  }

  @override
  void afterFirstLayout(_) { 
    // 初始化用户信息，开始轮询检查等待通知 
    if (accountProvider.isLoggedIn) {
      initUserInfo();
    } 

    // 监听登录状态，更新用户信息及启动或关闭轮询检查等待通知
    addChangeChecker<AccountProviderModel, bool>(
      provider: accountProvider,
      selector: (provider) => provider.isLoggedIn,
      handler: (isLoggedIn) {
        if (isLoggedIn) {
          initUserInfo();
        } else {
          _notificationCheckingTimer.cancel();
        }
      }
    );

    // 监听主题变化，修改底部导航栏样式
    addChangeChecker<SettingsProviderModel, bool>(
      provider: settingsProvider, 
      selector: (provider) => provider.theme == 'night', 
      handler: (isNight) {
        setNavigationBarStyle(
          isNight ? nightPrimaryColor : Colors.white,
          isNight ? Brightness.light : Brightness.dark
        );
      }
    );

    checkIsNightModeFromSystem();

    // 检查新版本
    (() async {
      final newVersion = await checkNewVersion();
      if (newVersion == null) return;
      if (newVersion.version == otherPref.refusedVersion) return;

      final result = await showAlert<bool>(
        title: Lang.hasNewVersionHint,
        content: newVersion.desc,
        visibleCloseButton: true,
      );

      if (!result) {
        otherPref.refusedVersion = newVersion.version;
        return;
      }

      launch('https://www.coolapk.com/apk/247471');
    })();

    // 预加载用户头像
    if (accountProvider.isLoggedIn) {
      precacheImage(NetworkImage(avatarUrl + accountProvider.userName), context);
    }

    // 预加载登录页背景图
    precacheImage(AssetImage('assets/images/moe_2014_haru.png'), context);
  }

  void initUserInfo() {
    accountProvider.getUserInfo();
    accountProvider.checkWaitingNotificationTotal();
    WatchListManager.refreshList();

    _notificationCheckingTimer = Timer.periodic(Duration(seconds: 30), (_) {
      try {
        accountProvider.checkWaitingNotificationTotal();
      } catch(e) {
        print('轮询检查等待通知失败');
        print(e);
      }
    });  
  }

  void checkIsNightModeFromSystem() {
    if (
      SchedulerBinding.instance.window.platformBrightness == Brightness.dark &&
      settingsProvider.theme != 'night'
    ) {
      otherPref.lastTheme = settingsProvider.theme;
      settingsProvider.theme = 'night';
    } 
    
    if (
      SchedulerBinding.instance.window.platformBrightness == Brightness.light &&
      settingsProvider.theme == 'night'
    ) {
      settingsProvider.theme = otherPref.lastTheme;
    }

		if (settingsProvider.theme == 'night') {
			setNavigationBarStyle(nightPrimaryColor, Brightness.light);
		} else {
			setNavigationBarStyle(Colors.white, Brightness.dark);
		}
  }
}