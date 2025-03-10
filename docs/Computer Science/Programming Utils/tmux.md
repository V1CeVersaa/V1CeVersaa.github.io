# Tmux Cheatsheet
 
!!! info "What is tmux?"
    tmux’s authors describe it as a terminal multiplexer. Behind this fancy term hides a simple concept: Within one terminal window you can open multiple windows and split-views (called "panes" in tmux lingo). Each pane will contain its own, independently running shell instance (bash, zsh, whatever you're using). This allows you to have multiple terminal commands and applications running side by side without the need to open multiple terminal emulator windows.

## 快捷键基础速通

快捷键前缀：`Ctrl + b`

- `Ctrl + b number`：切换会话；
- `Ctrl + b %`：划分左右两个窗格；
- `Ctrl + b "`：划分上下两个窗格；
- `Ctrl + b 方向键`：光标以当前窗格按照方向键方向切换窗格；
- `Ctrl + b c`：创建新窗口；
- `Ctrl + b ;`：切换到上一个窗格；
- `Ctrl + b o`：切换到下一个窗格；
- `Ctrl + b x`：关闭当前窗格；
- `Ctrl + b !`：将当前窗格拆分为独立窗口；
- `Ctrl + b d`：分离当前会话；
- `Ctrl + b s`：列出所有会话；
- `Ctrl + b $`：重命名当前会话；
- `Ctrl + b z`：当前窗格全屏显示，再按一次会恢复；

我觉得差不多够了。