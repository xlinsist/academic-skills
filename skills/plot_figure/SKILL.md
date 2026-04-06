---
name: plot_figure
description: Use when users need a standardized grouped bar chart template for baseline-vs-method comparisons, with fixed axis/legend/color/data-label conventions and user-provided methods/data.
---

# Plot Figure

用于把“与 baseline 比较的可视化”统一为同一套柱状图模板。  
这个 skill 只固定绘图模板细节，不固定具体方法名和数据；方法与数据由用户输入描述。

## 适用场景

- 用户要画“baseline vs 其它方法”的对比图。
- 需要统一视觉规范：横轴、纵轴、legend、配色、柱顶数值。
- 输入通常包含：任务名、x 轴类别、各方法名称、各方法对应数值、输出文件名。

## 固定模板约束

- 图类型：分组柱状图（grouped bar chart）。
- 横轴：用户给定类别（通常是 shape/size/batch 等），以离散标签显示。
- 纵轴：性能指标数值，默认标签 `Execution Time (s)`（可按用户要求改名）。
- Legend：必须显示 baseline 与其它方法名称。
- 配色：
  - baseline：`#182345`
  - 对比方法主色：`#FFC000`
  - 若方法超过 2 个，在此两色基础上扩展，但 baseline 保持 `#182345`。
- 柱上数值：必须展示，默认 `fmt='%.2f'`、`padding=3`、`fontsize=10`。
- 版式：
  - `figsize=(9, 6)`
  - `grid(axis='y', linestyle='--', alpha=0.3)`
  - 统一较大字体（见模板脚本 `plt.rcParams.update(...)`）。

## 工作流程

1. 先收集用户输入：
- baseline 名称。
- 对比方法名称列表。
- x 轴标签列表。
- 每个方法对应的 y 值列表（长度需与 x 轴一致）。
- 图标题、y 轴标题、输出文件名。

2. 使用模板脚本生成图：
- 从 `scripts/plot_figure_template.py` 拷贝一份到当前工作目录。
- 仅替换数据区与元信息区，不改动模板风格约束。

3. 基础校验：
- 检查每个方法数据长度是否等于 x 轴长度。
- 检查是否包含 baseline。
- 检查输出文件成功生成。

## 资源

- 模板脚本：`scripts/plot_figure_template.py`
- 模板说明：`references/template_notes.md`
