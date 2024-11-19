--Task 1:
SELECT post.title, string_agg(posttag.tag, ', ') AS tags
FROM post
JOIN posttag ON post.postid = posttag.postid
GROUP BY post.title
ORDER BY post.title ASC;

--Task 2:
SELECT RankedPosts.postid, RankedPosts.title, 
       RankedPosts.rank
FROM (
    SELECT post.postid, post.title, 
           RANK() OVER (ORDER BY COUNT(DISTINCT likes.userid) DESC) AS rank
    FROM post 
    JOIN likes ON post.postid = likes.postid 
    JOIN posttag ON post.postid = posttag.postid
    WHERE posttag.tag = '#leadership'
    GROUP BY post.postid 
) AS RankedPosts
WHERE RankedPosts.rank <= 5
ORDER BY RankedPosts.rank;

--Task 3:
WITH weeks AS (
    SELECT generate_series(1, 30) AS week_number
),

new_customers AS(
    SELECT subscription.userid,
    date_part('week', MIN(subscription.date)) AS new_customer,
    MIN(subscription.date) AS first_subscription
    FROM subscription
    GROUP BY subscription.userid
),

kept_customers AS(
    SELECT subscription.userid,
    date_part('week', subscription.date) AS kept_customer
    FROM subscription
    JOIN new_customers ON subscription.userid = new_customers.userid
    WHERE subscription.date > new_customers.first_subscription
),

activity AS (
    SELECT date_part('week', post.date) AS week_number_post,
           COUNT(DISTINCT post.PostID) AS post_count 
    FROM post
    GROUP BY week_number_post
)

SELECT weeks.week_number, 
       COUNT(DISTINCT new_customers.userid) AS new_customers, 
       COUNT(DISTINCT kept_customers.userid) AS kept_customers, 
       COALESCE(SUM(activity.post_count), 0) AS activity
FROM weeks
LEFT JOIN new_customers ON weeks.week_number = new_customers.new_customer
LEFT JOIN kept_customers ON weeks.week_number = kept_customers.kept_customer
LEFT JOIN activity ON weeks.week_number = activity.week_number_post
GROUP BY weeks.week_number
ORDER BY weeks.week_number;

--Task 4:
WITH registration_date AS(
    SELECT subscription.date, subscription.userid
    FROM subscription
    WHERE date_part('month', subscription.date) = 1
),

full_name AS(
    SELECT  users.name, users.userid
    FROM users
),

friendship AS(
    SELECT DISTINCT friend.userid
    FROM friend
)
SELECT full_name.name AS full_name,
CASE
    WHEN friendship.userid IS NOT NULL THEN 'true'
    ELSE 'false'
END AS has_friend,
registration_date.date AS registration_date
FROM registration_date
JOIN full_name ON registration_date.userid = full_name.userid
LEFT JOIN friendship ON registration_date.userid = friendship.userid
ORDER BY full_name.name ASC;

--Task 5:
WITH RECURSIVE chain AS (
    SELECT users.name, users.userid AS user_id, friend.friendid AS friend_id
    FROM users
    LEFT JOIN friend ON friend.userid = users.userid
    WHERE users.userid = 20

    UNION ALL

    SELECT users.name, users.userid AS user_id, friend.friendid AS friend_id
    FROM users
    LEFT JOIN friend ON friend.userid = users.userid
    JOIN chain ON users.userid = chain.friend_id
)

SELECT  *
FROM chain
ORDER BY user_id;