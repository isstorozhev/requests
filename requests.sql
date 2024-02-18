create table customers (
  customer_id varchar primary key,
  first_name varchar,
  last_name varchar,
  gender varchar,
  DOB varchar,
  job_title varchar,
  job_industry_category varchar,
  wealth_segment varchar,
  deceased_indicator varchar,
  owns_car varchar,
  address varchar,
  postcode varchar,
  state varchar,
  country varchar,
  property_valuation int8
);

create table transactions (
  transaction_id varchar primary key,
  product_id varchar,
  customer_id varchar,
  transaction_date varchar,
  online_order varchar,
  order_status varchar,
  brand varchar,
  product_line varchar,
  product_class varchar,
  product_size varchar,
  list_price float,
  standard_cost float
);

--N1
select distinct brand as unique_brands
from transactions
where standard_cost > 1500;

--N2
select *
from transactions
where order_status = 'Approved' and transaction_date::date between '2017-04-01' and '2017-04-09';

--N3
select distinct job_title as unique_job_titles
from customers
where (job_industry_category = 'IT' or job_industry_category = 'Financial Services') and job_title like 'Senior%';

--N4
select distinct brand as unique_brands
from transactions
right join (select distinct customer_id
			from customers
			where job_industry_category = 'Financial Services') as brands
			on transactions.customer_id = brands.customer_id
where brand notnull;

--N5
select *
from customers
right join (select distinct customer_id
			from transactions
			where online_order = 'True' and brand in ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
			limit 10) as customer_ids on customers.customer_id = customer_ids.customer_id;

--N6
select *
from customers
where customer_id not in (select distinct customer_id
						  from transactions);

--N7
select *
from customers
where customer_id in (select distinct customer_id
					  from transactions
					  where standard_cost = (select max(standard_cost)
					  						 from transactions));

--N8
select * 
from customers
where (job_industry_category = 'IT' or
	   job_industry_category = 'Health') and customer_id in (select distinct customer_id
	   														 from transactions
	   														 where (transaction_date::date between '2017-07-07' and '2017-07-17') and order_status = 'Approved');
