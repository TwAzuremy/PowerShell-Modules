# WCAG Contrast PowerShell Module

一个用于计算颜色对比度并检查 WCAG（Web Content Accessibility Guidelines）合规性的 PowerShell 模块。

## 功能特性

- 🔍 计算颜色的相对亮度
- 📊 计算两种颜色之间的对比度比率
- ✅ 根据 WCAG 2.1 标准检查对比度合规性
- 🎨 支持 HEX 和 RGB 颜色格式
- 📝 考虑文本大小和粗细对合规性的影响
- 📋 提供详细的测试结果输出

## 安装方法

1. 将 `WCAG-Contrast.psm1` 文件保存到 PowerShell 模块目录：

   ```text
   $env:PSModulePath.Split(';')[0] + "\WCAG-Contrast\WCAG-Contrast.psm1"
   ```

   

2. 在 PowerShell 中导入模块：

   ```powershell
   Import-Module WCAG-Contrast
   ```

   

## 使用方法

### 主要函数

#### `WCAG-Contrast`

测试两种颜色之间的对比度并返回 WCAG 合规性结果。

**语法：**

```powershell
WCAG-Contrast -ForegroundColor <string> -BackgroundColor <string> [-TextSize <int>] [-IsBold <bool>] [-ColorFormat <string>]
```



**参数：**

- `ForegroundColor`：前景色（必需）
- `BackgroundColor`：背景色（必需）
- `TextSize`：文本大小（单位：pt，默认：16）
- `IsBold`：文本是否为粗体（默认：$false）
- `ColorFormat`：颜色格式，"Hex" 或 "RGB"（默认："Hex"）

### 示例

#### 基本用法

```powershell
# 测试黑白对比度
WCAG-Contrast -ForegroundColor "#FFFFFF" -BackgroundColor "#000000"

# 输出示例：21.00:1 - AAA (#FFFFFF on #000000, Text Size: 16px, Bold: False)
```



#### 不同文本大小

```powershell
# 测试大文本的对比度
WCAG-Contrast -ForegroundColor "#336699" -BackgroundColor "#FFFFFF" -TextSize 18

# 测试小文本的对比度
WCAG-Contrast -ForegroundColor "#888888" -BackgroundColor "#FFFFFF" -TextSize 12
```



#### 粗体文本

```powershell
# 测试粗体文本的对比度
WCAG-Contrast -ForegroundColor "#666666" -BackgroundColor "#F0F0F0" -TextSize 14 -IsBold $true
```



#### 使用 RGB 格式

```powershell
# 使用 RGB 格式的颜色
WCAG-Contrast -ForegroundColor "255,255,255" -BackgroundColor "0,0,0" -ColorFormat "RGB"
```



## WCAG 合规性标准

### 普通文本

- **AAA 级**：对比度 ≥ 7.0:1
- **AA 级**：对比度 ≥ 4.5:1
- **失败**：对比度 < 4.5:1

### 大文本（18pt 以上，或 14pt 粗体）

- **AAA 级**：对比度 ≥ 4.5:1
- **AA 级**：对比度 ≥ 3.0:1
- **失败**：对比度 < 3.0:1

## 辅助函数

模块还包含以下内部函数，可供高级用户使用：

- `Get-RelactiveLuminance`：计算颜色的相对亮度
- `Get-ContrastRatio`：计算两种颜色的对比度比率
- `Test-WCAGCompliance`：测试对比度是否符合 WCAG 标准
- `ConvertFrom-HexColor`：将 HEX 颜色转换为 RGB 值
- `Test-WCAGContrast`：完整的对比度测试函数

## 颜色格式支持

### HEX 格式

- 6位格式：`#RRGGBB`（例如：`#FF5733`）
- 3位格式：`#RGB`（例如：`#F53`，会自动扩展为 `#FF5533`）

### RGB 格式

- 逗号分隔：`R,G,B`（例如：`255,87,51`）

## 输出说明

函数返回的对象包含以下属性：

- `ForegroundColor`：前景色
- `BackgroundColor`：背景色
- `ContrastRatio`：对比度比率（格式：X.XX:1）
- `WCAGLevel`：WCAG 合规级别（"AAA"、"AA" 或 "Fail"）
- `TextSize`：文本大小
- `IsBold`：文本是否为粗体
- `IsLargeText`：是否为大文本

## 系统要求

- Windows PowerShell 5.1 或更高版本
- PowerShell Core 6.0 或更高版本

## 许可证

本项目采用 MIT 许可证。

## 作者

Azuremy - 2025-10-08

------

**注意**：此模块基于 WCAG 2.1 标准，适用于网页和应用程序的可访问性设计验证。