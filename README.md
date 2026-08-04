# WorldBridge

> **⚠️ 非开源项目 | All Rights Reserved**  
> 本仓库仅提供 **API 文档与依赖坐标**，供模组开发者将 WorldBridge 作为库/依赖集成。  
> **源代码不公开**，禁止反编译、修改、再分发、商用。  
> 仅允许作为 **库依赖** 在你的模组中使用 WorldBridge 的公开 API。
> 本模组目前是**开发状态**中，存在部分**已知Bug**，欢迎各位玩家提出问题到issues，我将处理大部分的问题。

---

## 📦 依赖坐标

### Gradle (build.gradle)

```groovy
repositories {
    maven { url 'https://maven.mow2333.top/releases' }
}

dependencies {
    // 仅在编译期需要，运行时由 WorldBridge 模组提供
    compileOnly fg.deobf("com.mow.mod.worldbridge:world_bridge:0.2.0")
    
    // 如果需要运行时也依赖（强制要求用户安装 WorldBridge）
    // runtimeOnly fg.deobf("com.mow.mod.worldbridge:world_bridge:0.2.0")
}
```

### Maven (pom.xml)

```xml
<repository>
    <id>worldbridge-releases</id>
    <url>https://maven.mow2333.top/releases</url>
</repository>

<dependency>
    <groupId>com.mow.mod.worldbridge</groupId>
    <artifactId>world_bridge</artifactId>
    <version>0.2.0</version>
    <scope>provided</scope>
</dependency>
```

> **版本对应关系**  
> - `0.2.0` → Minecraft 1.19.4 (Forge 45.2.0+) / 1.20.1 (Forge 47.2.0+)  
> - 请根据你的目标 MC 版本选择对应的 Forge 版本

---

## 🔧 公开 API 概览

WorldBridge 为模组开发者暴露以下核心 API 包：

### 1. 维度管理 API (`com.mow.mod.worldbridge.dimension`)

| 类/接口 | 用途 |
|---------|------|
| `DimensionData` | 维度数据实体（pairId、名称、世界类型、生物群系、种子、生成配置等） |
| `DimensionDataManager` | 维度数据的增删改查、持久化、查询（`SavedData` 单例） |
| `CustomDimensionData` | 自定义维度模板数据（biome_mix、generation、stacking 等完整配置） |
| `CustomDimensionManager` | 自定义维度模板的 CRUD、文件管理、关联维度查询 |
| `ModDimensions` | 维度创建、传送、删除、列表的核心工具类（反射创建维度） |
| `TeleportHelper` | 实体跨维度传送、安全出生点扫描、成就触发 |

**常用示例：**
```java
// 获取维度管理器
DimensionDataManager manager = DimensionDataManager.get(serverLevel);

// 创建自定义维度
ResourceKey<Level> dimKey = ModDimensions.createDynamicDimension(
    server, 
    "my_dimension", 
    "custom", 
    jsonConfig,  // 包含 biome_mix、generation、stacking 等完整配置
    player.getUUID()
);

// 跨维度传送
TeleportHelper.teleportToDimension(player, targetDimKey, x, y, z, true);
```

### 2. 世界之锚 API (`com.mow.mod.worldbridge.block.entity`)

| 类 | 用途 |
|----|------|
| `WorldAnchorBlockEntity` | 锚点方块实体，存储 PairID、自定义名、过载状态、冷却、祝福光环 |
| `WorldAnchorBlock` | 锚点方块，支持红石触发、右键交互、跨维度传送、过载模式 |

**事件监听：**
```java
// 监听锚点传送事件
ModEventBusEvents.WORLD_ANCHOR_TELEPORT.register((player, sourceAnchor, targetAnchor) -> {
    // 传送前/后逻辑
});
```

### 3. 红链系统 API (`com.mow.mod.worldbridge.redlink`)

| 类/接口 | 用途 |
|---------|------|
| `RedlinkBlockEntity` | 红链方块实体，双模式（发射器/接收器）、配对、信号强度 |
| `RedlinkWrenchItem` | 配对工具，两步点击配对/切换模式 |
| `EtherTriggerBlock` / `EtherTriggerBlockEntity` | 以太触发器（玩家/实体/物品/计时器/天气触发） |

**信号同步（跨维度零延迟）：**
```java
// 发射器自动同步给对端接收器，零延迟、同 tick
// 无需额外网络包，自动通过 server.getLevel(ResourceKey) 加载目标维度
```

### 4. 跨维漏斗 API (`com.mow.mod.worldbridge.block.entity`)

| 类 | 用途 |
|----|------|
| `TransdimensionalHopperBlockEntity` | 跨维漏斗核心逻辑：INPUT/OUTPUT/BOTH 模式、缓冲区、过滤器、配对、传送 |

```java
// 手动触发传送
hopperEntity.tryTransfer();
```

### 5. 成就/进度系统 (`com.mow.mod.worldbridge.advancement`)

| 类 | 用途 |
|----|------|
| `ModTrigger` | 可复用的 `SimpleCriterionTrigger` 基类，含 `awardDirectly()` 兜底授予 |
| `ModCriteria` | 11 个 Trigger 实例（进维度×3、结构发现×5、创世、深处、高空） |
| `ModCriteria.ENTER_CHAOS_ABYSSOS` | 进入混沌深渊 |
| `ModCriteria.ENTER_AETHERIAL_FIELDS` | 进入星界之野 |
| `ModCriteria.ENTER_DEEP_ABYSS` | 进入幽邃深渊 |
| `ModCriteria.GENESIS` | 创世（首次创建维度） |
| `ModCriteria.DEEP_DOWN` | 深不可测 (Y ≤ -64) |
| `ModCriteria.HIGH_FLY` | 星辰大海 (Y ≥ 100) |

**手动触发成就：**
```java
ModCriteria.ENTER_CHAOS_ABYSSOS.trigger(player);
```

### 6. 事件总线 (`com.mow.mod.worldbridge.event`)

```java
// 服务端 Tick 事件（每 tick）
ModEventBusEvents.SERVER_TICK.register(server -> { ... });

// 玩家 Tick 事件（每 tick）
ModEventBusEvents.PLAYER_TICK.register(player -> { ... });

// 维度创建/删除事件
ModEventBusEvents.DIMENSION_CREATED.register(dimKey -> { ... });
ModEventBusEvents.DIMENSION_DELETED.register(pairId -> { ... });

// 锚点传送
ModEventBusEvents.WORLD_ANCHOR_TELEPORT.register((player, src, tgt) -> { ... });

// 红链信号变化
ModEventBusEvents.REDLINK_SIGNAL_CHANGED.register((be, oldStrength, newStrength) -> { ... });
```

### 6. 配置系统 (`com.mow.mod.worldbridge.config`)

```java
// 服务端配置（worldbridge-server.toml）
ModConfig.DIMENSION_CONFIG.get().maxDimensionsPerPlayer();  // -1 无限制
ModConfig.WORLD_ANCHOR_CONFIG.get().baseTeleportRange();    // 5
ModConfig.REDLINK_CONFIG.get().allowCrossDimension();       // true
ModConfig.TRANSHOPPER_CONFIG.get().maxRate();               // 64 items/sec
```

---

## 📚 版本兼容性

| WorldBridge | Minecraft | Forge | 备注 |
|-------------|-----------|-------|------|
| 0.2.0 | 1.19.4 | 45.2.0+ | 完整功能 |
| 0.2.0 | 1.20.1 | 47.2.0+ | 完整功能 |
| 0.1.x | 1.19.4/1.20.1 | 对应版本 | 旧版本，不再维护 |

> **双分支同步维护**：`1.19.4` 分支与 `1.20.1` 分支功能完全一致，仅适配层差异。

---

## 📖 文档与支持

| 链接 | 说明 |
|------|------|
| **Wiki** | `https://github.com/mow2333/WorldBridge/wiki` |
| **更新日志 (中文)** | `CHANGELOG_CN.md` |
| **更新日志 (English)** | `CHANGELOG_EN.md` |
| **功能完整文档** | `FEATURES.md` |
| **问题反馈** | `https://github.com/mow2333/WorldBridge/issues` |

---

## ⚖️ 许可证

**All Rights Reserved**  
Copyright (c) 2026 mow2333

> 本项目**不开源**，不遵循 MIT/GPL/Apache 等开源协议。  
> **仅允许**：作为库依赖（`compileOnly`/`provided`）在你的模组中使用 WorldBridge 的公开 API。  
> **禁止**：反编译、修改、再分发、商用、二次打包、托管到其他站点。  
> 仅允许从官方渠道下载发布版 JAR 作为依赖。

---

## 📦 发布下载

| 版本 | Minecraft | Forge | 下载 |
|------|-----------|-------|------|
| `{version}` | 1.20.1 | 47.2.0+ | [world_bridge-forge-47.2.0+-{version}-1.20.1.jar](https://github.com/mow2333/WorldBridge/releases/tag/{version}) |
| `{version}` | 1.19.4 | 45.2.0+ | [world_bridge-forge-45.2.0+-{version}-1.19.4.jar](https://github.com/mow2333/WorldBridge/releases/tag/{version}) |

> **使用说明**：将上表中的 `{version}` 替换为具体版本号（如 `0.2.0`、`0.2.1`、`0.3.0` 等），即可得到对应版本的下载链接。  
> 仅从 GitHub Releases 下载，请勿从第三方站点下载。

---

**WorldBridge** — 连接不同世界的桥梁  
`A bridge connecting different worlds.`
