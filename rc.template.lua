---
--- All measures of time are in seconds.
--- All probabilities should be in the range [0, 1].
---

-- Probability of a Krampus Sack drop on day 1.
--@example KRAMPUS_SACK_BASE_CHANCE = 0.75
KRAMPUS_SACK_BASE_CHANCE = 0.5

-- How long it takes for the drop chance to be cut in half.
KRAMPUS_SACK_CHANCE_HALF_LIFE = 7*TUNING.TOTAL_DAY_TIME
--@stopreading


-- Turn on debugging.
DEBUG = false
