You are helping with a research literature survey.

Topic:
Time scheduling techniques in deep learning compilers targeting modern NVIDIA GPUs (Hopper / Blackwell).

Focus on:
- warp specialization
- asynchronous pipelines
- software pipelining
- load-compute overlap
- tensor core scheduling
- kernel-level scheduling strategies

Relevant systems include:
Triton, TileLang, Linear Layout, Gluon, CUTLASS, FlashAttention.

Tasks:

0. (Recommended) Verify OpenAlex access (for reproducible literature search)
   - Quick connectivity check using the local script in this repo:
     - `python3 ../verify_openalex.py --guide GUIDE.md --per-page 5`
     - or a targeted query: `python3 ../verify_openalex.py --query "FlashAttention-3" --per-page 5`
   - Notes:
     - The script derives keywords from the "Focus on" bullets below and searches OpenAlex Works API with a 2022–2026 date filter.
     - This script uses Python stdlib `urllib` (no extra packages required).

1. Search for relevant papers from 2022–2026.
2. Prioritize PLDI, ASPLOS, OSDI, MLSys, ISCA, MICRO, SC, and arXiv.
3. Identify papers discussing scheduling abstractions or kernel pipeline techniques.

OpenAlex-first search policy (mandatory):

- Use OpenAlex as the primary index for recall (papers + metadata), then follow through to the best landing page (venue / arXiv / publisher) for details.
- When OpenAlex misses a system/paper name (indexing lag happens), fall back to direct web search and then re-query OpenAlex by DOI/arXiv id if available.

For each paper produce a structured table containing (mandatory):

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

Then provide (mandatory):

- A taxonomy of scheduling techniques
- A comparison between different compiler systems
- Key research trends
- Open problems
