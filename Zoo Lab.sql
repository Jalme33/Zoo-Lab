USE zoo_lab;
--  Which species has the longest scientific_name?
-- scientific name is in the species table
-- HINT: use length() on a string column to get length of the string

SELECT length(scientific_name), common_name, scientific_name
FROM zoo_lab.species
ORDER BY scientific_name desc;

-- Rabbbit had the longest scientific name with 21 characters (Oryctolagus cuniculus).

-- Which animal has the longest individual_name? Shortest?
-- Each individual animal's given name is stored in the animals table.
-- HINT: there can be such a thing as too short of a name.
SELECT length(individual_name), id, individual_name
FROM zoo_lab.animals
ORDER BY length(individual_name) desc;

-- The animal with the longest individual name is Ms. Smallglesworth with 18 characters. The animal with the shortest (known) name is a tie between Dot and Liz both with 3 charcters.

-- Which animal is the most recent addition to the zoo? 
-- start_date is when the animal was added to the zoo.
SELECT start_date, individual_name
FROM zoo_lab.animals
ORDER BY start_date desc;

-- The animal that is the most recent addition to the zoo is Betty with a start date of 2015-08-08  and Dewey on the same day. 

-- What species is this most recent addition to the zoo?
SELECT species.scientific_name, species.id, animals.species_id, animals.start_date
FROM zoo_lab.species
LEFT JOIN zoo_lab.animals
ON species.id = animals.species_id
WHERE start_date='2015-08-08';


-- Part III: Zoo Lab, summaries of the zoo animals
-- How many are there of each species?
-- Your answer should report by the common_name of each species, but it may help to start with counting the number of animals per species_id.  (10pts)

SELECT count(species_id)
FROM zoo_lab.animals
GROUP BY species_id;

SELECT count(animals.id), species.common_name, species.id
FROM zoo_lab.animals
JOIN zoo_lab.species on animals.species_id = species.id
GROUP BY species.common_name, species.id;

-- There are 9 goldfish and the above code give the table. 


-- As of today, what's the average tenancy (length of stay) at the zoo?
-- HINTS:
-- DATEDIFF(date2, date1) returns number of days of date2 - date1
-- IFNULL(exp1, exp2) returns exp2 if exp1 is null
-- CURDATE() returns the current date of the running MySQL ses

SELECT avg(datediff(IFNULL(start_date, CURDATE()), start_date))
FROM zoo_lab.animals;

-- Using the animal stats table, tell me the average weight for each individual animal, across all of that animal's weigh-ins
-- The zoo director is not exactly sure what this would reveal, but wants you to go for it. She adds, "oh, and I'm not that great with the metric system. Can you report weight in pounds?"
-- Measured weights are in animal_stats table.
-- HINT:

-- ROUND(x, d) 
-- rounds the number x to the nearest d decimal points
-- floor(x)
-- rounds DOWN to the nearest integer
-- %
-- modulo, returns remainder


SELECT animal_stats.animal_id, animals.individual_name, species.common_name,
ROUND(avg(animal_stats.weight*0.0022), 2) as avg_weight
FROM zoo_lab.animal_stats
JOIN zoo_lab.animals
ON animal_stats.animal_id = animals.id
JOIN zoo_lab.species
ON animals.species_id = species.id
GROUP BY animal_stats.animal_id, animals.individual_name, species.common_name;

SELECT avg(weight), animal_id, individual_name
FROM zoo_lab.animal_stats
JOIN zoo_lab.animals
ON animal_stats.animal_id = animals.id
GROUP BY animal_id, individual_name;






OPTIONAL CHALLENGE:
report weights in pounds and ounces!

Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'distinct(animal_id) FROM zoo_lab.animal_stats GROUP BY distict(animal_id)' at line 1
Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'distinct animal_id FROM zoo_lab.animal_stats GROUP BY animal_id' at line 1
Error Code: 1055. Expression #3 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'zoo_lab.animals.individual_name' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by







The zoo director says to you, "you know what, maybe grams is better. Let's use metric from here on!" "Grams is fine, but I still want species identified by common names."
What's the average measured weight per species?
Define average weight per species as average of each animal's average (from last question)

(20pts)






CHECK IN WITH THE CLASS, WHAT DID YOU GET FOR EACH OF THESE QUESTIONS, WHAT WAS CHALLENGING/SURPRISING?
 
Part IV: Zoo Lab, zoo animals with seniority

Which animals have been here since December 01, 2014 or earlier?
HINT: "been here" implies still here

(15pts)















Of the animals who have been here since 11-23-2015, which grew the most, by percentage weight, between 12-01-2014 and 11-23-2015, a period where we implemented a new feeding schedule.
HINTS:
●	use the ids from the last query
●	assume no gaps in data
●	use hardcoded earliest and latest dates

(20pts)

SELECT animal_id, weight, max(cal_date), min(cal_date)
FROM animal_stats
WHERE cal_date between '2014-12-01' and '2015-11-23'
GROUP BY animal_id, weight;
SELECT table_1.animal_id, animals.individual_name, round(((table_2.second_weight - table_1.first_weight)/ table_1.first_weight)*100, 0) AS percent_difference
FROM
(SELECT weight as first_weight, animal_id
FROM animal_stats
WHERE cal_date = '2014-12-01'
GROUP BY animal_id, weight) AS table_1
JOIN 
(SELECT weight as second_weight, animal_id
FROM animal_stats
WHERE cal_date = '2015-11-23'
GROUP BY animal_id, weight) AS table_2
ON table_1.animal_id = table_2.animal_id
JOIN animals
ON table_1.animal_id = animals.id
ORDER BY animal_id;







CHECK IN WITH THE CLASS, WHAT DID YOU GET FOR EACH OF THESE QUESTIONS, WHAT WAS CHALLENGING/SURPRISING?
 
Part V: Zoo Lab, Barky vs. Dot

How do Barky and Dots weights compare in their first year at the zoo? 

The director wants to see their weights for their first year at the zoo,
even though they started at the zoo at different times.
HINTS:	
●	Ranking query!
●	Return the following columns – week number (1-52), Barky weight, Dot weight

Recall from Acrobatiq:
 

 
First just consider Barky, then do the final table.














CHECK IN WITH THE CLASS, WHAT DID YOU GET FOR THIS QUESTION, WHAT WAS CHALLENGING/SURPRISING?
 
Part VI: Zoo Lab, sneaky zoo animals

Did any animal not get weighed right away?
animals table lists a start_date
animal_stats gives cal_dates of weighings, always on Mondays
Did any animal not get weighed the first Monday after they were added to the zoo?
HINT: use MIN() to find earlier start_date per animal














That sneaky Bunnicula!
Ok, the zookeepers have found weighing records for Bunnicula’s first weeks at the zoo:

Construct a SQL INSERT query that inserts these missing rows to the animal stats table.

6/1/15 	2.4kg
6/8/15	2.38kg
6/15/15	2390
6/22/15	2401








CHECK IN WITH THE CLASS, WHAT DID YOU GET FOR EACH OF THESE QUESTIONS, WHAT WAS CHALLENGING/SURPRISING?

 
Part VII: Zoo Lab, challenge questions


OPTIONAL CHALLENGE: Of the animals no longer at zoo, did any have an unusual weight pattern?

Can we look at the animals that aren't at the zoo, who may have died, to see if they had unusual weight patterns?
Let's look at the last 8 weeks of weigh-ins.
Graphing might help visualize weight trends
HINTS:
●	remember that animals who've left the zoo have an end_date
●	yup, ranking query again












OPTIONAL CHALLENGE: Do any species have seasonal weight patterns?
The director wants to know if you can spot seasonal weight patterns in any species.
Graph the weights of individuals, grouped by species.
Conclude on which species do or don't have seasonality.

Part III: Zoo Lab, summaries of the zoo animals

--How many are there of each species?
--Your answer should report by the common_name of each species, but it may help to start with counting the number of animals per species_id.  (10pts)

SELECT common_name count(*)
FROM animals, species
WHERE animals.species_id=species_id
GROUP BY common_name;


-- As of today, what's the average tenancy (length of stay) at the zoo?
--HINTS:
--DATEDIFF(date2, date1) returns number of days of date2 - date1
--IFNULL(exp1, exp2) returns exp2 if exp1 is null
-() returns the current date of the running MySQL session

SELECT sepecies_id, DATEIFF(IFNULL(end_date,CURDATE()), start_date)
FROM animals







 
Using the animal stats table, tell me the average weight for each individual animal, across all of that animal's weigh-ins
The zoo director is not exactly sure what this would reveal, but wants you to go for it. She adds, "oh, and I'm not that great with the metric system. Can you report weight in pounds?"
Measured weights are in animal_stats table.
HINT:

ROUND(x, d) 
-- rounds the number x to the nearest d decimal points
floor(x)
-- rounds DOWN to the nearest integer
% 
-- modulo, returns remainder
(20pts)

OPTIONAL CHALLENGE:
report weights in pounds and ounces!








The zoo director says to you, "you know what, maybe grams is better. Let's use metric from here on!" "Grams is fine, but I still want species identified by common names."
What's the average measured weight per species?
Define average weight per species as average of each animal's average (from last question)

(20pts)






CHECK IN WITH THE CLASS, WHAT DID YOU GET FOR EACH OF THESE QUESTIONS, WHAT WAS CHALLENGING/SURPRISING?
 
Part IV: Zoo Lab, zoo animals with seniority

Which animals have been here since December 01, 2014 or earlier?
HINT: "been here" implies still here

(15pts)















Of the animals who have been here since 11-23-2015, which grew the most, by percentage weight, between 12-01-2014 and 11-23-2015, a period where we implemented a new feeding schedule.
HINTS:
●	use the ids from the last query
●	assume no gaps in data
●	use hardcoded earliest and latest dates

(20pts)









CHECK IN WITH THE CLASS, WHAT DID YOU GET FOR EACH OF THESE QUESTIONS, WHAT WAS CHALLENGING/SURPRISING?
 
Part V: Zoo Lab, Barky vs. Dot

How do Barky and Dots weights compare in their first year at the zoo? 

The director wants to see their weights for their first year at the zoo,
even though they started at the zoo at different times.
HINTS:	
●	Ranking query!
●	Return the following columns – week number (1-52), Barky weight, Dot weight

Recall from Acrobatiq:
 

 
First just consider Barky, then do the final table.














CHECK IN WITH THE CLASS, WHAT DID YOU GET FOR THIS QUESTION, WHAT WAS CHALLENGING/SURPRISING?
 
Part VI: Zoo Lab, sneaky zoo animals

Did any animal not get weighed right away?
animals table lists a start_date
animal_stats gives cal_dates of weighings, always on Mondays
Did any animal not get weighed the first Monday after they were added to the zoo?
HINT: use MIN() to find earlier start_date per animal














That sneaky Bunnicula!
Ok, the zookeepers have found weighing records for Bunnicula’s first weeks at the zoo:

Construct a SQL INSERT query that inserts these missing rows to the animal stats table.

6/1/15 	2.4kg
6/8/15	2.38kg
6/15/15	2390
6/22/15	2401








CHECK IN WITH THE CLASS, WHAT DID YOU GET FOR EACH OF THESE QUESTIONS, WHAT WAS CHALLENGING/SURPRISING?

 
Part VII: Zoo Lab, challenge questions


OPTIONAL CHALLENGE: Of the animals no longer at zoo, did any have an unusual weight pattern?

Can we look at the animals that aren't at the zoo, who may have died, to see if they had unusual weight patterns?
Let's look at the last 8 weeks of weigh-ins.
Graphing might help visualize weight trends
HINTS:
●	remember that animals who've left the zoo have an end_date
●	yup, ranking query again












OPTIONAL CHALLENGE: Do any species have seasonal weight patterns?
The director wants to know if you can spot seasonal weight patterns in any species.
Graph the weights of individuals, grouped by species.
Conclude on which species do or don't have seasonality.

