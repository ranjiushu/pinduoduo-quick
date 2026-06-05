# 取快递

一键跳转拼多多快递取件身份码页面的安卓快捷工具。

大学生取快递时，不用再打开拼多多 → 手动翻到取快递页面。点击这个 App 的图标，直接跳转到拼多多「取快递-扫码亮灯」页，快速出示身份码。

## 用法

1. 从 [`apk/`](apk/) 目录下载最新 APK 并安装
2. 点击图标
3. 自动跳转到拼多多快递身份码页面

## 构建

环境：Android SDK 28+, JDK 17+

```bash
./build.sh
```

APK 输出路径：`build/apk/app.aligned.apk`，发布版在 [`apk/`](apk/) 目录。

## 技术细节

| 项目 | 内容 |
|------|------|
| 包名 | `com.example.pinduoduo.quick` |
| Deep Link | `pinduoduo://com.xunmeng.pinduoduo/mdkd/package` |
| 最低 SDK | Android 7.0 (API 24) |
| 主题 | `Theme.NoDisplay`（无界面，启动即跳转） |

## License

MIT
