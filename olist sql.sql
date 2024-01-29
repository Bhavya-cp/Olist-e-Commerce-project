create database Olist1;
use Olist1;
show tables;
select * from olist_customers_dataset;
select * from olist_geolocation_dataset;
select * from olist_order_items_dataset;
select * from olist_order_payments_dataset;
select * from olist_order_reviews_dataset;
select * from olist_orders_dataset;
select * from olist_products_dataset;
select * from olist_sellers_dataset;
select * from product_category_name_translation;


#### 1)Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
select * from olist_orders_dataset;

select
case 
when weekday(order_purchase_timestamp)>4 then "Weekend"
else "Weekday"
end WN,
count(order_purchase_timestamp) as OPTS 
from olist_orders_dataset
group by WN;
 
#### 3)Average number of days taken for order_delivered_customer_date for pet_shop
select * from olist_orders_dataset;
select * from olist_order_items_dataset;
select * from olist_products_dataset;

select avg(olist_orders_dataset.order_delivered_customer_date),
olist_products_dataset.product_category_name from
olist_orders_dataset join olist_order_items_dataset
on olist_orders_dataset.order_id = olist_order_items_dataset.order_id
join olist_products_dataset
on olist_products_dataset.product_id = olist_order_items_dataset.product_id
where olist_products_dataset.product_category_name = 'pet_shop'
group by olist_products_dataset.product_category_name;


#### 4)Average price and payment values from customers of sao paulo city
select * from olist_order_items_dataset;
select * from olist_order_payments_dataset;
select * from olist_geolocation_dataset;
select * from olist_sellers_dataset;

select avg(olist_order_items_dataset.price),avg(olist_order_payments_dataset.payment_value),
olist_geolocation_dataset.geolocation_city from
olist_order_items_dataset join olist_order_payments_dataset
on 	olist_order_items_dataset.order_id = olist_order_payments_dataset.order_id
join olist_sellers_dataset
on olist_order_items_dataset.seller_id = olist_sellers_dataset.seller_id
join olist_geolocation_dataset
on olist_geolocation_dataset.geolocation_zip_code_prefix = olist_sellers_dataset.seller_zip_code_prefix
where olist_geolocation_dataset.geolocation_city ='sao paulo'
group by olist_geolocation_dataset.geolocation_city;

#### 5)Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.
select * from olist_orders_dataset;
select * from olist_order_reviews_dataset;

select review_score,round(avg(abs(timestampdiff(Day,order_delivered_customer_date,order_purchase_timestamp)))) as Shipping_days 
from olist_orders_dataset ood
join olist_order_reviews_dataset oor 
on (ood.order_id=oor.order_id)
group by review_score
order by review_score;

#### 2)Number of Orders with review score 5 and payment type as credit card.
select * from olist_order_reviews_dataset;
select * from olist_order_payments_dataset;
select * from olist_orders_dataset;

select count(b.order_id) as Number_of_Orders from olist_order_payments_dataset a inner join
olist_order_reviews_dataset b on (a.order_id = b.order_id)
where review_score = 5 and payment_type = 'Credit_card';
