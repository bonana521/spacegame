# API文档

本文档详细描述了太空探索游戏的技术API和接口。

## 📋 目录

- [核心API](#核心api)
- [游戏状态API](#游戏状态api)
- [渲染API](#渲染api)
- [控制API](#控制api)
- [物理API](#物理api)
- [UI API](#ui-api)
- [工具函数](#工具函数)

## 🎯 核心API

### 游戏初始化

#### `init()`
初始化游戏场景和所有系统。

```javascript
function init() {
    // 创建场景、相机、渲染器
    // 创建游戏对象
    // 设置事件监听
    // 开始游戏循环
}
```

**返回值**: `void`

#### `animate()`
游戏主循环，处理渲染和逻辑更新。

```javascript
function animate() {
    requestAnimationFrame(animate);
    updateGameLogic();
    renderer.render(scene, camera);
}
```

**返回值**: `void`

## 🎮 游戏状态API

### GameState对象

```javascript
const gameState = {
    camera: THREE.Camera,           // 游戏相机
    scene: THREE.Scene,            // 3D场景
    renderer: THREE.WebGLRenderer,  // 渲染器
    spaceship: THREE.Object3D,      // 飞船对象
    planets: Array,                // 行星数组
    stars: THREE.Points,           // 星空对象
    fuel: Number,                  // 燃料量
    speed: Number,                 // 当前速度
    maxSpeed: Number,              // 最大速度
    exploredSystems: Number,       // 已探索星系数量
    isWarpActive: Boolean,         // 曲速引擎状态
    targetPlanet: Object,         // 目标行星
    keys: Object,                 // 键盘状态
    mouse: Object,                // 鼠标状态
    clock: THREE.Clock            // 游戏时钟
};
```

### 状态更新函数

#### `updateSpaceship()`
更新飞船位置和状态。

```javascript
function updateSpaceship() {
    // 处理键盘输入
    // 更新飞船位置
    // 更新相机视角
    // 处理边界检查
}
```

**返回值**: `void`

#### `updateUI()`
更新UI显示信息。

```javascript
function updateUI() {
    // 更新位置显示
    // 更新速度显示
    // 更新燃料显示
    // 更新探索计数
}
```

**返回值**: `void`

## 🎨 渲染API

### 场景创建

#### `createStarField()`
创建星空背景。

```javascript
function createStarField() {
    const starGeometry = new THREE.BufferGeometry();
    const starMaterial = new THREE.PointsMaterial({
        color: 0xFFFFFF,
        size: 0.5,
        transparent: true,
        opacity: 0.8
    });
    
    // 生成50,000个随机星点
    const starVertices = [];
    for (let i = 0; i < 50000; i++) {
        const x = (Math.random() - 0.5) * 5000;
        const y = (Math.random() - 0.5) * 5000;
        const z = (Math.random() - 0.5) * 5000;
        starVertices.push(x, y, z);
    }
    
    starGeometry.setAttribute('position', new THREE.Float32BufferAttribute(starVertices, 3));
    return new THREE.Points(starGeometry, starMaterial);
}
```

**返回值**: `THREE.Points`

#### `createSpaceship()`
创建飞船对象。

```javascript
function createSpaceship() {
    const shipGroup = new THREE.Group();
    
    // 飞船主体
    const bodyGeometry = new THREE.ConeGeometry(1, 4, 8);
    const bodyMaterial = new THREE.MeshPhongMaterial({ 
        color: 0x4488FF,
        shininess: 100 
    });
    const body = new THREE.Mesh(bodyGeometry, bodyMaterial);
    body.rotation.x = Math.PI / 2;
    shipGroup.add(body);
    
    // 添加引擎和机翼...
    
    return shipGroup;
}
```

**返回值**: `THREE.Group`

#### `createPlanetSystem()`
创建行星系统。

```javascript
function createPlanetSystem() {
    const planetData = [
        { name: '地球', color: 0x4488FF, size: 3, distance: 50, speed: 0.01 },
        { name: '火星', color: 0xFF4444, size: 2, distance: 80, speed: 0.008 },
        // 更多行星...
    ];
    
    const planets = [];
    
    planetData.forEach((data, index) => {
        const planet = createPlanet(data);
        gameState.scene.add(planet.group);
        planets.push(planet);
    });
    
    return planets;
}
```

**返回值**: `Array`

## 🎮 控制API

### 键盘控制

#### `setupEventListeners()`
设置事件监听器。

```javascript
function setupEventListeners() {
    // 键盘事件
    document.addEventListener('keydown', (e) => {
        gameState.keys[e.key.toLowerCase()] = true;
    });
    
    document.addEventListener('keyup', (e) => {
        gameState.keys[e.key.toLowerCase()] = false;
    });
    
    // 鼠标事件
    document.addEventListener('mousemove', (e) => {
        gameState.mouse.x = (e.clientX / window.innerWidth) * 2 - 1;
        gameState.mouse.y = -(e.clientY / window.innerHeight) * 2 + 1;
    });
    
    // 窗口大小改变
    window.addEventListener('resize', onWindowResize);
}
```

**返回值**: `void`

#### `handleInput()`
处理用户输入。

```javascript
function handleInput() {
    const deltaTime = gameState.clock.getDelta();
    
    // 基础移动
    if (gameState.keys['w']) {
        gameState.spaceship.position.z -= 0.5;
        gameState.speed = Math.min(gameState.speed + 0.1, gameState.maxSpeed);
    }
    if (gameState.keys['s']) {
        gameState.spaceship.position.z += 0.5;
        gameState.speed = Math.max(gameState.speed - 0.1, 0);
    }
    // 更多控制...
}
```

**返回值**: `void`

### 鼠标控制

#### `updateCamera()`
更新相机视角。

```javascript
function updateCamera() {
    gameState.camera.position.x = gameState.spaceship.position.x + gameState.mouse.x * 10;
    gameState.camera.position.y = gameState.spaceship.position.y + gameState.mouse.y * 10;
    gameState.camera.position.z = gameState.spaceship.position.z + 20;
    gameState.camera.lookAt(gameState.spaceship.position);
}
```

**返回值**: `void`

## ⚡ 物理API

### 行星运动

#### `updatePlanets()`
更新行星位置。

```javascript
function updatePlanets() {
    gameState.planets.forEach(planet => {
        planet.angle += planet.data.speed;
        planet.group.position.x = Math.cos(planet.angle) * planet.data.distance;
        planet.group.position.z = Math.sin(planet.angle) * planet.data.distance;
        
        // 检查探索状态
        const distance = gameState.spaceship.position.distanceTo(planet.group.position);
        if (distance < planet.data.size + 10 && !planet.explored) {
            planet.explored = true;
            gameState.exploredSystems++;
        }
    });
}
```

**返回值**: `void`

### 碰撞检测

#### `checkCollisions()`
检查碰撞。

```javascript
function checkCollisions() {
    const spaceshipBox = new THREE.Box3().setFromObject(gameState.spaceship);
    
    gameState.planets.forEach(planet => {
        const planetBox = new THREE.Box3().setFromObject(planet.group);
        if (spaceshipBox.intersectsBox(planetBox)) {
            handleCollision(planet);
        }
    });
}
```

**返回值**: `void`

## 🎨 UI API

### UI元素

#### `updateUI()`
更新UI显示。

```javascript
function updateUI() {
    document.getElementById('position').textContent = 
        `${gameState.spaceship.position.x.toFixed(1)}, ${gameState.spaceship.position.y.toFixed(1)}, ${gameState.spaceship.position.z.toFixed(1)}`;
    document.getElementById('speed').textContent = gameState.speed.toFixed(1);
    document.getElementById('fuel').textContent = gameState.fuel.toFixed(1);
    document.getElementById('explored').textContent = gameState.exploredSystems;
}
```

**返回值**: `void`

### 特殊功能

#### `toggleWarp()`
切换曲速引擎。

```javascript
function toggleWarp() {
    gameState.isWarpActive = !gameState.isWarpActive;
    if (gameState.isWarpActive) {
        gameState.maxSpeed = 50;
        alert('曲速引擎已激活！');
    } else {
        gameState.maxSpeed = 10;
        alert('曲速引擎已关闭！');
    }
}
```

**返回值**: `void`

#### `findNearestPlanet()`
寻找最近行星。

```javascript
function findNearestPlanet() {
    let nearestPlanet = null;
    let minDistance = Infinity;
    
    gameState.planets.forEach(planet => {
        const distance = gameState.spaceship.position.distanceTo(planet.group.position);
        if (distance < minDistance) {
            minDistance = distance;
            nearestPlanet = planet;
        }
    });
    
    if (nearestPlanet) {
        gameState.targetPlanet = nearestPlanet;
        alert(`最近行星: ${nearestPlanet.data.name}，距离: ${(minDistance / 10).toFixed(1)} AU`);
    }
}
```

**返回值**: `void`

## 🔧 工具函数

### 数学工具

#### `distanceTo(point1, point2)`
计算两点距离。

```javascript
function distanceTo(point1, point2) {
    const dx = point1.x - point2.x;
    const dy = point1.y - point2.y;
    const dz = point1.z - point2.z;
    return Math.sqrt(dx * dx + dy * dy + dz * dz);
}
```

**参数**:
- `point1` (Object): 第一个点 {x, y, z}
- `point2` (Object): 第二个点 {x, y, z}

**返回值**: `Number`

#### `lerp(start, end, t)`
线性插值。

```javascript
function lerp(start, end, t) {
    return start + (end - start) * t;
}
```

**参数**:
- `start` (Number): 起始值
- `end` (Number): 结束值
- `t` (Number): 插值因子 (0-1)

**返回值**: `Number`

### 性能工具

#### `getFPS()`
获取当前FPS。

```javascript
let lastTime = performance.now();
let frameCount = 0;

function getFPS() {
    frameCount++;
    const currentTime = performance.now();
    const deltaTime = currentTime - lastTime;
    
    if (deltaTime >= 1000) {
        const fps = Math.round((frameCount * 1000) / deltaTime);
        frameCount = 0;
        lastTime = currentTime;
        return fps;
    }
    
    return null;
}
```

**返回值**: `Number | null`

### 调试工具

#### `debugLog(message)`
调试日志。

```javascript
function debugLog(message) {
    if (gameState.debug) {
        console.log(`[DEBUG] ${message}`);
    }
}
```

**参数**:
- `message` (String): 调试信息

**返回值**: `void`

## 📚 使用示例

### 基础使用

```javascript
// 初始化游戏
init();

// 创建新行星
const newPlanet = createPlanet({
    name: '新行星',
    color: 0x00FF00,
    size: 4,
    distance: 150,
    speed: 0.005
});

// 添加到场景
gameState.scene.add(newPlanet.group);
gameState.planets.push(newPlanet);

// 添加自定义控制
addCustomControl('p', () => {
    console.log('P键被按下');
});
```

### 高级使用

```javascript
// 自定义渲染管线
function customRender() {
    // 自定义渲染逻辑
    gameState.renderer.render(gameState.scene, gameState.camera);
    
    // 后处理效果
    if (postProcessingEnabled) {
        applyPostProcessing();
    }
}

// 性能监控
function monitorPerformance() {
    const fps = getFPS();
    if (fps < 30) {
        console.warn('性能警告: FPS过低');
        optimizePerformance();
    }
}
```

## 🔄 事件系统

### 自定义事件

```javascript
// 事件系统
const eventSystem = {
    listeners: {},
    
    on(event, callback) {
        if (!this.listeners[event]) {
            this.listeners[event] = [];
        }
        this.listeners[event].push(callback);
    },
    
    emit(event, data) {
        if (this.listeners[event]) {
            this.listeners[event].forEach(callback => {
                callback(data);
            });
        }
    }
};

// 使用示例
eventSystem.on('planetExplored', (planet) => {
    console.log(`行星 ${planet.name} 已被探索！`);
});

// 触发事件
eventSystem.emit('planetExplored', { name: '地球' });
```

---

*API文档版本: 0.1.0*  
*最后更新: 2024-01-01*