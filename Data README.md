# Data (not included)

The dataset is proprietary and is not published in this repository.

The notebook expects `MLRStats_2023-2024-2025.csv` in this folder: one row per player per match, 2023 to 2025 Major League Rugby seasons (13,000 rows). Schema and position mapping are in `../sql/build_dataset.sql`. Columns:

`year, Rnd, Match_ID, Home_away, Team, Number, Player, Player_ID, Fantasy_Points, Started, Minutes, Tries, Meters, Assists, Tackles, Steals, Turnovers, Conversions, Penalty_goals, minutes_70, minutes_80, Yellow_card, Red_card, SetPieceTryAssists, OffensiveBP, DefensiveBP, Pos`

The executed notebook in `../notebooks/` shows all results and prints aggregates only, never individual rows.
