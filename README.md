# WorldBridge — 世界之桥

> **⚠️ 非开源项目 | All Rights Reserved**
>
> 本仓库仅提供 **API 文档与依赖坐标**，供模组开发者将 WorldBridge 作为库/依赖集成。
>
> **源代码不公开**，禁止反编译、修改、再分发、商用。
>
> 仅允许作为 **库依赖** 在你的模组中使用 WorldBridge 的公开 API。
>
> 本模组目前是**开发状态**中，存在部分**已知Bug**，欢迎各位玩家提出问题到 issues，我将处理大部分的问题。
>
> **如需源代码，请在社交媒体上直接询问作者，酌情提供。**

---

> **世界尽头的那扇门，你推开了吗？**
>
> WorldBridge 是一个让你**亲手创造世界、跨越世界、统治世界**的 Forge 模组。
> 每一个维度，都是一整个宇宙。

![Minecraft](https://img.shields.io/badge/Minecraft-1.19.0_--_1.20.4-3b8e5f) ![Forge](https://img.shields.io/badge/Forge-41.0.68_--_49.1.0-8a5f3b) ![Loader](https://img.shields.io/badge/loader-Forge%20FML-6b4f8a)

---

## ✨ 核心特性

| 系统 | 说明 |
|------|------|
| 🌍 **维度创造** | 8 种内建世界类型 + JSON 自定义维度模板，地形/群系/海洋/洞穴/矿脉/规则全参数可调 |
| 🏰 **三神秘维度** | Χάος Ἄβυσσος（名讳不可言说）、星界之野（云上浮岛）、幽邃深渊（黑暗地底） |
| 🗿 **世界之锚** | 跨维传送锚点、Chunk 常加载、祝福光环、过载粒子环、50 点耐久星锚奇点 |
| 🕸️ **维度地球仪** | 悬浮星空 3D 地球仪，把创造的所有世界连成维度网络 |
| ⚡ **红链系统** | 无线红石信号总线——拉 A 世界的杆，亮 B 世界的灯，零延迟跨维度 |
| 📦 **跨维漏斗** | 物品自动穿越次元——矿洞直通仓库的宇宙传送带 |
| 🏆 **成就系统** | 13 触发器 / 11 进度，每一句解锁诗都值得截图 |
| 🔐 **密码锁维度** | 你的世界，别人进不来 |
| 🎨 **全界面主题化** | 自研 GuiTheme 主题系统，全部界面原版控件清零 |

## ✅ 支持的版本

**10 个 Minecraft 版本全支持**，换版本不换体验：

| Minecraft | Forge | 维护起点 |
|-----------|-------|---------|
| 1.19 | 41.0.68+ | 0.3.3 |
| 1.19.1 | 42.0.0+ | 0.3.3 |
| 1.19.2 | 43.2.0+ | 0.3.3 |
| 1.19.3 | 44.0.20+ | 0.3.3 |
| 1.19.4 | 45.2.0+ | 0.2.2 |
| 1.20 | 46.0.1+ | 0.3.3 |
| **1.20.1** | **47.2.0+** | **0.1.0** |
| 1.20.2 | 48.0.0+ | 0.3.3 |
| 1.20.3 | 49.0.0+ | 0.3.3 |
| 1.20.4 | 49.1.0+ | 0.3.3 |

## 🌐 本地化

全 6 语言：**简体中文 / English / 日本語 / 繁體中文 / Français / 한국어**

---

## 📦 依赖坐标

```groovy
repositories {
    // 注意：Maven 仓库可能不可用，建议改用本地 JAR 方式
    // maven { url 'https://maven.mow2333.top/releases' }
}

dependencies {
    // 推荐方式：从 Releases 下载 JAR 放入项目 libs 文件夹
    implementation fg.deobf(fileTree("libs"))

    // 若 Maven 仓库可用，可改用：
    // compileOnly fg.deobf("com.mow.mod.worldbridge:world_bridge:0.5.0")
}
```

> 公开 API 以独立仓库维护：**https://github.com/mow2333/WorldBridge-API**（接口 / 事件 / 数据类，MIT）

## 🔧 公开 API 一览

| 系统 | 门面 | 事件 | 服务接口 |
|------|------|------|---------|
| 维度 | `WorldBridgeAPI` | `WorldBridgeEvents` | `IWorldBridgeService` |
| 红链 | `RedlinkAPI` | `RedlinkEvents` | `RedlinkService` |
| 跨维漏斗 | `HopperAPI` | `HopperEvents` | `HopperService` |
| 维度地球仪 | `GlobeAPI` | — | `GlobeService` |

所有门面均为**服务定位模式**：主 mod 加载后自动注册实现，调用前可用
`WorldBridgeAPI.isServiceAvailable()` 等确认；服务未注册时调用会抛 `IllegalStateException`。
生命周期事件经 Forge 事件总线发布，用 `@SubscribeEvent` 监听（如 `RedlinkEvents.RedlinkPairEvent`）。

详细用法见 [WorldBridge-API](https://github.com/mow2333/WorldBridge-API) 的 README。

---

## 📖 文档与支持

| 链接 | 说明 |
|------|------|
| **📚 Wiki 文档站** | https://mow2333.github.io/WorldBridge/ |
| **🐛 问题反馈** | https://github.com/mow2333/WorldBridge/issues |
| **📦 发布下载** | https://github.com/mow2333/WorldBridge/releases |
| **🔌 API 仓库** | https://github.com/mow2333/WorldBridge-API |

> 仅从 GitHub Releases 下载，请勿从第三方站点下载。

---

## 📜 License

**All Rights Reserved** · Copyright (c) 2026 mow2333

本项目**不开源**，使用条款见本文件顶部「非开源项目」声明：
- ✅ 允许：作为库依赖（`compileOnly` / 本地 JAR）使用公开 API 集成
- ❌ 禁止：反编译、修改、再分发、商用、二次打包、托管到其他站点

公开的 API 模块（[WorldBridge-API](https://github.com/mow2333/WorldBridge-API)）为 **MIT**。

---

WorldBridge — 连接不同世界的桥梁
`A bridge connecting different worlds.`
