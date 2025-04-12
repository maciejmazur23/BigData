DROP TABLE IF EXISTS temp_top_actors_directors_optim;
DROP VIEW IF EXISTS actor_counts;
DROP VIEW IF EXISTS director_counts;

CREATE EXTERNAL TABLE IF NOT EXISTS mapreduce_results (
    nconst STRING,
    acted_in INT,
    directed INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '${hivevar:MAPREDUCE_OUTPUT_PATH}';

CREATE EXTERNAL TABLE IF NOT EXISTS persons (
    nconst STRING,
    primaryName STRING,
    birthYear INT,
    deathYear INT,
    primaryProfession STRING,
    knownForTitles STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '${hivevar:DATASOURCE4_PATH}';

WITH JoinedData AS (
    SELECT
        p.primaryName,
        p.primaryProfession,
        m.acted_in,
        m.directed
    FROM mapreduce_results m
    JOIN persons p ON m.nconst = p.nconst
),
RankedActors AS (
    SELECT
        primaryName AS name,
        'actor' AS role,
        acted_in AS movies
    FROM JoinedData
    WHERE primaryProfession RLIKE '(^|,)actor(,|$)|\bactress\b'
    ORDER BY movies DESC
    LIMIT 3
),
RankedDirectors AS (
    SELECT
        primaryName AS name,
        'director' AS role,
        directed AS movies
    FROM JoinedData
    WHERE primaryProfession RLIKE '(^|,)director(,|$)'
    ORDER BY movies DESC
    LIMIT 3
)
INSERT OVERWRITE LOCAL DIRECTORY '${hivevar:RESULT_PATH}'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\n'
SELECT
    concat('{',
        '"primaryName":"', name, '",',
        '"role":"', role, '",',
        '"movies":', movies,
    '}') AS json_result
FROM (
    SELECT * FROM RankedActors
    UNION ALL
    SELECT * FROM RankedDirectors
) final_results;