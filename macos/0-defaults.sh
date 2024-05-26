#!/bin/bash
# **************************** 系统设置 ****************************
# 自动隐藏菜单栏
defaults write -g _HIHideMenuBar -bool true

# 启用所有控件的全键盘访问
defaults write -g AppleKeyboardUIMode -int 3

# 启用长按重复
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

# 禁用“自然”滚动
defaults write -g com.apple.swipescrolldirection -bool false

# 禁用智能破折号/句点/引号替换
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

# 禁用自动大写
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# 默认使用展开的“保存面板”
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# 提高 Cocoa 应用的窗口调整速度
defaults write -g NSWindowResizeTime -float 0.001

# 默认保存到磁盘（而不是 iCloud）
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool true

# --- 设置系统强调色
defaults write -g AppleAccentColor -int 6

# 跳到滚动条上单击的位置
defaults write -g AppleScrollerPagingBehavior -bool true

# 打开文档时优先使用标签
defaults write -g AppleWindowTabbingMode -string always

# **************************** Dock ****************************
# 设置图标大小和 Dock 方向
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock orientation -string left

# 设置 Dock 自动隐藏，并使隐藏应用程序的图标半透明 (⌘H)
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock showhidden -bool true

# 禁用显示最近使用项目和正在运行应用程序的指示点
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock show-process-indicators -bool false

# --- 取消固定所有应用程序
defaults write com.apple.dock persistent-apps -array ""

# **************************** Finder ****************************
# 允许通过 ⌘Q 退出访达
defaults write com.apple.finder QuitMenuItem -bool true

# 更改文件扩展名时禁用警告
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# 显示所有文件及其扩展名
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true

# 显示路径栏，并设置为多列视图
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string clmv

# 默认情况下在当前文件夹中搜索
defaults write com.apple.finder FXDefaultSearchScope -string SCcf

# --- 保持桌面清洁
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

# 文件夹优先显示
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# 新建窗口使用 $HOME 路径
defaults write com.apple.finder NewWindowTarget -string PfHm
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

# 允许在快速查看中选择文本
defaults write com.apple.finder QLEnableTextSelection -bool true

# 显示元数据信息，但不显示信息面板中的预览
defaults write com.apple.finder FXInfoPanesExpanded -dict MetaData -bool true Preview -bool false

# **************************** 触控板 ****************************
# 启用触控板轻触以单击
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# 启用三指拖移
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# **************************** 活动监视器 ****************************
# 按CPU使用率排序
defaults write com.apple.ActivityMonitor SortColumn -string CPUUsage
defaults write com.apple.ActivityMonitor SortDirection -int 0

# **************************** 启动服务 ****************************
# 禁用下载应用的隔离功能
defaults write com.apple.LaunchServices LSQuarantine -bool false

# **************************** Safari浏览器 ****************************
# 提高隐私保护
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# 禁用自动打开下载的文件
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# 启用开发菜单和Web检查器
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtras -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

# **************************** 通用访问 ****************************
# 设置鼠标指针大小
defaults write com.apple.universalaccess mouseDriverCursorSize -float 1.5

# **************************** 屏幕截图 ****************************
# 设置屏幕截图的文件名
defaults write com.apple.screencapture name -string screenshot
defaults write com.apple.screencapture include-date -bool false

# **************************** 桌面服务 ****************************
# 避免在USB或网络卷上创建.DS_Store文件
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# **************************** 磁盘镜像 ****************************
# 禁用磁盘镜像验证
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# **************************** 崩溃报告 ****************************
# 禁用崩溃报告程序
defaults write com.apple.CrashReporter DialogType -string none

# **************************** 菜单栏 ****************************
# 时间设置
defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool "true" && killall SystemUIServer
defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE HH:mm:ss\""

# **************************** 文本设置 ****************************
# 设置默认文档格式；将默认文档格式设置为纯文本 (.txt)
defaults write com.apple.TextEdit "RichText" -bool "false"
# 引号将保留其输入的形式
defaults write com.apple.TextEdit "SmartQuotes" -bool "false"

# ************* 其他杂项（Miscellaneous） **************
# 当连接新磁盘时，系统不会提示询问是否要将其用作备份卷
defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool "true"
# 帮助菜单可以位于其他窗口后面
defaults write com.apple.helpviewer "DevMode" -bool "true"
# Dock 项目启用弹跳加载
defaults write com.apple.dock "enable-spring-load-actions-on-all-items" -bool "true" && killall Dock
# 当音乐应用程序中开始播放新歌曲时显示通知
defaults write com.apple.Music "userWantsPlaybackNotifications" -bool "true"
# 关闭“从互联网下载的应用程序”隔离警告
defaults write com.apple.LaunchServices "LSQuarantine" -bool "false"
# 允许您选择长时间按住某个键时的行为。只要按住该键就会重复该键
defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool "false"
# 焦点跟随鼠标光标到达任何终端窗口
defaults write com.apple.Terminal "FocusFollowsMouse" -bool "true"
# 自动保存已禁用，系统会提示您是否要保存更改。
defaults write NSGlobalDomain "NSCloseAlwaysConfirmsChanges" -bool "false"
# F1、F2等充当标准功能键。按下该fn键即可使用印在该键上的特殊功能。
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
# 在Mail中拷贝地址时不使用全名
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
# 显示~/Library文件夹
chflags nohidden ~/Library/
# 显示 Xcode 每一次build的所用时间
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES
# 在登录屏幕上显示系统信息
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
exit 0
