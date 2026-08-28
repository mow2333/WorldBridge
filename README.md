# WorldBridge

> **⚠️ 非开源项目 | All Rights Reserved**
> 本仓库仅提供 **API 文档与依赖坐标**，供模组开发者将 WorldBridge 作为库/依赖集成。
> **源代码不公开**，禁止反编译、修改、再分发、商用。
> 仅允许作为 **库依赖** 在你的模组中使用 WorldBridge 的公开 API。
> 本模组目前是**开发状态**中，存在部分**已知Bug**，欢迎各位玩家提出问题到issues，我将处理大部分的问题。
> **如需源代码，请在社交媒体上直接询问作者，酌情提供。**

---

## 📦 依赖坐标

### Gradle (build.gradle)

```groovy
repositories {
// 注意：0.4.0 版本的 Maven 仓库可能不可用，建议改用本地 JAR 方式
// maven { url 'https://maven.mow2333.top/releases' }
}

dependencies {
// 推荐方式：直接将 JAR 放入项目根目录的 libs 文件夹
implementation fg.deobf(fileTree("libs"))

// 如果 Maven 仓库修复，可改用：
// compileOnly fg.deobf("com.mow.mod.worldbridge:world_bridge:0.4.0")
}
```

> **⚠️ 注意**：`0.4.0` 版本的 Maven 仓库可能不可用，建议直接从 GitHub Releases 下载 JAR 并放入 `libs` 文件夹。

---

## 🔧 公开 API 概览（基于 0.4.0 版本实际 JAR 结构）

WorldBridge 为模组开发者暴露以下核心 API 包：

### 1. 维度管理 API

| 类/接口 | 实际路径 |
|---------|----------|
| `DimensionData` | `com.mow.mod.worldbridge.dimension.DimensionData` |
| `DimensionDataManager` | `com.mow.mod.worldbridge.dimension.DimensionDataManager` |
| `ModDimensions` | `com.mow.mod.worldbridge.dimension.ModDimensions` |
| `GameRuleConfig` | `com.mow.mod.worldbridge.dimension.GameRuleConfig` |
| `GenerationConfig` | `com.mow.mod.worldbridge.dimension.GenerationConfig` |
| `PermissionSettings` | `com.mow.mod.worldbridge.dimension.PermissionSettings` |
| `RuinedChunkGenerator` | `com.mow.mod.worldbridge.dimension.RuinedChunkGenerator` |
| `CustomDimensionData` | `com.mow.mod.worldbridge.dimension.custom.CustomDimensionData` |
| `CustomDimensionManager` | `com.mow.mod.worldbridge.dimension.custom.CustomDimensionManager` |
| `CommandDimensionEntry` | `com.mow.mod.worldbridge.dimension.custom.CommandDimensionEntry` |
| `WeightedBiomeSource` | `com.mow.mod.worldbridge.dimension.custom.WeightedBiomeSource` |

**常用示例：**
```java
// 获取维度管理器
DimensionDataManager manager = DimensionDataManager.get(serverLevel);

// 获取所有维度
List<DimensionData> allDims = manager.getAllDimensions();

// 获取维度数据
DimensionData data = manager.getDimensionData(pairId);
```

### 2. 事件总线 API

所有事件监听请使用 `WorldBridgeEvents` 类，位于 `api` 包下。

| 类/接口 | 实际路径 |
|---------|----------|
| `WorldBridgeEvents\` | `com.mow.mod.worldbridge.api.WorldBridgeEvents\` |
| `WorldBridgeEvents.DimensionCreateEvent\` | `com.mow.mod.worldbridge.api.WorldBridgeEvents$DimensionCreateEvent\` |
| `WorldBridgeEvents.DimensionRemoveEvent\` | `com.mow.mod.worldbridge.api.WorldBridgeEvents$DimensionRemoveEvent\` |
| `WorldBridgeEvents.DimensionUpdateEvent\` | `com.mow.mod.worldbridge.api.WorldBridgeEvents$DimensionUpdateEvent\` |
| `WorldBridgeEvents.PlayerTeleportEvent\` | `com.mow.mod.worldbridge.api.WorldBridgeEvents$PlayerTeleportEvent\` |

**监听示例：**
```java
import com.mow.mod.worldbridge.api.WorldBridgeEvents;
import com.mow.mod.worldbridge.api.WorldBridgeEvents.DimensionCreateEvent;
import net.minecraftforge.eventbus.api.SubscribeEvent;

public class MyListener {
@SubscribeEvent
public void onDimensionCreate(DimensionCreateEvent event) {
// 维度被创建时触发
System.out.println("维度已创建");
}
}
```

### 3. 跨维度传送 API

| 类 | 实际路径 |
|----|----------|
| `TeleportHelper` | `com.mow.mod.worldbridge.util.TeleportHelper` |

**传送示例：**
```java
import com.mow.mod.worldbridge.util.TeleportHelper;

// 传送玩家到目标维度
TeleportHelper.teleportToDimension(player, targetDimKey, x, y, z, true);
```

### 4. 配置系统

| 类 | 实际路径 |
|----|----------|
| `ModConfig` | `com.mow.mod.worldbridge.config.ModConfig` |

```java
import com.mow.mod.worldbridge.config.ModConfig;

// 读取服务端配置
ModConfig.DIMENSION_CONFIG.get().maxDimensionsPerPlayer();
```

### 5. 世界之锚 API

| 类 | 实际路径 |
|----|----------|
| `WorldAnchorBlock` | `com.mow.mod.worldbridge.block.WorldAnchorBlock` |
| `WorldAnchorBlockEntity` | `com.mow.mod.worldbridge.block.entity.WorldAnchorBlockEntity` |

### 6. 红链系统 API

| 类/接口 | 实际路径 |
|---------|----------|
| `RedlinkBlock` | `com.mow.mod.worldbridge.redlink.RedlinkBlock` |
| `RedlinkBlockEntity` | `com.mow.mod.worldbridge.redlink.RedlinkBlockEntity` |
| `RedlinkWrenchItem` | `com.mow.mod.worldbridge.redlink.RedlinkWrenchItem` |
| `RedlinkButtonBlock` | `com.mow.mod.worldbridge.redlink.RedlinkButtonBlock` |
| `RedlinkLeverBlock` | `com.mow.mod.worldbridge.redlink.RedlinkLeverBlock` |
| `RedlinkPressurePlateBlock` | `com.mow.mod.worldbridge.redlink.RedlinkPressurePlateBlock` |
| `EtherTriggerBlock` | `com.mow.mod.worldbridge.redlink.EtherTriggerBlock` |
| `EtherTriggerBlockEntity` | `com.mow.mod.worldbridge.redlink.EtherTriggerBlockEntity` |
| `TriggerType` | `com.mow.mod.worldbridge.redlink.TriggerType` |
| `RedlinkPairData` | `com.mow.mod.worldbridge.redlink.RedlinkPairData` |

### 7. 跨维漏斗 API

| 类 | 实际路径 |
|----|----------|
| `TransdimensionalHopperBlock` | `com.mow.mod.worldbridge.block.TransdimensionalHopperBlock` |
| `TransdimensionalHopperBlockEntity` | `com.mow.mod.worldbridge.block.entity.TransdimensionalHopperBlockEntity` |

### 8. 成就/进度系统

| 类 | 实际路径 |
|----|----------|
| `ModCriteria` | `com.mow.mod.worldbridge.advancement.ModCriteria` |
| `ModTrigger` | `com.mow.mod.worldbridge.advancement.ModTrigger` |

```java
import com.mow.mod.worldbridge.advancement.ModCriteria;

// 触发成就
ModCriteria.ENTER_CHAOS_ABYSSOS.trigger(player);
```

### 9. 核心 API 入口

| 类 | 实际路径 |
|----|----------|
| `WorldBridgeAPI` | `com.mow.mod.worldbridge.api.WorldBridgeAPI` |
| `IDimensionFactory` | `com.mow.mod.worldbridge.api.IDimensionFactory` |
| `DimensionFactoryRegistry` | `com.mow.mod.worldbridge.api.DimensionFactoryRegistry` |

### 10. 方块/物品/容器注册

| 类 | 实际路径 |
|----|----------|
| `ModBlocks` | `com.mow.mod.worldbridge.block.ModBlocks` |
| `ModItems` | `com.mow.mod.worldbridge.item.ModItems` |
| `ModMenus` | `com.mow.mod.worldbridge.container.ModMenus` |
| `ModScreens` | `com.mow.mod.worldbridge.gui.ModScreens` |
| `ModSounds` | `com.mow.mod.worldbridge.sound.ModSounds` |

---

## 📚 版本兼容性

| WorldBridge | Minecraft | Forge | 备注 |
|-------------|-----------|-------|------|
| `0.4.0` | 1.20.1/1.19.4/ ... | 47.2.0+/ ... | 当前推荐版本 |
| 旧版本 | 1.20.1/1.19.4/ ... | 对应版本 | 不再维护 |

> **具体版本请查看**：[GitHub Releases](https://github.com/mow2333/WorldBridge/releases)

---

## 📖 文档与支持

| 链接 | 说明 |
|------|------|
| **Wiki** | `https://github.com/mow2333/WorldBridge/wiki\` |
| **更新日志 (中文)** | `CHANGELOG_CN.md` |
| **功能完整文档** | `FEATURES.md` |
| **问题反馈** | `https://github.com/mow2333/WorldBridge/issues\` |

---

## ⚖️ 许可证

**All Rights Reserved**
Copyright (c) 2026 mow2333

> 本项目**不开源**，不遵循 MIT/GPL/Apache 等开源协议。
> **仅允许**：作为库依赖（`compileOnly`/`provided`/本地 JAR）在你的模组中使用 WorldBridge 的公开 API。
> **禁止**：反编译、修改、再分发、商用、二次打包、托管到其他站点。

---

## 📦 发布下载

| 版本 | Minecraft | Forge | 下载 |
|------|-----------|-------|------|
| `{version}` | 1.20.1 | 47.2.0+ | world_bridge-forge-47.2.0+-{version}-1.20.1.jar |
| `{version}` | 1.19.4 | 45.2.0+ | world_bridge-forge-45.2.0+-{version}-1.19.4.jar |

> **使用说明**：将上表中的 `{version}` 替换为具体版本号（如 `0.2.0`、`0.2.1`、`0.3.0`、`0.4.0` 等），即可得到对应版本的下载链接。
> 仅从 GitHub Releases 下载，请勿从第三方站点下载。
> **当前推荐版本**：`0.4.0`（适用于 Minecraft 1.20.1 / Forge 47.2.0+）

---

WorldBridge — 连接不同世界的桥梁
`A bridge connecting different worlds.`
