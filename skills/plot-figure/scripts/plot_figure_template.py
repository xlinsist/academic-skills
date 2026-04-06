#!/usr/bin/env python3
"""Template: grouped bar chart for baseline comparison.

Fill in USER INPUT SECTION only.
"""

import numpy as np
import matplotlib.pyplot as plt

# =========================
# USER INPUT SECTION
# =========================
TITLE = "Matmul Benchmark"
X_LABEL = "Shape"
Y_LABEL = "Execution Time (s)"
OUTPUT = "benchmark.png"

# Baseline method name must exist in METHODS.
BASELINE = "triton-cpu"

# X-axis categories.
X_TICKS = ["512", "640", "768", "896", "1024"]

# Each method must have one value per X tick.
METHODS = {
    "triton-cpu": [0.646322, 1.231949, 2.103534, 3.333842, 4.919240],
    "triton-riscv": [0.704590, 0.677159, 1.188434, 1.885032, 2.851805],
}

# =========================
# TEMPLATE STYLE (DO NOT CHANGE)
# =========================
BASELINE_COLOR = "#182345"
PRIMARY_COMPARE_COLOR = "#FFC000"
EXTRA_COLORS = ["#4D74B8", "#8AB6F9", "#F28E2B", "#76B7B2", "#59A14F", "#E15759"]

plt.rcParams.update(
    {
        "font.size": 14,
        "axes.titlesize": 18,
        "axes.labelsize": 16,
        "legend.fontsize": 14,
        "xtick.labelsize": 14,
        "ytick.labelsize": 14,
    }
)


def validate_inputs(x_ticks, methods, baseline):
    if baseline not in methods:
        raise ValueError(f"BASELINE '{baseline}' is not in METHODS keys: {list(methods.keys())}")

    n = len(x_ticks)
    if n == 0:
        raise ValueError("X_TICKS cannot be empty")

    for name, values in methods.items():
        if len(values) != n:
            raise ValueError(
                f"Method '{name}' has {len(values)} values, expected {n} to match X_TICKS"
            )


def build_colors(method_names, baseline):
    colors = {}
    colors[baseline] = BASELINE_COLOR

    compare_names = [m for m in method_names if m != baseline]
    palette = [PRIMARY_COMPARE_COLOR] + EXTRA_COLORS

    for idx, name in enumerate(compare_names):
        colors[name] = palette[idx % len(palette)]

    return colors


def plot_grouped_bars(title, x_label, y_label, output, x_ticks, methods, baseline):
    validate_inputs(x_ticks, methods, baseline)

    method_names = [baseline] + [m for m in methods.keys() if m != baseline]
    colors = build_colors(method_names, baseline)

    x = np.arange(len(x_ticks))
    n_methods = len(method_names)
    width = 0.8 / n_methods

    plt.figure(figsize=(9, 6))

    for i, name in enumerate(method_names):
        offset = (i - (n_methods - 1) / 2) * width
        bars = plt.bar(x + offset, methods[name], width, label=name, color=colors[name])
        plt.bar_label(bars, fmt="%.2f", padding=3, fontsize=10)

    plt.xticks(x, x_ticks)
    plt.xlabel(x_label)
    plt.ylabel(y_label)
    plt.title(title)
    plt.legend()
    plt.grid(axis="y", linestyle="--", alpha=0.3)
    plt.tight_layout()
    plt.savefig(output, dpi=200)
    plt.show()


if __name__ == "__main__":
    plot_grouped_bars(
        title=TITLE,
        x_label=X_LABEL,
        y_label=Y_LABEL,
        output=OUTPUT,
        x_ticks=X_TICKS,
        methods=METHODS,
        baseline=BASELINE,
    )
