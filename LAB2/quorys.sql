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
WITH weeklydata AS (
    SELECT date_part('week', date) AS week,
           subscription.date,
           userid,
           MIN(subscription.date) OVER (PARTITION BY userid) AS first_subscription_date
    FROM subscription
),
newcustomers AS (
    SELECT week, COUNT(DISTINCT userid) AS new_customers
    FROM weeklydata
    WHERE weeklydata.date = weeklydata.first_subscription_date
    GROUP BY week
),
keptcustomers AS (
    SELECT week, COUNT(DISTINCT userid) AS kept_customers
    FROM weeklydata
    WHERE first_subscription_date < DATE_TRUNC('week', CURRENT_DATE) + (week - 1) * INTERVAL '1 week'
    GROUP BY week
),
activity AS (
    SELECT date_part('week', post.date) AS week,
           COUNT(*) AS posts
    FROM post
    GROUP BY date_part('week', post.date)
)
SELECT newcustomers.week,
       COALESCE(newcustomers.new_customers, 0) AS new_customers,
       COALESCE(keptcustomers.kept_customers, 0) AS kept_customers,
       COALESCE(activity.posts, 0) AS activity
FROM newcustomers
LEFT JOIN keptcustomers ON newcustomers.week = keptcustomers.week
LEFT JOIN activity ON newcustomers.week = activity.week
WHERE newcustomers.week BETWEEN 1 AND 30
ORDER BY newcustomers.week;