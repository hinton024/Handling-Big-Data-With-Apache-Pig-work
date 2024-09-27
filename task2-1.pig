-- Task 2-1: Gold and Silver Medal Counts by Region

-- Load the necessary datasets
noc_region = LOAD '/input/noc_region.csv' USING PigStorage(',') AS (id:int, noc:chararray, region_name:chararray);
person_region = LOAD '/input/person_region.csv' USING PigStorage(',') AS (person_id:int, region_id:int);
person = LOAD '/input/person.csv' USING PigStorage(',') AS (id:int, full_name:chararray, gender:chararray, height:int, weight:int);
competitor_event = LOAD '/input/competitor_event.csv' USING PigStorage(',') AS (event_id:int, competitor_id:int, medal_id:int);
medal = LOAD '/input/medal.csv' USING PigStorage(',') AS (id:int, medal_name:chararray);

-- Perform joins to link the datasets
join1 = JOIN noc_region BY id, person_region BY region_id;
join2 = JOIN join1 BY person_region::person_id, person BY id;
join3 = JOIN join2 BY person::id, competitor_event BY competitor_id;
join4 = JOIN join3 BY competitor_event::medal_id, medal BY id;

-- Filter for gold and silver medals
gold_medals = FILTER join4 BY medal_name == 'Gold';
silver_medals = FILTER join4 BY medal_name == 'Silver';

-- Group by region and count the number of gold and silver medals
gold_grouped = GROUP gold_medals BY noc_region::region_name;
gold_count = FOREACH gold_grouped GENERATE group AS Region, COUNT(gold_medals) AS Gold;

silver_grouped = GROUP silver_medals BY noc_region::region_name;
silver_count = FOREACH silver_grouped GENERATE group AS Region, COUNT(silver_medals) AS Silver;

-- Join the gold and silver counts
combined_medals = JOIN gold_count BY Region FULL OUTER, silver_count BY Region;

-- Use COALESCE to handle null values and filter out regions with zero gold and silver medals
filtered_medals = FOREACH combined_medals GENERATE 
    (gold_count::Region IS NOT NULL ? gold_count::Region : silver_count::Region) AS Region,
    (gold_count::Gold IS NOT NULL ? gold_count::Gold : 0) AS Gold,
    (silver_count::Silver IS NOT NULL ? silver_count::Silver : 0) AS Silver;

non_zero_medals = FILTER filtered_medals BY (Gold > 0 OR Silver > 0);

-- Order by gold (descending), silver (descending), and region (ascending)
ordered_medals = ORDER non_zero_medals BY Gold DESC, Silver DESC, Region ASC;

-- Store the output
STORE ordered_medals INTO '/output/task2-1' USING PigStorage(',');