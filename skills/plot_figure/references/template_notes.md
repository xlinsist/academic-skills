# Plot Figure Template Notes

This template enforces these style constraints:

- Chart type: grouped bar chart.
- X axis: categorical labels from `X_TICKS`.
- Y axis: metric values (`Y_LABEL` default is `Execution Time (s)`).
- Legend: always shown, baseline first.
- Colors:
  - baseline: `#182345`
  - first comparison method: `#FFC000`
  - extra methods: fallback palette in script.
- Bar-value labels: enabled via `plt.bar_label(..., fmt="%.2f", padding=3, fontsize=10)`.
- Layout:
  - `figsize=(9, 6)`
  - y-grid `linestyle="--", alpha=0.3`
  - larger font rcParams.

Only modify `USER INPUT SECTION` in the script for new tasks.
