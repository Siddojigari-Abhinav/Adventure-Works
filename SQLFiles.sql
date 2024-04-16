SELECT * FROM adventureworks.fact_internet_sales_new;

create table sales 
as
select * from factinternetsales union
select * from fact_internet_sales_new;

Select Round(Sum(salesamount)) as TotalRevenue
from sales;

create table productcategory
as select * from dimproductsubcategory 
join dimproductcategory 
using(productcategorykey);

create table product
as select * from dimproduct 
join productcategory
using(productsubcategorykey);

select t.SalesTerritoryCountry as "Country", concat(round(sum(s.salesamount)/1000000,1),"M") as "Sales Amount"
from sales s
join dimsalesterritory t
using(salesterritorykey)
group by 1
order by 2 desc;#Top Countries By Sales Territory

select concat(d.firstname," ",d.middlename," ",d.lastname) as "Full Name", round(sum(s.salesamount)) as "Sales Amount",round(sum(s.salesamount-s.TotalProductCost),2) as "Profit"
from sales s
join customer d
using(customerkey)
group by 1
order by 2 desc
limit 5;#top 5 customers

select dp.englishproductname as "Product Name",
round(sum(s.salesamount),2) as "Sales Amount",round(sum(s.salesamount-s.TotalProductCost),2) as "Profit"
from sales s
join dimproduct dp on s.productkey=dp.productkey
group by 1
order by 2 desc
limit 5;#top 5 products

select dd.englishmonthname as "Month Name",sum(round(s.salesamount)) as "Sales Amount"
from sales s 
join dimdate dd on s.orderdatekey=dd.datekey
group by 1
order by 2 desc;

select round(sum(salesamount-totalproductcost),2) as "Profit",st.SalesTerritoryCountry from sales
join dimsalesterritory st
using (salesterritorykey)
group by 2
order by 2 desc;#CountrywiseProfit 

select dd.calendaryear as "Year",round(sum(s.salesamount),2) as "Sales Amount",round(sum(s.salesamount-s.TotalProductCost),2) as "Profit"  from sales s 
join dimdate dd on s.OrderDatekey=dd.datekey
group by 1
order by 1  ;
#Yearwise Sales

select dd.calendaryear as "Year",count(s.orderdatekey) as "Total Orders" 
from sales s join dimdate dd 
on s.orderdatekey=dd.datekey 
group by 1 
order by 1 desc;#Yearwise Orders

select dd.englishmonthname as "Month",round(sum(s.salesamount-s.TotalProductCost),2) as "Profit" 
from sales s join dimdate dd
on s.OrderDatekey=dd.datekey
group by 1
order by 2 desc;#Monthwise Profit

select p.englishproductsubcategoryname as "Sub-Category",count(s.orderdatekey) as "Total Orders"
from sales s join product p
on p.productkey=s.productkey
group by 1
order by 2 desc;

select concat(round(count(s.OrderDateKey)/1000,2),'K'),dd.calendaryear 
from dimdate dd join sales s
on s.OrderDateKey=dd.DateKey
group by 2