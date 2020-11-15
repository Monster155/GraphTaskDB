-- creating table (Special Task 2)
CREATE TABLE st2
(
    num    int,
    par_id int,
    weight int
);
-- Set ID for every Point
-- 1 = S
-- 2 = U
-- 3 = X
-- 4 = V
-- 5 = Y

-- We start from S point
INSERT INTO st2 (num, par_id, weight)
VALUES (null, 1, 0);
-- All ways in graph
INSERT INTO st2 (num, par_id, weight)
VALUES (1, 2, 3);
INSERT INTO st2 (num, par_id, weight)
VALUES (1, 3, 5);
INSERT INTO st2 (num, par_id, weight)
VALUES (2, 3, 2);
INSERT INTO st2 (num, par_id, weight)
VALUES (2, 4, 6);
INSERT INTO st2 (num, par_id, weight)
VALUES (3, 2, 1);
INSERT INTO st2 (num, par_id, weight)
VALUES (3, 4, 4);
INSERT INTO st2 (num, par_id, weight)
VALUES (3, 5, 6);
INSERT INTO st2 (num, par_id, weight)
VALUES (4, 5, 2);
INSERT INTO st2 (num, par_id, weight)
VALUES (5, 1, 3);
INSERT INTO st2 (num, par_id, weight)
VALUES (5, 4, 7);
-- SQL Request to find all ways from S to Y
-- We start from 1 point and ends when find 5-th point
WITH RECURSIVE _st2 AS
                   (SELECT par_id,
                           array [par_id] AS path,
                           FALSE          AS cycle,
                           -- column for "Was 5 on way?"
                           -- path can be {1,3,5,4,5} or other but it's incorrect, we should finish ob 5-th point
                           FALSE          AS was5,
                           -- weight for this way
                           weight
                    FROM st2
                    WHERE num IS NULL
                    UNION ALL
                    SELECT st2.par_id,
                           _st2.path || st2.par_id      AS path,
                           st2.par_id = ANY (_st2.path) AS cycle,
                           -- if path contains 5 sets 'true'
                           _st2.path @> ARRAY [5]       AS was5,
                           -- way weight on last point + weight to reach new point
                           (_st2.weight + st2.weight)::int
                    FROM st2
                             INNER JOIN _st2 ON (_st2.par_id = st2.num) AND NOT cycle AND NOT was5)
SELECT path, weight
FROM _st2
-- disable all ways which not end with 5-th point
WHERE _st2.par_id = 5;

-- copy of last code instead of 2 last rows
WITH RECURSIVE _st2 AS
                   (SELECT par_id,
                           array [par_id] AS path,
                           FALSE          AS cycle,
                           FALSE          AS was5,
                           weight
                    FROM st2
                    WHERE num IS NULL
                    UNION ALL
                    SELECT st2.par_id,
                           _st2.path || st2.par_id      AS path,
                           st2.par_id = ANY (_st2.path) AS cycle,
                           _st2.path @> ARRAY [5]       AS was5,
                           (_st2.weight + st2.weight)::int
                    FROM st2
                             INNER JOIN _st2 ON (_st2.par_id = st2.num) AND NOT cycle AND NOT was5)
SELECT path, weight
FROM _st2
WHERE _st2.par_id = 5
-- order results by weight and get first of them - the cheapest way
ORDER BY weight
LIMIT 1;
