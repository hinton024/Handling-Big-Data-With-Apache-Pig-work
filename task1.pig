-- Task 1: Count Gold Medals by Region

-- Load the necessary datasets from HDFS
noc_region = LOAD 'hdfs:///input/noc_region.csv' USING PigStorage(',') AS (id:int, noc:chararray, region_name:chararray);
person_region = LOAD 'hdfs:///input/person_region.csv' USING PigStorage(',') AS (person_id:int, region_id:int);
person = LOAD 'hdfs:///input/person.csv' USING PigStorage(',') AS (id:int, full_name:chararray, gender:chararray, height:int, weight:int);
competitor_event = LOAD 'hdfs:///input/competitor_event.csv' USING PigStorage(',') AS (event_id:int, competitor_id:int, medal_id:int);
medal = LOAD 'hdfs:///input/medal.csv' USING PigStorage(',') AS (id:int, medal_name:chararray);
-- Perform joins to link the datasets
join1 = JOIN noc_region BY id, person_region BY region_id;
join2 = JOIN join1 BY person_region::person_id, person BY id;
join3 = JOIN join2 BY person::id, competitor_event BY competitor_id;
join4 = JOIN join3 BY competitor_event::medal_id, medal BY id;

-- Filter for only gold medals
gold_medals = FILTER join4 BY medal_name == 'Gold';

-- Group by region and count the number of gold medals
grouped_gold = GROUP gold_medals BY noc_region::region_name;
gold_count = FOREACH grouped_gold GENERATE group AS Region, COUNT(gold_medals) AS Gold;

-- Order by the count of gold medals in descending order and region in ascending order
ordered_gold = ORDER gold_count BY Gold DESC, Region ASC;

-- Store the output
STORE ordered_gold INTO '/output/task1' USING PigStorage(',');

DUMP ordered_gold;