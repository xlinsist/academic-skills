import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import io
import numpy as np

def plot_matmul_block_param_bar_chart(csv_content, platform="K1"):
    # 读取数据
    df = pd.read_csv(io.StringIO(csv_content))
    
    # 1. 只关注 matmul benchmark
    df = df[df['benchmark'] == 'matmul'].copy()

    # 2. 找到最大的 shape 并只保留该 shape 的数据
    df['shape_tuple'] = df['shape'].apply(lambda x: tuple(int(s) for s in x.strip('()').replace(' ', '').split(',') if s))
    df = df[df['shape_tuple'] == df['shape_tuple'].max()]
    

    
    # 创建显示用的 vec_param，值除以4
    df['vec_param_display'] = (df['vec_param'].astype(int) // 4).astype(str)

    # --- 4. 开始绘图 (样式和 reference file 保持一致) ---
    sns.set_theme(style="whitegrid")

    plt.figure(figsize=(24, 10))

    ax = sns.barplot(
        data=df,
        x="block_param",
        y="time(ms)",
        hue="vec_param_display", 
        palette="Set2",
        errorbar=None
    )
    
    # 设置Y轴范围
    max_time = df['time(ms)'].max()
    y_max_limit = max_time * 1.15
    print(y_max_limit)
    plt.ylim(0, y_max_limit)
    
    # 添加数据标签
    for p in ax.patches:
        height = p.get_height()
        if np.isnan(height) or height <= 0:
            continue
            
        ax.text(p.get_x() + p.get_width()/2., height + 0.02, 
                f'{height:.0f}', 
                ha='center', va='bottom', fontsize=18, color='black')
    
    # 标签设置
    ax.set_xlabel("Block Parameters", fontsize=32, labelpad=20)
    ax.set_ylabel("Time (ms)", fontsize=32, labelpad=20)
    
    plt.xticks(rotation=0, ha="center", fontsize=26)
    plt.yticks(fontsize=22)
    
    # 图例设置
    plt.legend(
        title='LMUL', 
        title_fontsize='32', 
        fontsize='28',
        bbox_to_anchor=(0.99, 0.99),
        loc='upper right',
        borderaxespad=0.
    )    
    plt.tight_layout()
    
    output_file = f"./bar_chart_lmul_params_{platform}.png"
    plt.savefig(output_file, dpi=300, bbox_inches="tight")
    print(f"Chart generated (would be saved as {output_file})")


# 运行函数
csv_data = pd.read_csv("./performance_report_matmul_no_mask_K1.csv").to_csv(index=False)
plot_matmul_block_param_bar_chart(csv_data,"K1")
csv_data = pd.read_csv("./performance_report_matmul_no_mask_K230.csv").to_csv(index=False)
plot_matmul_block_param_bar_chart(csv_data,"K230")
