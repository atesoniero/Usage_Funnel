/* TASK 1 */
SELECT *
FROM survey
LIMIT 10;

/* TASK 2 */
SELECT question, COUNT(question)
FROM survey
GROUP BY question
ORDER BY question;

-- /* TASK 3 */
SELECT question, COUNT(question)
FROM survey
GROUP BY question
ORDER BY question;

/* TASK 4 */
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

/* TASK 5 */
SELECT quiz.user_id, 
  home_try_on.user_id IS NOT NULL AS 'is_home_try_on',
  home_try_on.number_of_pairs AS "number_of_pairs",
  purchase.user_id IS NOT NULL AS "is_purchase"
FROM quiz
LEFT JOIN home_try_on
  ON quiz.user_id = home_try_on.user_id
LEFT JOIN purchase
  ON purchase.user_id = quiz.user_id
LIMIT 10;

/* TASK 6 */
WITH q AS (
  SELECT '1-quiz' AS stage, COUNT(user_id)
  FROM quiz
),
  h AS (
    SELECT '2-home_try_on' AS stage, COUNT(user_id)
    FROM home_try_on
  ),
  p AS (
    SELECT '3-purchase' AS stage, COUNT(user_id)
    FROM purchase
  )
SELECT *
FROM q
UNION ALL 
SELECT *
FROM h
UNION ALL
SELECT *
FROM p;

/* A/B Tests */

WITH tmp_table AS (
  SELECT quiz.user_id, 
    home_try_on.user_id IS NOT NULL AS 'is_home_try_on',
    home_try_on.number_of_pairs AS "number_of_pairs",
    purchase.user_id IS NOT NULL AS "is_purchase"
  FROM quiz
  LEFT JOIN home_try_on
    ON quiz.user_id = home_try_on.user_id
  LEFT JOIN purchase
    ON purchase.user_id = quiz.user_id
) 
SELECT number_of_pairs AS "AB_test",
  SUM(is_home_try_on) AS 'home_trial',
  SUM(is_purchase) AS 'purchase'
FROM tmp_table
WHERE AB_test IS NOT NULL
GROUP BY number_of_pairs;

/* Purchase by style rate */

SELECT quiz.style, COUNT(quiz.style), COUNT(purchase.style)
FROM quiz
LEFT JOIN purchase
  ON quiz.user_id = purchase.user_id
GROUP BY 1
ORDER BY 2 DESC;

/* Purchase by model rate */

SELECT model_name, COUNT(model_name), purchase.style
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;
