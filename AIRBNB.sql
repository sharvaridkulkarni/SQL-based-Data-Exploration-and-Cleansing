
select * from  [airnew1].[dbo].[air]

----Exploratory Data Analysis and data cleaning using SQL

---Checking the number of rows in data
select count(*) from [airnew1].[dbo].[air]

---Selecting top rows in sql
SELECT TOP 10 * 
from [airnew1].[dbo].[air]


---Calculate the number of rows by room type
SELECT room_type,count(*) as count 
from [airnew1].[dbo].[air]
GROUP BY room_type

---Checking if there are any null values in column price and service fee
SELECT *
FROM [airnew1].[dbo].[air]
WHERE  price IS NULL 
   OR service_fee IS NULL 

----Checking general information about the dataset
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '[airnew1].[dbo].[air]';

---Checking unique values in the column name neighbourhood group
SELECT DISTINCT neighbourhood_group
FROM [airnew1].[dbo].[air]

---Updating the data by correcting the spelling errors
UPDATE [airnew1].[dbo].[air]
SET neighbourhood_group = REPLACE(REPLACE(neighbourhood_group, 'brookln', 'Brooklyn'), 'manhatan', 'Manhattan')
WHERE neighbourhood_group LIKE '%brookln%' OR neighbourhood_group LIKE '%manhatan%';

---Looking at prices,room type in each neighbour hood and its group
SELECT neighbourhood_group,neighbourhood,room_type,price
FROM [airnew1].[dbo].[air]
ORDER BY 4 DESC;

---Finding the highest value of the price of room in the data
SELECT price,neighbourhood_group,neighbourhood,room_type
FROM [airnew1].[dbo].[air]
WHERE price = (
    SELECT MAX(price)
    FROM [airnew1].[dbo].[air]
);

---Checking the maximum price where the room type is private room
SELECT price,neighbourhood_group, neighbourhood
FROM [airnew1].[dbo].[air]
WHERE price = (
    SELECT MAX(price)
    FROM [airnew1].[dbo].[air]
    WHERE room_type='Private room'
);


---Finding the avarage price on weekdays
SELECT AVG(price)
FROM [airnew1].[dbo].[air]
WHERE neighbourhood_group='Manhattan';

---Calculating the percentage of people with neighbourhood group as Brooklyn data 
SELECT AVG(CASE WHEN neighbourhood_group = 'Brooklyn' THEN 100 ELSE 0 END) AS percentage
FROM [airnew1].[dbo].[air];



---Deleting the column house rules from the data as it will be of no use
ALTER TABLE [airnew1].[dbo].[air]
DROP COLUMN house_rules,country_code;

----Deleting the rows where the neighbourhood groups and the price columns are null
DELETE FROM [airnew1].[dbo].[air]
WHERE neighbourhood_group IS NULL OR price IS NULL;

---Counting the number of records in each neighbourhood group
SELECT neighbourhood_group, COUNT(neighbourhood_group)
FROM [airnew1].[dbo].[air]
GROUP BY neighbourhood_group;

---Looking at average number of reviews per neighbourhood group and room type
SELECT neighbourhood_group, room_type, AVG(number_of_reviews) AS average_reviews
FROM [airnew1].[dbo].[air]
GROUP BY neighbourhood_group, room_type;

---Calculating the count of each room type and its average price for all neighbourhood groups
SELECT room_type, COUNT(*) as count,
AVG(CASE WHEN neighbourhood_group='Manhattan' THEN price ELSE NULL END) as avg_price_for_Manhattan,
AVG(CASE WHEN neighbourhood_group='Brooklyn' THEN price ELSE NULL END) as avg_price_for_Brooklyn,
AVG(CASE WHEN neighbourhood_group='Bronx' THEN price ELSE NULL END) as avg_price_for_Bronx,
AVG(CASE WHEN neighbourhood_group='Queens' THEN price ELSE NULL END) as avg_price_for_Queens,
AVG(CASE WHEN neighbourhood_group='Staten Island' THEN price ELSE NULL END) as avg_price_for_StatenIsland
FROM [airnew1].[dbo].[air]
WHERE room_type IN ('Entire home/apt', 'Private room', 'Shared room','Hotel room')
GROUP BY room_type;
