--Task 1:
SELECT post.title, string_agg(posttag.tag, ', ') AS tags
FROM post
JOIN posttag ON post.postid = posttag.postid --Join posts with tags
GROUP BY post.title -- group results
ORDER BY post.title ASC; -- order them alphabetically

--Task 2:
SELECT RankedPosts.postid, RankedPosts.title, 
       RankedPosts.rank 
FROM ( --Create subquery
    SELECT post.postid, post.title, 
           RANK() OVER (ORDER BY COUNT(DISTINCT likes.userid) DESC) AS rank --rank based on likes
    FROM post 
    JOIN likes ON post.postid = likes.postid --join posts with likes
    JOIN posttag ON post.postid = posttag.postid --join posts with tags
    WHERE posttag.tag = '#leadership' --only posts with leadership tag
    GROUP BY post.postid --group results
) AS RankedPosts
WHERE RankedPosts.rank <= 5 --only top 5
ORDER BY RankedPosts.rank; --order them by rank

--Task 3:
WITH weeks AS (
    SELECT generate_series(1, 30) AS week_number -- generate 30 weeks
),

new_customers AS( -- get new customers
    SELECT subscription.userid, 
    date_part('week', MIN(subscription.date)) AS new_customer, -- get the week of the first subscription
    MIN(subscription.date) AS first_subscription -- get the first subscription date
    FROM subscription
    GROUP BY subscription.userid -- group by user
),

kept_customers AS( -- get kept customers
    SELECT subscription.userid, 
    date_part('week', subscription.date) AS kept_customer -- get the week of the subscription
    FROM subscription 
    JOIN new_customers ON subscription.userid = new_customers.userid -- join with new customers
    WHERE subscription.date > new_customers.first_subscription -- only subscriptions after the first one
),

activity AS ( -- get activity
    SELECT date_part('week', post.date) AS week_number_post, -- get the week of the post
           COUNT(DISTINCT post.PostID) AS post_count -- count the posts
    FROM post
    GROUP BY week_number_post -- group by week
)

SELECT weeks.week_number, -- select the week number
       COUNT(DISTINCT new_customers.userid) AS new_customers, -- count new customers
       COUNT(DISTINCT kept_customers.userid) AS kept_customers, -- count kept customers
       COALESCE(SUM(activity.post_count), 0) AS activity -- sum the activity
FROM weeks
LEFT JOIN new_customers ON weeks.week_number = new_customers.new_customer -- join with new customers
LEFT JOIN kept_customers ON weeks.week_number = kept_customers.kept_customer -- join with kept customers
LEFT JOIN activity ON weeks.week_number = activity.week_number_post -- join with activity
GROUP BY weeks.week_number -- group by week number
ORDER BY weeks.week_number; -- order by week number

--Task 4:
WITH registration_date AS( -- get registration date
    SELECT subscription.date, subscription.userid -- get the date and user id
    FROM subscription -- from subscription
    WHERE date_part('month', subscription.date) = 1 -- only January
),

full_name AS( -- get full name
    SELECT  users.name, users.userid -- get the name and user id
    FROM users
),

friendship AS( -- get friendship
    SELECT DISTINCT friend.userid -- get the user id
    FROM friend -- from friend
)
SELECT full_name.name AS full_name,
CASE
    WHEN friendship.userid IS NOT NULL THEN 'true' -- if user has a friend
    ELSE 'false' -- if user does not have a friend
END AS has_friend, -- check if user has a friend
registration_date.date AS registration_date -- get the registration date
FROM registration_date -- from registration date
JOIN full_name ON registration_date.userid = full_name.userid -- join with full name
LEFT JOIN friendship ON registration_date.userid = friendship.userid -- join with friendship
ORDER BY full_name.name ASC; -- order by name alaphabetically

--Task 5:
WITH RECURSIVE chain AS (
    SELECT users.name, users.userid AS user_id, friend.friendid AS friend_id -- select the name, user id and friend id
    FROM users 
    LEFT JOIN friend ON friend.userid = users.userid -- join with friend
    WHERE users.userid = 20 -- start with user 20 = ANAS

    UNION ALL

    SELECT users.name, users.userid AS user_id, friend.friendid AS friend_id -- select the name, user id and friend id
    FROM users 
    LEFT JOIN friend ON friend.userid = users.userid -- join with friend
    JOIN chain ON users.userid = chain.friend_id -- join with chain
)

SELECT  * -- select all
FROM chain
ORDER BY user_id; -- order by user id

--P+

WITH march AS (
    SELECT post.userid AS user_id, COUNT(likes.postid) AS total_likes -- count the likes from each user
    FROM post
    LEFT JOIN likes ON likes.postid = post.postid -- join with likes
    WHERE date_part('month', post.date) = 3 -- only March
    GROUP BY post.userid -- group by user id
),

like_count AS (
    SELECT march.user_id,
    CASE WHEN SUM(march.total_likes) >= 50 THEN 'true' -- if total likes is greater than 50
    ELSE 'false' -- if total likes is less than 50
    END AS received -- check if user has liked more than 50 posts
    FROM march
    GROUP BY march.user_id -- group by user id
)

SELECT users.name, like_count.received -- select the name and received
FROM like_count
JOIN users ON like_count.user_id = users.userid -- join with users
ORDER BY users.name;