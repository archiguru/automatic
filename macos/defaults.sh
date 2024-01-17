#!/bin/bash
# ************* Dock **************
# dock 位置
# defaults delete com.apple.dock "orientation" && killall Dock
sleep 1
# Dock 图标大小为 36 个像素。
defaults write com.apple.dock "tilesize" -int "36" && killall Dock
sleep 1
# 设置自动隐藏 Dock
defaults write com.apple.dock "autohide" -bool "true" && killall Dock
sleep 1
# 取消自动隐藏 Dock 的触发时间
defaults write com.apple.dock "autohide-time-modifier" -float "0" && killall Dock
sleep 1
# 去掉自动隐藏延迟，Dock 立即出现
defaults write com.apple.dock "autohide-delay" -float "0" && killall Dock
sleep 1
# 不在 Dock 中显示最近使用的应用程序
defaults write com.apple.dock "show-recents" -bool "false" && killall Dock
sleep 1
# 设置 suck（在系统偏好设置中找不到）
defaults write com.apple.dock "mineffect" -string "suck" && killall Dock
sleep 1
# 只显示活动的应用程序
# defaults write com.apple.dock "static-only" -bool "true" && killall Dock
# 显示到固定 Dock 的应用程序
# defaults write com.apple.dock "static-only" -bool "false" && killall Dock
sleep 1
# 在 Dock 图标上向上滚动可显示应用程序或打开的堆栈的所有 Space 打开的窗口。
defaults write com.apple.dock "scroll-to-open" -bool "true" && killall Dock
sleep 1
# 加快 Mission Control 的动画效果
defaults write com.apple.dock expose-animation-duration -float 0.12 && killall Dock
sleep 1
# 让Dock中隐藏的程序图标半透明
defaults write com.apple.dock showhidden -bool "true" && killall Dock
sleep 1
# 选择是否自动重新排列空间
defaults write com.apple.dock "mru-spaces" -bool "true" && killall Dock
sleep 1
# 按应用程序对窗口进行分组
defaults write com.apple.dock "expose-group-apps" -bool "true" && killall Dock
sleep 1
# ************* 截图 **************
# 禁用屏幕截图带阴影
defaults write com.apple.screencapture "disable-shadow" -bool "true"
# 设置默认截图位置/改变截图的默认格式
defaults write com.apple.screencapture location ~/Pictures/Screenshots
defaults write com.apple.screencapture type jpg && killall SystemUIServer
sleep 1
# ************* Finder **************
# 显示 Finder 中的所有文件扩展名
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true" && killall Finder
sleep 1
# 在 Finder 中显示隐藏文件
defaults write com.apple.finder "AppleShowAllFiles" -bool "true" && killall Finder
sleep 1
# 在 "快速查看" 中开启文本选择功能
defaults write com.apple.finder QLEnableTextSelection -bool TRUE && killall Finder
sleep 1
# 完全隐藏桌面图标
defaults write com.apple.finder CreateDesktop -bool false && killall Finder
sleep 1
# 显示路径栏
defaults write com.apple.finder "ShowPathbar" -bool "true" && killall Finder
sleep 1
# 设置默认列表显示视图
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv" && killall Finder
sleep 1
# 将文件夹保留在顶部
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true" && killall Finder
sleep 1
# 搜索当前文件夹
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf" && killall Finder
sleep 1
# 30 天后自动清空废纸篓
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true" && killall Finder
sleep 1
# 更改文件扩展名不显示警告
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false" && killall Finder
sleep 1
# 默认保存到磁盘（默认 iCloud）
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"
# 始终在标题栏的标题之前显示文件夹图标
defaults write com.apple.universalaccess "showWindowTitlebarIcons" -bool "true" && killall Finder
sleep 1

# ************* 桌面 **************
# 将文件夹保留在顶部
defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool "true" && killall Finder
sleep 1
# 隐藏桌面上的所有图标
defaults write com.apple.finder "CreateDesktop" -bool "false" && killall Finder
sleep 1
# 在桌面上隐藏外部磁盘
defaults write com.apple.finder "ShowExternalHardDrivesOnDesktop" -bool "false" && killall Finder
sleep 1
# 隐藏桌面上的可移动媒体（CD、DVD 和 iPod）
defaults write com.apple.finder "ShowRemovableMediaOnDesktop" -bool "false" && killall Finder
sleep 1
# 在桌面上显示连接的服务器
defaults write com.apple.finder "ShowMountedServersOnDesktop" -bool "true" && killall Finder
sleep 1

# ************* 菜单栏 **************
# 时间设置
defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool "true" && killall SystemUIServer
sleep 1
defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE HH:mm:ss\""

# ************* 触控板 **************
# 触控板设置轻触点击
defaults write com.apple.AppleMultitouchTrackpad "FirstClickThreshold" -int "0"
# 启用拖动，而不使用拖拽锁定（Enable dragging with drag lock）
defaults write com.apple.AppleMultitouchTrackpad "DragLock" -bool "true"
# 使用三指拖动启用拖动
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"

# ************* 任务控制（Mission Control） **************
# 切换到某个应用程序时，请切换到该应用程序打开窗口的空间
defaults write NSGlobalDomain "AppleSpacesSwitchOnActivate" -bool "true" && killall Dock
sleep 1
# 显示器有单独的空间
defaults write com.apple.spaces "spans-displays" -bool "true" && killall SystemUIServer
sleep 1
# 选择提交反馈报告时是否自动收集大文件，可能会导致 Mac 速度缓慢并影响重要的上传指标
defaults write com.apple.appleseed.FeedbackAssistant "Autogather" -bool "false"

# ************* 文本设置 **************
# 设置默认文档格式；将默认文档格式设置为富文本 (.rtf) 或纯文本 (.txt)
defaults write com.apple.TextEdit "RichText" -bool "false" && killall TextEdit
sleep 1
# 引号将保留其输入的形式
defaults write com.apple.TextEdit "SmartQuotes" -bool "false" && killall TextEdit
sleep 1

# ************* Safari **************
# 显示完整的网站地址
defaults write com.apple.Safari "ShowFullURLInSmartSearchField" -bool "true" && killall Safari
sleep 1
# 显示Safari调试菜单
defaults write com.apple.safari IncludeDebugMenu -bool YES && killall Safari
sleep 1

# ************* 其他杂项（Miscellaneous） **************
# 当连接新磁盘时，系统不会提示询问是否要将其用作备份卷
defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool "true"
# 活动监视器
defaults write com.apple.ActivityMonitor "UpdatePeriod" -int "2" && killall Activity\ Monitor
sleep 1
defaults write com.apple.ActivityMonitor "IconType" -int "2" && killall Activity\ Monitor
sleep 1
# 帮助菜单可以位于其他窗口后面
defaults write com.apple.helpviewer "DevMode" -bool "true"
# Dock 项目启用了弹簧加载
defaults write com.apple.dock "enable-spring-load-actions-on-all-items" -bool "true" && killall Dock
sleep 1
# 当音乐应用程序中开始播放新歌曲时显示通知
defaults write com.apple.Music "userWantsPlaybackNotifications" -bool "true" && killall Music
sleep 1
# 关闭“从互联网下载的应用程序”隔离警告
defaults write com.apple.LaunchServices "LSQuarantine" -bool "false"
# 允许您选择长时间按住某个键时的行为。只要按住该键就会重复该键
defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool "false"
# 焦点跟随鼠标光标到达任何终端窗口
defaults write com.apple.Terminal "FocusFollowsMouse" -bool "true" && killall Terminal
sleep 1
# 自动保存已禁用，系统会提示您是否要保存更改。
defaults write NSGlobalDomain "NSCloseAlwaysConfirmsChanges" -bool "false"
# F1、F2等充当标准功能键。按下该fn键即可使用印在该键上的特殊功能。
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
# 在Mail中拷贝地址时不使用全名
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
# 在登录屏幕上显示系统信息
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
# 显示~/Library文件夹
chflags nohidden ~/Library/
# 显示Xcode 每一次build的所用时间
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES

exit 0
