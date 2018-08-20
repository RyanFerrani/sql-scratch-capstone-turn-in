/* First step - Select all columns from the first 10 rows. */

select *
 from survey
 limit 10;

/* Second step - Create a quiz funnel using the group by command */

select question,
 count(distinct user_id)
 from survey
 group by 1;

/* Fourth step - Examine the first five rows of each table*/

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

/* Fifth step - Use a left join to combine the three tables; select only the first 10 rows*/

SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
LIMIT 10;

/*Step six - Most common results of the style quiz. */

SELECT style, COUNT(*)
FROM quiz
GROUP BY style;

/*Step six - Most common types of purchase made. */

SELECT style, COUNT(*)
FROM purchase
GROUP BY style;

/*Step six - Compare conversion. */

with funnels as (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
select count (*)
as '# of Users Browsed',
sum (is_home_try_on) as '# Tried On',
sum (is_purchase) as 'Total Purchases',
1.0 * SUM(is_home_try_on) / COUNT(*) AS 'Browse to Home Try on',
   1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'Home Try on to Purchase'
from funnels;

/*Step six - Calculate the difference in purchase rates between customers who had 3 pairs to try on vs 5 pairs to try on. */

with funnels as (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
select number_of_pairs,
count (*)
as '# of Users Browsed',
sum (is_home_try_on) as '# Tried On',
sum (is_purchase) as 'Total Purchases',
1.0 * SUM(is_home_try_on) / COUNT(user_id) AS 'Browse to Home Try on',
   1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'Home Try on to Purchase'
from funnels
group by number_of_pairs;








