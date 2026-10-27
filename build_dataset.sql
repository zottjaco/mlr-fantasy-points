-- Build MLRStats_2023-2024-2025.csv (SQL Server)
--
-- Pipeline written by Nicholas Parry. Condensed here for the repository:
-- one table per season, loaded from the MLR fantasy stats API (one row per
-- player per match), then stacked with a season column and a position derived
-- from jersey number. Bulk INSERT statements are omitted; the result is
-- data/MLRStats_2023-2024-2025.csv.
--
-- Note: UNION (not UNION ALL) removes rows that are identical in every column.
-- Rows that share a player and match but differ in their stats survive and are
-- resolved in the notebook (Section 1).

DROP TABLE IF EXISTS MLR2023API;
CREATE TABLE MLR2023API (
    Rnd                 INT,
    Match_ID            INT,
    Home_away           VARCHAR(4),
    Team                VARCHAR(10),
    Number              INT,
    Player              VARCHAR(30),
    Player_ID           INT,
    Fantasy_Points      DECIMAL(4,1),
    Started             INT,
    Minutes             INT,
    Tries               INT,
    Meters              INT,
    Assists             INT,
    Tackles             INT,
    Steals              INT,
    Turnovers           INT,
    Conversions         INT,
    Penalty_goals       INT,
    minutes_70          INT,
    minutes_80          INT,
    Yellow_card         INT,
    Red_card            INT,
    SetPieceTryAssists  INT,
    OffensiveBP         INT,
    DefensiveBP         INT
);

DROP TABLE IF EXISTS MLR2024API;
CREATE TABLE MLR2024API (
    Rnd                 INT,
    Match_ID            INT,
    Home_away           VARCHAR(4),
    Team                VARCHAR(10),
    Number              INT,
    Player              VARCHAR(30),
    Player_ID           INT,
    Fantasy_Points      DECIMAL(4,1),
    Started             INT,
    Minutes             INT,
    Tries               INT,
    Meters              INT,
    Assists             INT,
    Tackles             INT,
    Steals              INT,
    Turnovers           INT,
    Conversions         INT,
    Penalty_goals       INT,
    minutes_70          INT,
    minutes_80          INT,
    Yellow_card         INT,
    Red_card            INT,
    SetPieceTryAssists  INT,
    OffensiveBP         INT,
    DefensiveBP         INT
);

DROP TABLE IF EXISTS MLR2025API;
CREATE TABLE MLR2025API (
    Rnd                 INT,
    Match_ID            INT,
    Home_away           VARCHAR(4),
    Team                VARCHAR(10),
    Number              INT,
    Player              VARCHAR(30),
    Player_ID           INT,
    Fantasy_Points      DECIMAL(4,1),
    Started             INT,
    Minutes             INT,
    Tries               INT,
    Meters              INT,
    Assists             INT,
    Tackles             INT,
    Steals              INT,
    Turnovers           INT,
    Conversions         INT,
    Penalty_goals       INT,
    minutes_70          INT,
    minutes_80          INT,
    Yellow_card         INT,
    Red_card            INT,
    SetPieceTryAssists  INT,
    OffensiveBP         INT,
    DefensiveBP         INT
);

-- Stack the seasons and export
SELECT 2023 AS year
    , *
    , CASE WHEN Number IN (1, 2, 3)    THEN 'FR'
           WHEN Number IN (4, 5)       THEN 'SR'
           WHEN Number IN (6, 7, 8)    THEN 'BR'
           WHEN Number = 9             THEN 'SH'
           WHEN Number = 10            THEN 'FH'
           WHEN Number IN (12, 13)     THEN 'C'
           WHEN Number IN (11, 14, 15) THEN 'B3'
           WHEN Number = 24            THEN 'DSP'   -- team bonus-point row
           WHEN Number BETWEEN 16 AND 23 THEN 'Bench'
      END AS Pos
FROM MLR2023API

UNION

SELECT 2024 AS year
    , *
    , CASE WHEN Number IN (1, 2, 3)    THEN 'FR'
           WHEN Number IN (4, 5)       THEN 'SR'
           WHEN Number IN (6, 7, 8)    THEN 'BR'
           WHEN Number = 9             THEN 'SH'
           WHEN Number = 10            THEN 'FH'
           WHEN Number IN (12, 13)     THEN 'C'
           WHEN Number IN (11, 14, 15) THEN 'B3'
           WHEN Number = 24            THEN 'DSP'   -- team bonus-point row
           WHEN Number BETWEEN 16 AND 23 THEN 'Bench'
      END AS Pos
FROM MLR2024API

UNION

SELECT 2025 AS year
    , *
    , CASE WHEN Number IN (1, 2, 3)    THEN 'FR'
           WHEN Number IN (4, 5)       THEN 'SR'
           WHEN Number IN (6, 7, 8)    THEN 'BR'
           WHEN Number = 9             THEN 'SH'
           WHEN Number = 10            THEN 'FH'
           WHEN Number IN (12, 13)     THEN 'C'
           WHEN Number IN (11, 14, 15) THEN 'B3'
           WHEN Number = 24            THEN 'DSP'   -- team bonus-point row
           WHEN Number BETWEEN 16 AND 23 THEN 'Bench'
      END AS Pos
FROM MLR2025API
ORDER BY year, Rnd;
