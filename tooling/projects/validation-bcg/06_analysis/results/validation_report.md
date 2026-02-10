# BCG Vaccine Meta-Analysis Validation Report

## Dataset
- Source: R metadat::dat.bcg
- N studies: 13
- Total participants (intervention): 191064
- Total participants (control): 166283

## Primary Analysis
- **Effect size**: RR = 0.490
- **95% CI**: 0.345-0.695
- **p-value**: 0.0001
- **I²**: 92.1% (heterogeneity)
- **τ²**: 0.309

## Expected Results (from literature)
- Expected RR: ~0.51 (95% CI: 0.34-0.71)
- **Match**: ✅ PASS

## Publication Bias
- Egger's test p-value: 0.1887
- **Interpretation**: No significant asymmetry

## Subgroup Analysis
- Latitude ≥30° vs <30° (moderator effect)

## Sensitivity Analysis
- Leave-one-out analysis shows RR range: 0.454-0.539

## Conclusion
✅ Meta-pipe workflow successfully replicated published BCG meta-analysis results.

