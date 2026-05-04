---
name: analysis-module
description: Use when users need a structured “system understanding + design analysis” of a specific module in an AI repository, covering interface/data, pipeline role, data construction, supervision signals, model structure, loss/training, design motivation, system usage, limitations, and alternative design space.
---

# Analysis Module

用于对 AI 仓库中的某个具体模块做“系统理解 + 设计分析”。

这个 skill 的目标不是复述代码，而是回答三个核心问题：
- 这个模块吃什么、吐什么、被谁调用。
- 它为什么被设计成这样，而不是更简单的做法。
- 如果删掉它或替换它，系统会损失什么、还能不能跑。

## 适用场景

- 用户要求分析某个具体模块的输入/输出、角色和训练逻辑。
- 用户希望从系统设计角度理解一个 encoder / retriever / scorer / planner / loss / data builder / cache 模块。
- 用户明确要求按固定问题顺序输出，而不是自由发挥式讲解。

## 输入要求

优先从用户输入中获取：
- 模块名、类名、函数名，或目录路径。
- 仓库根目录。
- 任务背景（训练 / 推理 / 检索 / 排序 / 规划 / 编译 / agent loop 等）。

如果用户没有明确指定模块：
- 先在仓库中定位最核心、最可分析的单一模块。
- 明确写出你选了哪个模块，以及为什么它是合理入口。
- 不要扩展成整个仓库综述。

## 工作流程

### 1. 先锁定边界

确认本次分析对象是一个**可闭环的模块**，而不是整个系统。

优先定位：
- 模块定义文件（class / function / package 入口）。
- 调用它的上游入口。
- 消费它输出的下游入口。

### 2. 先查接口，再谈设计

必须先回答：
- 输入的数据类型是什么。
- 输入来自哪里。
- 进入模块前做了哪些预处理。
- 输出的形式、结构、维度和用途是什么。

如果接口在代码中分散：
- 从 `forward` / `__call__` / `run` / `step` / `compute` / `loss` / `predict` / `search` / `collate_fn` / `Dataset.__getitem__` 等入口拼起来。

### 3. 追踪数据构造与监督信号

重点查这些位置：
- dataset / dataloader / sampler / collator
- pair/triplet builder
- replay buffer / trajectory buffer / cache
- label builder / pseudo label / reward / metric
- config 中的采样、负样本、温度、margin、窗口长度等

必须明确：
- 样本是独立样本，还是 pair / triplet / sequence / trajectory / graph。
- 正负样本、目标值、奖励、对比对是怎么来的。
- 哪些部分是人工构造的，哪些来自真实观测。

### 4. 追踪模型内部结构

按下面的顺序拆：
- 表示层：encoder / embedding / feature projection
- 交互层：cross attention / message passing / state-action interaction / matching / pooling
- 输出层：classifier / regressor / scorer / value head / policy head / decoder

不要只说“用了 Transformer / GNN / MLP”，要说明：
- 哪部分负责表示。
- 哪部分负责交互。
- 哪部分负责产出最终决策变量。

### 5. 追踪训练目标与训练流程

重点看：
- `loss` 定义
- batch 组织
- sampler 逻辑
- pretrain / finetune / freeze / teacher forcing / curriculum
- optimizer / scheduler / EMA / cache refresh

必须区分：
- 模块学的到底是概率、距离、相似度、排序关系，还是状态值。
- loss 是单一目标还是多目标组合。
- 训练流程有没有阶段性和工程折中。

### 6. 做 Why 分析，而不是 What 复述

至少从三个角度解释设计动机：
- 结构性：这个结构是否贴合问题本质。
- 对比性：为什么不直接用更简单的 baseline。
- 工程性：是否受限于算力、数据量、稳定性、吞吐、延迟、标注成本。

### 7. 做系统级反事实分析

必须回答：
- 如果删掉这个模块，系统还能否运行。
- 退化成什么 baseline。
- 失去的是表达能力、鲁棒性、检索精度、训练稳定性，还是泛化能力。

## 证据要求

每个关键结论尽量绑定到具体证据：
- 文件
- 类 / 函数 / 配置项
- 调用关系

如果是从多处代码拼出来的结论，明确标记：
- `代码直接表明`
- `根据调用链推断`
- `仓库中未显式写明，只能保守推断`

不要把推断说成事实。

## 输出规范

默认输出语言跟随用户。

必须严格按下面顺序输出，不要改标题顺序，不要合并章节：

### 【一、接口与数据（先搞清输入输出）】

#### 1. 输入是什么？
- 数据类型（text / tensor / graph / IR / sequence 等）
- 数据来源（原始数据 / 上游模块输出 / 缓存）
- 是否经过预处理？（截断、归一化、tokenization 等）

#### 2. 输出是什么？
- 输出形式（embedding / score / state / label 等）
- 输出维度或结构
- 输出将被谁使用（下游模块或系统组件）

### 【二、模块整体定位（它在系统中的角色）】

#### 3. 这个模块在整个 pipeline 中的作用是什么？
- 上游是谁？下游是谁？
- 它解决的是“表示 / 转移 / 预测 / 排序 / 搜索”中的哪一类问题？
- 它负责什么？不负责什么？

### 【三、数据构造与监督信号（核心！）】

#### 4. 数据是怎么构造的？
- 样本是独立的，还是有结构（pair / triplet / trajectory）？
- 是否有分组信息、时间序列或状态链？
- 是否引入了人为构造（如负样本、增强、采样策略）？

#### 5. 监督信号从哪里来？
- 人工标签 / 测量值 / 自监督 / 对比构造？
- 正负样本是如何定义的？

### 【四、模型与表示（它是怎么做的）】

#### 6. 模型结构是什么？
- 表示层（encoder）
- 交互层（state/action/feature interaction）
- 输出层（head）
- 是否有特殊结构（如 attention / graph / TransH / pooling 等）

### 【五、训练目标与优化（它学什么）】

#### 7. 训练目标（loss）是什么？
- 是 regression / classification / contrastive / ranking？
- 优化的是距离 / 概率 / 排序 / 相似度？
- 是否有多种 loss 组合？各自作用是什么？

#### 8. 训练流程是怎样的？
- 一个 batch 的构成是什么？
- 是否有采样策略、缓存、分阶段训练（pretrain / finetune）？
- 是否冻结部分模块？

### 【六、设计动机（Why，必须重点分析）】

#### 9. 为什么这样设计？
请至少从三个角度解释：
- （结构性）是否符合问题本质（例如：是否建模了序列、图、状态转移等）
- （对比性）为什么不用更简单的方法（如 MLP / 直接回归）
- （工程性）是否受限于算力、数据规模、稳定性等

### 【七、系统接口与作用（落地价值）】

#### 10. 这个模块的输出在系统中具体如何被使用？
- 是否直接参与决策（如排序、搜索）
- 还是作为中间表示（embedding / state）

### 【八、局限与风险（Critical Thinking）】

#### 11. 这个模块的主要局限是什么？
- 表达能力限制（如文本 vs 结构）
- 数据假设是否可能被破坏
- 是否存在误差传播（error propagation）
- 泛化能力如何

### 【九、设计空间分析（核心提升点）】

#### 12. 如果删除这个模块，会发生什么？
- 系统是否还能运行？
- 性能/能力会损失在哪些方面？
- 它是“必须模块”还是“增强模块”？

#### 13. 是否存在更简单的替代方案？（至少给出一个）
- 一个最小可行 baseline（naive 方案）
- 一个稍复杂但更通用的替代方案
- 与当前设计的对比（优缺点）

### 【十、总结（抽象到设计层）】

#### 14. 请总结：
- 该模块的最小 baseline 是什么？
- 当前设计比 baseline 强在哪里？
- 它的核心 trade-off 是什么？

## 质量门槛

完成前检查：
- 是否真的说清了输入、输出、上游、下游。
- 是否明确了数据构造与监督信号，而不只是模型结构。
- 是否解释了为什么这样设计，而不只是复述层名。
- 是否给出了“删除模块会怎样”的反事实分析。
- 是否区分了事实、代码推断和个人判断。

## 使用示例

```text
请用 analysis-module 分析这个仓库里的 retriever 模块，重点看数据构造、负样本和 loss。
```

```text
请对 `models/world_model.py` 做系统理解 + 设计分析，严格按 analysis-module 的 10 个部分输出。
```
