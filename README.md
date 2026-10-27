# Forecasting Major League Rugby Fantasy Points

Can you predict how many fantasy points a Major League Rugby starter will score before kickoff? This project models three seasons of player-match data (2023 to 2025) and compares the result against the simple rules a fantasy player would use.

![Pre-game forecasts vs. naive rules](figures/06_pregame_vs_naive.png)

## The short answer

- **Pre-game forecasts are hard.** Before kickoff, the best model misses by about **3 fantasy points per forward** and **3.9 per back** (test MAE). That is only **3 to 4% better** than the best simple rule, a player's average so far this season.
- **Simple beats complex here.** Ridge regression matches or beats a tuned XGBoost model on the same pre-game features. The signal is weak and mostly linear, so the extra complexity buys nothing.
- **Box scores explain points almost perfectly.** With the player's actual match stats, XGBoost reconstructs fantasy points with R² ≈ 0.97. Fantasy points are calculated from those stats, so that model is an upper bound, not a forecast.

## Key numbers

| | Forwards | Backs |
|---|---|---|
| Pre-game ridge, test MAE | **2.97** | **3.88** |
| Pre-game XGBoost (tuned), test MAE | 3.04 | 3.98 |
| Naive: season-to-date average, test MAE | 3.08 | 3.99 |
| Naive: position average, test MAE | 3.21 | 4.18 |
| Pre-game XGBoost, test R² | 0.18 | 0.05 |
| In-game XGBoost (upper bound), test R² | 0.97 | 0.97 |

Test set: 2025 Rounds 11 to 16, 1,020 starter performances, evaluated once.

![Pre-game vs. in-game error](figures/07_pregame_vs_ingame_rmse.png)

## Approach

1. **Data.** 13,000 player-match rows across 15 teams. Positions come from jersey number (1-3 front row, 4-5 second row, and so on), as in `sql/build_dataset.sql`.
2. **Data quality**, resolved before modeling:
   - 16 player-match keys appeared twice with different stats. In most pairs one row is a stale 0.0-point record and the other is the full stat line, so the notebook keeps the most complete record rather than the first one.
   - In the 2024 Round 18 playoff (SEA v SDL), 19 of 23 San Diego stat lines are exact copies of Seattle's. The notebook detects copied matches in code and drops this one.
   - Jersey 24 rows are team bonus-point entries, not players, and are excluded.
3. **Exploratory analysis.**
   - Backs outscore front-row and second-row forwards by a wide margin, so forwards and backs are modeled separately.
   - Meters (r = 0.73) and tries (r = 0.62) drive scoring.
   - A player's season average correlates with the next season's at r = 0.59.
4. **Leak-free features.**
   - Every history feature uses only earlier matches: `shift(1)` for rolling form and volatility, last season's average, and what the opponent allowed last season.
   - Fallback values and player-ID encodings are fit on the training seasons only.
5. **Temporal split.** Train on 2023 to 2024, tune on 2025 Rounds 1 to 10, test once on 2025 Rounds 11 to 16.
6. **Models.**
   - In-game: linear, ridge, ElasticNet, random forest, and XGBoost with a 432-combination grid search.
   - Pre-game: XGBoost and ridge, compared against three naive rules.

## What changed from the original capstone

The original submission reported near-perfect accuracy. A review before publishing found that the result came from in-game statistics, plus two leaks:

- Player volatility was computed over the whole season, including the match being predicted.
- Fallback values were fit on all seasons, so validation and test data shaped the features.

This version:

- Fixes both leaks.
- Treats the pre-game forecast as the real problem and judges it against naive baselines.
- Resolves the duplicate rows and the copied match.
- Removes an unsupported claim that Seattle was consistently below average. In the data, Seattle starters were at or above the league average each season.

Every number in the notebook's summaries is computed from the results rather than typed in.

## Limitations

- **Small test set.** Six rounds of one season, so differences of a few hundredths of a point between models are not meaningful.
- **Starters only.** Bench players play fewer and less predictable minutes, so they are out of scope.
- **Missing pre-game context.** The data has no information on injuries, weather, or betting lines, all of which would likely help a pre-game forecast more than further tuning.
- **One fantasy scoring system.** Results apply to MLR's fantasy scoring as recorded in this data.

## Repository structure

```
├── data/README.md                       Data schema (the dataset itself is not included)
├── sql/build_dataset.sql                How the CSV was assembled (SQL Server)
├── notebooks/mlr_fantasy_points.ipynb   Full analysis with outputs
├── figures/                             Charts exported from the notebook
└── requirements.txt
```

## How to run

The dataset is proprietary and not included (see `data/README.md`). The executed notebook shows every result. With access to the data, place the CSV in `data/` and run:

```bash
pip install -r requirements.txt
jupyter notebook notebooks/mlr_fantasy_points.ipynb
```

The full notebook, including both 432-combination grid searches, takes about 5 minutes to run.

## Data and credit

Team capstone for MSDS 498 at Northwestern University, completed with **Nicholas Parry**. Nicholas collected the player-match statistics from Major League Rugby's fantasy stats API and built the SQL Server pipeline that assembles them. The data is proprietary and is not published here; `sql/build_dataset.sql` is a condensed version of the pipeline that shows its structure.

---
Jake Zott · MS Data Science, Northwestern University
