---
name: deep-research
description: Use this skill when conducting topic-based literature surveys with OpenAlex-first retrieval, structured paper synthesis, and repeatable GUIDE-to-report workflow.
---

# Deep Research

用于把“按主题做文献调研”落地为可复用流程：输入主题约束，先验证 OpenAlex，可复现检索后输出结构化报告与追问记录。

## 目录约定

- 每个调研主题使用一个独立文件夹（建议 `snake_case`）。
- 主题目录最少包含：
  - `GUIDE.md`：检索范围与任务要求（Topic / Focus on / Relevant systems / Tasks + OpenAlex-first policy + 输出结构要求）。
  - `report.md`：结构化调研输出（论文表、taxonomy、趋势、问题）。
  - 其他 `*.md`：追问与扩展记录。

## 工作流程

1. 新建主题目录
   - 示例：`mkdir new_topic`
2. 写主题约束
   - 在主题目录内创建 `GUIDE.md`，明确 Topic、关注点、系统范围、任务产出。
   - `GUIDE.md` 必须包含下列固定要求（可在主题上做替换，但结构不要删）：
     - OpenAlex-first 检索策略：
       - Use OpenAlex as the primary index for recall (papers + metadata), then follow through to the best landing page (venue / arXiv / publisher) for details.
       - When OpenAlex misses a system/paper name (indexing lag happens), fall back to direct web search and then re-query OpenAlex by DOI/arXiv id if available.
     - 逐篇论文结构化表字段：
       - Title
       - Year / Month
       - Venue
       - First Author
       - Affiliation
       - GPU Architecture
       - Scheduling Technique
       - Scheduling Level
       - Abstract
       - TLDR
     - 分析输出字段：
       - A taxonomy of scheduling techniques
       - A comparison between different compiler systems
       - Key research trends
       - Open problems
3. 验证 OpenAlex 可访问
   - 在主题目录执行：
   - `python3 ../.codex/deep-research/scripts/verify_openalex.py --guide GUIDE.md --per-page 5`
   - 或做定向关键词验证：
   - `python3 ../.codex/deep-research/scripts/verify_openalex.py --query "FlashAttention-3" --per-page 5`
4. 产出与沉淀
   - 将主输出写入 `report.md`。
   - 将后续追问写入同目录下新的 `*.md` 文件。

## 检索与整理原则

- 默认 OpenAlex-first：优先用 OpenAlex 做召回，再跳转到会议页/arXiv/出版页补齐细节。
- 若 OpenAlex 对某系统/论文存在索引滞后：先用网页检索定位 DOI/arXiv id，再回查 OpenAlex。
- 生成新 `GUIDE.md` 时，优先复用 `references/GUIDE.md` 的结构，确保上述固定要求完整出现。
- `report.md` 建议至少包含：
  - 论文结构化表：Title、Year/Month、Venue、First Author、Affiliation、GPU Architecture、Scheduling Technique、Scheduling Level、Abstract、TLDR。
  - 分析部分：taxonomy、系统对比、研究趋势、开放问题。

## 附带资源

- 脚本：`scripts/verify_openalex.py`
- 任务模板参考：`references/GUIDE.md`
