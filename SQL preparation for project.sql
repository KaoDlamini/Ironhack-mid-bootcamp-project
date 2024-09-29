#1.Create a database called house_price_regression.
drop database if exists house_price_regression;
create database house_price_regression;

use house_price_regression;

# 2.Create a table house_price_data with the same columns as given in the csv file. 
drop table if exists house_price_data;
CREATE TABLE house_price_data (
  `id` bigint NOT NULL,
  `date` VARCHAR(10) DEFAULT NULL,
  `bedrooms` int(4) DEFAULT NULL,
  `bathrooms` float DEFAULT NULL,
  `sqft_living` float DEFAULT NULL,
  `sqft_lot` float DEFAULT NULL,
  `floors` int(4) DEFAULT NULL,
  `waterfront` int(4) DEFAULT NULL,
  `view` int(4) DEFAULT NULL,
  `condition` int(4) DEFAULT NULL,
  `grade` int(4) DEFAULT NULL,
  `sqft_above` float DEFAULT NULL,
  `sqft_basement` float DEFAULT NULL,
  `yr_built` int(11) DEFAULT NULL,
  `yr_renovated` int(11) DEFAULT NULL,
  `zip_code` int(11) DEFAULT NULL,
  `lat` float DEFAULT NULL,
  `long` float DEFAULT NULL,
  `sqft_living15` float DEFAULT NULL,
  `sqft_lot15` float DEFAULT NULL,
  `price` float DEFAULT NULL,
  PRIMARY KEY (`id`)
);
#3.Import the data from the csv file into the table.
SHOW VARIABLES LIKE 'local_infile'; -- This query would show you the status of the variable ‘local_infile’. If it is off, use the next command, otherwise you should be good to go
SET GLOBAL local_infile = 1;


# 4.Select all the data from table house_price_data to check if the data was imported correctly
select * from house_price_data

#5.Use the alter table command to drop the column date from the database, as we would not use it in the analysis with SQL.
# Select all the data from the table to verify if the command worked. Limit your returned results to 10.
alter table house_price_data
drop column date;

#6. Use sql query to find how many rows of data you have.
select count(id) from house_price_data

#7. Now we will try to find the unique values in some of the categorical columns:
# What are the unique values in the column bedrooms?
select distinct(bedrooms) from house_price_data
order by bedrooms asc

# What are the unique values in the column bathrooms?
select distinct(bathrooms) from house_price_data
order by bathrooms asc

# What are the unique values in the column floors?
select distinct(floors) from house_price_data
order by floors asc

# What are the unique values in the column condition?
select distinct `condition` from house_price_data
order by `condition` asc

# What are the unique values in the column grade?
select distinct(grade) from house_price_data
order by grade asc

#8.Arrange the data in a decreasing order by the price of the house. 
# Return only the IDs of the top 10 most expensive houses in your data.
select id, price from house_price_data
order by price desc
limit 10;

#9. What is the average price of all the properties in your data?
select avg(price) from house_price_data

#10. In this exercise we will use simple group by to check the properties of some of the categorical variables in our data
 # What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.
 select bedrooms, round(avg(price),2) as average_price from house_price_data
 group by bedrooms
 order by bedrooms asc
 
 # What is the average sqft_living of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the sqft_living. Use an alias to change the name of the second column.
select bedrooms, round(avg(sqft_living ),2) as living_space from house_price_data
group by bedrooms
order by bedrooms asc
  
 # What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and Average of the prices. Use an alias to change the name of the second column.
 select waterfront, round(avg(price ),2) as average_price from house_price_data
group by waterfront
order by waterfront asc

 # Is there any correlation between the columns condition and grade? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
select `condition`, round(avg(grade),2) as average_grade from house_price_data
group by `condition`
order by `condition` asc
#There seems to be a positive correlation between these two metrics since the better the condition the property is in the better the average grade.


#11.One of the customers is only interested in the following houses:
#Number of bedrooms either 3 or 4
#Bathrooms more than 3
#One Floor
#No waterfront
#Condition should be 3 at least
#Grade should be 5 at least
#Price less than 300000
#For the rest of the things, they are not too concerned. 
#Write a simple query to find what are the options available for them?
select * from house_price_data
where (bedrooms = 3 or bedrooms = 4)
  and bathrooms > 3
  and floors = 1
  and waterfront = 0
  and `condition` > 2
  and grade > 4
    and price < 300000


#12.Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. 
#Write a query to show them the list of such properties. You might need to use a sub query for this problem.

 select *  from house_price_data
 where price > (select avg(price)*2 from house_price_data)



#13.Since this is something that the senior management is regularly interested in, create a view of the same query.
create view Houses_with_higher_than_double_average_price as 
select * from house_price_data
where price > (select avg(price)*2 from house_price_data);


#14.Most customers are interested in properties with three or four bedrooms.
#What is the difference in average prices of the properties with three and four bedrooms?

select
ROUND(avg(case when bedrooms = 3 then price else 0 end ),2) as 3bedrooms,
ROUND(avg(case when bedrooms = 4 then price else 0 end ),2) as 4bedrooms,
ROUND(avg(case when bedrooms = 3 then price else 0 end ),2)-
ROUND(avg(case when bedrooms = 4 then price else 0 end ),2) as difference_of_price_btw_3_and_4_bedroom
from house_price_data
where (bedrooms = 3 OR bedrooms = 4)


#15.What are the different locations where properties are available in your database? (distinct zip codes)
select distinct `zip_code` from house_price_data;

#16.Show the list of all the properties that were renovated
select *from house_price_data
where yr_renovated != 0;

#17.Provide the details of the property that is the 11th most expensive property in your database.
select * from house_price_data
order by price desc
limit 10,1;
