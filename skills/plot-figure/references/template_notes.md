# Plot Figure Template Notes

This template enforces these style constraints:

- Chart type: grouped bar chart.
- X axis: categorical labels from `X_TICKS`.
- Y axis: metric values (`Y_LABEL` default is `Execution Time (s)`).
- Legend: always shown, baseline first.
- Colors:
  - baseline: `#182345`
  - single comparison method: `#FFC000`
  - more than two comparison methods: follow `Set2`-style expansion in script, aligned with `plot_figure_multi_method_reference.py`.
- Bar-value labels: enabled via `plt.bar_label(..., fmt="%.2f", padding=3, fontsize=10)`.
- Layout:
  - base mode (`baseline + 1 method`): `figsize=(9, 6)`
  - multi-method mode (`comparison > 2`): `figsize=(24, 10)` with larger axis/legend/tick/data-label fonts.
  - y-grid `linestyle="--", alpha=0.3`
  - larger font rcParams (auto-selected by method count in template script).

Only modify `USER INPUT SECTION` in the script for new tasks.
