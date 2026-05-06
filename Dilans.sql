_________________________________________________________KEY FIGURES

-- number of unique reader

SELECT COUNT(DISTINCT dilans.new_read.user_id) AS unique_user_count
FROM dilans.new_read

-- number of new users/date

SELECT
new_read.date::DATE AS date_only, COUNT(DISTINCT new_read.user_id) AS visit_count
FROM dilans.new_read
GROUP BY date_only
ORDER BY date_only ASC;


-- number of recuring users

SELECT COUNT(DISTINCT dilans.rec_read.user_id) AS unique_user_count
FROM dilans.rec_read

-- number of rec readers/date

SELECT
rec_read.date::DATE AS date_only, COUNT(DISTINCT rec_read.user_id) AS visit_count
FROM dilans.rec_read
GROUP BY date_only
ORDER BY date_only ASC;


-- number of subscribers

SELECT COUNT(DISTINCT dilans.subscribe.user_id) AS unique_user_count
FROM dilans.subscribe

-- number of subscribers/date

SELECT
subscribe.date::DATE AS date_only, COUNT(DISTINCT subscribe.user_id) AS visit_count
FROM dilans.subscribe
JOIN dilans.new_read
  ON subscribe.user_id = new_read.user_id
GROUP BY date_only, new_read.src
ORDER BY date_only ASC;


-- number of buyer

SELECT COUNT(DISTINCT dilans.buy.user_id) AS unique_user_count
FROM dilans.buy

-- number of subscribers/date

SELECT
buy.date::DATE AS date_only, COUNT(DISTINCT buy.user_id) AS visit_count
FROM dilans.buy
JOIN dilans.new_read
  ON buy.user_id = new_read.user_id
GROUP BY date_only, new_read.src
ORDER BY date_only ASC;

_________________________________________________________TOPICS

-- new readers/topics

SELECT COUNT(DISTINCT dilans.new_read.user_id) AS unique_user_count, topic
FROM dilans.new_read
GROUP BY topic 
Order BY topic ASC;


-- recurring readers/topics

SELECT COUNT(DISTINCT dilans.new_read.user_id) AS unique_user_count, dilans.new_read.topic
FROM dilans.new_read
JOIN dilans.rec_read
On dilans.new_read.user_id = dilans.rec_read.user_id
GROUP BY dilans.new_read.topic
Order BY topic ASC;


-- Subscribers/topics

SELECT COUNT(DISTINCT dilans.subscribe.user_id) AS unique_user_count, topic
FROM dilans.subscribe
JOIN dilans.new_read
On dilans.subscribe.user_id = dilans.new_read.user_id
GROUP BY topic 
Order BY topic ASC;


-- Buyers/topics

SELECT COUNT(DISTINCT dilans.buy.user_id) AS unique_user_count, topic
FROM dilans.buy
JOIN dilans.new_read
On dilans.buy.user_id = dilans.new_read.user_id
GROUP BY topic 
Order BY topic ASC;

_________________________________________________________ACTIVITY BY COUNTRIES


-- unique users/country 

SELECT COUNT(DISTINCT user_id) AS unique_user_count, cntr
FROM dilans.new_read
GROUP BY cntr 
Order BY unique_user_count DESC;


-- List of countries by the number of recurring users 

SELECT COUNT(DISTINCT user_id) AS unique_user_count, cntr
FROM dilans.rec_read
GROUP BY cntr 
Order BY unique_user_count DESC;


-- List of countries by the number of subscribers 

SELECT COUNT(DISTINCT dilans.subscribe.user_id) AS unique_user_count, cntr
FROM dilans.subscribe
JOIN dilans.new_read
On dilans.subscribe.user_id = dilans.new_read.user_id
GROUP BY cntr 
Order BY unique_user_count DESC;
    

-- List of countries by the number of purchasing users

SELECT COUNT(DISTINCT dilans.buy.user_id) AS unique_user_count, cntr
FROM dilans.buy
JOIN dilans.rec_read
On dilans.buy.user_id = dilans.rec_read.user_id
GROUP BY cntr 
Order BY unique_user_count DESC;
    

_________________________________________________________DATE BASED SOURCES


-- date based new read/source

SELECT 
    DISTINCT new_read.src,
    new_read.date :: DATE AS date_only,
    COUNT (*)
FROM dilans.new_read
GROUP BY date_only, src
ORDER by date_only;



-- date based recurring read/date/source

SELECT 
  DATE(nr.date) AS date_only,
  nr.src,
  COUNT(DISTINCT nr.user_id) AS visit_count
FROM dilans.new_read AS nr
INNER JOIN dilans.rec_read AS rr
  ON nr.user_id = rr.user_id
GROUP BY date_only, nr.src
ORDER BY date_only ASC;


-- date based subscriber/date/source

SELECT
    subscribe.date::DATE AS date_only, 
    new_read.src,
  COUNT(DISTINCT subscribe.user_id) AS visit_count
FROM dilans.subscribe
JOIN dilans.new_read
  ON subscribe.user_id = new_read.user_id
GROUP BY date_only, new_read.src
ORDER BY date_only ASC;


-- date based buyer/date/source

SELECT 
  DATE(nr.date) AS date_only,
  nr.src,
  COUNT(DISTINCT nr.user_id) AS visit_count
FROM dilans.new_read AS nr
INNER JOIN dilans.buy AS rr
  ON nr.user_id = rr.user_id
GROUP BY date_only, nr.src
ORDER BY date_only ASC;

_________________________________________________________SOURCES

-- List of sources by the number of new users 

SELECT COUNT(DISTINCT user_id) AS unique_user_count, src
FROM dilans.new_read
GROUP BY dilans.new_read.src
Order BY src DESC; 

-- List of sources by the number of recurring users 

SELECT COUNT(DISTINCT dilans.new_read.user_id) AS unique_user_count, src
FROM dilans.new_read
JOIN dilans.rec_read
On dilans.new_read.user_id = dilans.rec_read.user_id
GROUP BY dilans.new_read.src
Order BY src DESC; 

-- List of sources by the number of subscribing users 

SELECT COUNT(DISTINCT dilans.new_read.user_id) AS unique_user_count, src
FROM dilans.new_read
JOIN dilans.subscribe
On dilans.new_read.user_id = dilans.subscribe.user_id
GROUP BY dilans.new_read.src
Order BY src DESC; 

-- the number of buyer

SELECT COUNT(DISTINCT dilans.new_read.user_id) AS unique_user_count, src
FROM dilans.new_read
JOIN dilans.buy
On dilans.new_read.user_id = dilans.buy.user_id
GROUP BY dilans.new_read.src
Order BY src DESC; 

_________________________________________________________MICROSEGMENTATION

-- Micro segmentation - Source, Country

SELECT dilans.new_read.src, dilans.new_read.cntr, COUNT (*)
FROM dilans.new_read
GROUP BY src, cntr
ORDER BY count DESC;

-- Micro segmentation - Source, Country, Topic

SELECT dilans.new_read.src, dilans.new_read.cntr, dilans.new_read.topic, COUNT (*)
FROM dilans.new_read
GROUP BY src, cntr, topic
ORDER BY count DESC;


-- Microsegmentation of buyers/country/source

SELECT dilans.new_read.src, dilans.new_read.cntr, dilans.new_read.topic, COUNT (*)
FROM dilans.buy
JOIN dilans.new_read
On dilans.buy.user_id = dilans.new_read.user_id
GROUP BY src, cntr, topic
ORDER BY count DESC;


_________________________________________________________REVENUE

-- Rvenue calculation

SELECT SUM(dilans.buy.price) AS total_price
FROM dilans.buy;

--Revenue by Sources

SELECT SUM(dilans.buy.price) AS total_price, src
FROM dilans.buy
JOIN dilans.new_read
On dilans.buy.user_id = dilans.new_read.user_id
GROUP BY src

--Revenue by Countries 

SELECT SUM(dilans.buy.price) AS total_price, cntr
FROM dilans.buy
JOIN dilans.new_read
On dilans.buy.user_id = dilans.new_read.user_id
GROUP BY cntr
ORDER BY total_price DESC;


--Revenue by Topics

SELECT SUM(dilans.buy.price) AS total_price, topic
FROM dilans.buy
JOIN dilans.new_read
On dilans.buy.user_id = dilans.new_read.user_id
GROUP BY topic
ORDER BY total_price DESC;

-- Revenue Micro segmentation - Source, Country, Topic

SELECT SUM(dilans.buy.price) AS total_price, cntr, topic, src
FROM dilans.buy
JOIN dilans.new_read
On dilans.buy.user_id = dilans.new_read.user_id
GROUP BY cntr, topic, src
ORDER BY total_price DESC;


-- Date based Revenue

SELECT
    buy.date::DATE AS date_only, 
    SUM(dilans.buy.price) AS total_price
FROM dilans.buy
GROUP BY date_only
ORDER BY date_only ASC;


-- Date based Revenue

SELECT
    buy.date::DATE AS date_only, 
    SUM(dilans.buy.price) AS total_price
FROM dilans.buy
GROUP BY date_only
ORDER BY date_only ASC;


-- Microsegment for date and source by Revenue

SELECT SUM(dilans.buy.price) AS total_price, dilans.new_read.src, dilans.new_read.cntr, dilans.new_read.topic, buy.date::DATE AS date_only 
FROM dilans.buy
JOIN dilans.new_read
On dilans.buy.user_id = dilans.new_read.user_id
GROUP BY src, cntr, topic, date_only
ORDER BY total_price DESC;


_________________________________________________________FUNELS


-- Microsegmentation of new uyers/country/source

SELECT new_read.date::DATE AS date_only, dilans.new_read.src, dilans.new_read.cntr, COUNT (DISTINCT dilans.new_read.user_id)
FROM dilans.new_read
GROUP BY date_only, src, cntr
ORDER BY date_only ASC;


-- Microsegmentation of recurring uyers/country/source

SELECT rec_read.date::DATE AS date_only, dilans.new_read.src, dilans.new_read.cntr, COUNT (DISTINCT dilans.rec_read.user_id)
FROM dilans.rec_read
RIGHT JOIN dilans.new_read
ON dilans.new_read.user_id = dilans.rec_read.user_id
GROUP BY date_only, dilans.new_read.src, dilans.new_read.cntr
ORDER BY date_only ASC;

-- Microsegmentation of subsribers uyers/country/source

SELECT subscribe.date::DATE AS date_only, dilans.new_read.src, dilans.new_read.cntr, COUNT (DISTINCT dilans.subscribe.user_id)
FROM dilans.subscribe
RIGHT JOIN dilans.new_read
ON dilans.new_read.user_id = dilans.subscribe.user_id
GROUP BY date_only, dilans.new_read.src, dilans.new_read.cntr
ORDER BY date_only ASC;

-- Microsegmentation of buyers uyers/country/source

SELECT buy.date::DATE AS date_only, dilans.new_read.src, dilans.new_read.cntr, COUNT (DISTINCT dilans.buy.user_id)
FROM dilans.buy
JOIN dilans.new_read
ON dilans.new_read.user_id = dilans.buy.user_id
GROUP BY date_only, dilans.new_read.src, dilans.new_read.cntr
ORDER BY date_only ASC;


-- Summary of Microsegmentation of buyers uyers/country/source

SELECT SUM(count_column) AS total_count
FROM (
    SELECT 
        buy.date::DATE AS date_only, 
        dilans.new_read.src, 
        dilans.new_read.cntr, 
        COUNT(DISTINCT dilans.buy.user_id) AS count_column
    FROM dilans.buy
    JOIN dilans.new_read
        ON dilans.new_read.user_id = dilans.buy.user_id
    GROUP BY date_only, dilans.new_read.src, dilans.new_read.cntr
) AS sub;


SELECT SUM(count_column) AS total_count
FROM (
    SELECT 
        subscribe.date::DATE AS date_only, 
        dilans.new_read.src, 
        dilans.new_read.cntr, 
        COUNT(*) AS count_column
    FROM dilans.subscribe
    JOIN dilans.new_read
        ON dilans.new_read.user_id = dilans.subscribe.user_id
    GROUP BY date_only, dilans.new_read.src, dilans.new_read.cntr
) AS sub;

SELECT SUM(count_column) AS total_count
FROM (
    SELECT 
        subscribe.date::DATE AS date_only, 
        dilans.new_read.src, 
        dilans.new_read.cntr, 
        COUNT(*) AS count_column
    FROM dilans.subscribe
    JOIN dilans.new_read
        ON dilans.new_read.user_id = dilans.subscribe.user_id
    GROUP BY date_only, dilans.new_read.src, dilans.new_read.cntr
) AS sub;


--BIG MERGE LEFT JOIN

SELECT date_only, dilans.new_read.src, dilans.new_read.cntr,
        recur.recur, sbcr.sbcr, by.by
FROM
    (SELECT new_read.date::DATE AS date_only, dilans.new_read.src, dilans.new_read.cntr, COUNT (DISTINCT dilans.new_read.user_id) AS newr
    FROM dilans.new_read
    GROUP BY date_only, src, cntr
    ORDER BY date_only ASC) AS newr
LEFT JOIN
    (SELECT new_read.date::DATE AS date_only, dilans.new_read.src, dilans.new_read.cntr, COUNT (DISTINCT dilans.rec_read.user_id) AS reecur
    FROM dilans.rec_read
    RIGHT JOIN dilans.new_read
    ON dilans.new_read.user_id = dilans.rec_read.user_id
    GROUP BY date_only, dilans.new_read.src, dilans.new_read.cntr
    ORDER BY date_only ASC) AS recur
ON newr.date_only = recur.date_only AND newr.src = recur.src AND newr.cntr = recur.cntr
LEFT JOIN
    (SELECT new_read.date::DATE AS date_only, dilans.new_read.src, dilans.new_read.cntr, COUNT (DISTINCT dilans.subscribe.user_id) AS sbcr
    FROM dilans.subscribe
    RIGHT JOIN dilans.new_read
    ON dilans.new_read.user_id = dilans.subscribe.user_id
    GROUP BY date_only, dilans.new_read.src, dilans.new_read.cntr
    ORDER BY date_only ASC) AS sbcr
ON newr.date_only = sbcr.date_only AND newr.src = sbcr.src AND newr.cntr = sbcr.cntr
LEFT JOIN
    (SELECT new_read.date::DATE AS date_only, dilans.new_read.src, dilans.new_read.cntr, COUNT (DISTINCT dilans.buy.user_id) AS by
    FROM dilans.buy
    JOIN dilans.new_read
    ON dilans.new_read.user_id = dilans.buy.user_id
    GROUP BY date_only, dilans.new_read.src, dilans.new_read.cntr
    ORDER BY date_only ASC) AS by
ON newr.date_only = by.date_only AND newr.src = by.src AND newr.cntr = by.cntr
    



SELECT 
    newr.date_only,
    newr.src,
    newr.cntr,
    newr.newr AS newr_count,
    recur.recur AS recur_count,
    sbcr.sbcr AS sbcr_count,
    bys.by AS buy_count
FROM
    (SELECT new_read.date::DATE AS date_only, new_read.src, new_read.cntr, 
            COUNT(DISTINCT new_read.user_id) AS newr
     FROM dilans.new_read
     GROUP BY date_only, new_read.src, new_read.cntr) AS newr
LEFT JOIN
    (SELECT new_read.date::DATE AS date_only, new_read.src, new_read.cntr, 
            COUNT(DISTINCT rec_read.user_id) AS recur
     FROM dilans.rec_read
     RIGHT JOIN dilans.new_read
         ON new_read.user_id = rec_read.user_id
     GROUP BY date_only, new_read.src, new_read.cntr) AS recur
  ON newr.date_only = recur.date_only AND newr.src = recur.src AND newr.cntr = recur.cntr
LEFT JOIN
    (SELECT new_read.date::DATE AS date_only, new_read.src, new_read.cntr, 
            COUNT(DISTINCT subscribe.user_id) AS sbcr
     FROM dilans.subscribe
     RIGHT JOIN dilans.new_read
         ON new_read.user_id = subscribe.user_id
     GROUP BY date_only, new_read.src, new_read.cntr) AS sbcr
  ON newr.date_only = sbcr.date_only AND newr.src = sbcr.src AND newr.cntr = sbcr.cntr
LEFT JOIN
    (SELECT new_read.date::DATE AS date_only, new_read.src, new_read.cntr, 
            COUNT(DISTINCT buy.user_id) AS by
     FROM dilans.buy
     JOIN dilans.new_read
         ON new_read.user_id = buy.user_id
     GROUP BY date_only, new_read.src, new_read.cntr) AS bys
  ON newr.date_only = bys.date_only AND newr.src = bys.src AND newr.cntr = bys.cntr;