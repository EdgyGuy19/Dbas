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
