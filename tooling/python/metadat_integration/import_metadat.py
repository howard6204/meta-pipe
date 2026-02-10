#!/usr/bin/env python3
"""
Import datasets from R metadat package to meta-pipe format

Usage:
    uv run import_metadat.py --dataset dat.bcg --project validation-bcg
"""

import argparse
import subprocess
import json
import pandas as pd
from pathlib import Path
import sys


def import_metadat_to_project(
    dataset_name: str, project_name: str, root_dir: Path = None
):
    """
    從 metadat 提取資料並轉換為 meta-pipe 格式

    Args:
        dataset_name: metadat 中的 dataset 名稱 (e.g., "dat.bcg")
        project_name: 專案名稱 (e.g., "validation-bcg")
        root_dir: meta-pipe 根目錄
    """

    if root_dir is None:
        root_dir = Path(__file__).parent.parent.parent

    print(f"🔄 Importing {dataset_name} from R metadat package...")

    # 1. 用 R 提取 metadat
    r_script = f"""
    library(metadat)
    library(jsonlite)

    # Load dataset
    data({dataset_name})

    # Get metadata
    dataset_obj <- get("{dataset_name}")

    # Convert to JSON
    write_json(dataset_obj, 'temp_metadat.json', pretty = TRUE)

    # Print summary
    cat("Dataset:", "{dataset_name}\\n")
    cat("N studies:", nrow(dataset_obj), "\\n")
    cat("Columns:", paste(colnames(dataset_obj), collapse=", "), "\\n")
    """

    temp_r_script = Path("temp_import.R")
    temp_r_script.write_text(r_script)

    result = subprocess.run(
        ["Rscript", str(temp_r_script)], capture_output=True, text=True
    )

    if result.returncode != 0:
        print(f"❌ R script failed: {result.stderr}")
        temp_r_script.unlink(missing_ok=True)
        sys.exit(1)

    print(result.stdout)

    # 2. 讀取 JSON
    with open("temp_metadat.json") as f:
        data = json.load(f)

    df = pd.DataFrame(data)
    print(f"✅ Loaded {len(df)} studies from {dataset_name}")
    print(f"   Columns: {', '.join(df.columns)}")

    # 3. 映射到標準 extraction.csv 格式
    # 處理 BCG dataset 特定格式 (2x2 table: tpos, tneg, cpos, cneg)
    extraction_data = {
        "study_id": df["trial"].astype(str)
        if "trial" in df.columns
        else df.index.astype(str),
        "author": df["author"]
        if "author" in df.columns
        else df["trial"]
        if "trial" in df.columns
        else "",
        "year": df["year"] if "year" in df.columns else None,
    }

    # 計算樣本數和事件數
    if "tpos" in df.columns and "tneg" in df.columns:
        extraction_data["n_intervention"] = df["tpos"] + df["tneg"]
        extraction_data["events_intervention"] = df["tpos"]

    if "cpos" in df.columns and "cneg" in df.columns:
        extraction_data["n_control"] = df["cpos"] + df["cneg"]
        extraction_data["events_control"] = df["cpos"]

    # Subgroup variables
    if "ablat" in df.columns:
        extraction_data["latitude"] = df["ablat"]

    if "alloc" in df.columns:
        extraction_data["allocation"] = df["alloc"]

    extraction_df = pd.DataFrame(extraction_data)

    # 4. 建立專案目錄結構
    project_path = root_dir / "projects" / project_name
    project_path.mkdir(parents=True, exist_ok=True)

    # 建立 TOPIC.txt
    topic_content = f"""# Validation Test: {dataset_name}

**Source**: R metadat package
**Dataset**: {dataset_name}
**N studies**: {len(df)}
**Purpose**: Validate meta-pipe workflow with known benchmark data

This is a validation project using publicly available meta-analysis data
to test the accuracy and reliability of the meta-pipe automated workflow.
"""

    (project_path / "TOPIC.txt").write_text(topic_content)

    # 建立 01_protocol (簡化版)
    protocol_path = project_path / "01_protocol"
    protocol_path.mkdir(exist_ok=True)

    pico_content = f"""study_type: RCT
population: {dataset_name} population
intervention: BCG vaccine (if BCG dataset)
comparator: Control/Placebo
outcome: Primary outcome
"""

    (protocol_path / "pico.yaml").write_text(pico_content)

    # 5. 儲存 extraction.csv
    extraction_path = project_path / "05_extraction/round-01"
    extraction_path.mkdir(parents=True, exist_ok=True)

    extraction_df.to_csv(extraction_path / "extraction.csv", index=False)

    print(f"✅ Created project: {project_name}")
    print(f"   Location: {project_path}")
    print(f"   Extraction: {extraction_path / 'extraction.csv'}")
    print(f"   Preview:")
    print(extraction_df.head())

    # 6. 建立分析目錄
    analysis_path = project_path / "06_analysis"
    analysis_path.mkdir(exist_ok=True)

    # 清理暫存檔
    temp_r_script.unlink(missing_ok=True)
    Path("temp_metadat.json").unlink(missing_ok=True)

    return extraction_df, project_path


def main():
    parser = argparse.ArgumentParser(
        description="Import metadat dataset to meta-pipe project"
    )
    parser.add_argument(
        "--dataset", required=True, help="metadat dataset name (e.g., dat.bcg)"
    )
    parser.add_argument(
        "--project", required=True, help="Project name (e.g., validation-bcg)"
    )
    parser.add_argument(
        "--root", type=Path, default=None, help="meta-pipe root directory"
    )

    args = parser.parse_args()

    df, project_path = import_metadat_to_project(args.dataset, args.project, args.root)

    print(f"\n🎯 Next steps:")
    print(f"   cd {project_path}")
    print(f"   # Copy R analysis scripts")
    print(f"   # Run Stage 06 analysis")


if __name__ == "__main__":
    main()
