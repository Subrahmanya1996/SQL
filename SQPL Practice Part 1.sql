---************SQL Practice Question 1

drop table icc_world_cup;

create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;

--**********************Solution 1:

select Team_1 as Team_name,Matches_Played, isnull(Win_Count,0) as no_of_wins,Matches_Played-isnull(Win_Count,0) as no_of_losses
from
(
select Team_1, count(*) as Matches_Played from 
(
select distinct Team_1 from icc_world_cup
union all
select distinct Team_2 from icc_world_cup
) a
group by Team_1
)a
left join
(
select Winner, count(*) as Win_Count from 
(
select distinct Team_1, Winner from icc_world_cup
union all
select distinct Team_2, Winner from icc_world_cup
) a
where Team_1<>Winner
group by Winner
) b
on a.Team_1=b.Winner;

---************SQL Practice Question 2

drop table customer_orders;

create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

insert into customer_orders values
(1,100,cast('2022-01-01' as date),2000),
(2,200,cast('2022-01-01' as date),2500),
(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),
(5,400,cast('2022-01-02' as date),2200),
(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),
(8,400,cast('2022-01-03' as date),1000),
(9,600,cast('2022-01-03' as date),3000)
;

select * from customer_orders

https://www.youtube.com/watch?v=MpAMjtvarrc&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=2

--**********************Solution 2:

with old_cust as 
(
select order_date, customer_id
from customer_orders
)
select order_date, sum(old_customer) as repeated_customer, sum(new_customer) as new_customer from 
(
select order_date, customer_id,
case when exists (select * from old_cust a where a.customer_id=customer_orders.customer_id and a.order_date<customer_orders.order_date) then 1 else 0 end as old_customer,
case when not exists (select * from old_cust a where a.customer_id=customer_orders.customer_id and a.order_date<customer_orders.order_date) then 1 else 0 end as new_customer
from customer_orders
)a
group by order_date;

---************SQL Practice Question 3

drop table entries;

create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries values 
('A','Bangalore','A@gmail.com',1,'CPU'),
('A','Bangalore','A1@gmail.com',1,'CPU'),
('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),
('B','Bangalore','B1@gmail.com',2,'DESKTOP'),
('B','Bangalore','B2@gmail.com',1,'MONITOR')

--****************************Solution 3:

with used_resources as 
(
select name, string_agg(resources,',') as used_resources from
(
select distinct name, resources from entries
) a
group by name
),
most_visited_floor as 
(
select name, floor from (
select name, floor, count(*) as times_visited,rank() over (partition by name order by count(*) desc) as rank
from entries
group by name, floor
) a
where rank=1
) 
select en.name,count(*) total_visits,mvf.floor as most_visited_floor,ur.used_resources as resources_used  from entries en
inner join
used_resources ur
on en.name=ur.name
inner join
most_visited_floor mvf
on en.name=mvf.name
group by en.name,ur.used_resources,mvf.floor;



----***************************SQL Question and Solution 4: 
declare @today_date date;
declare @n int;
set @today_date='2022-01-01';
set @n =3;

select dateadd(day,8+((@n-1)*7)-datepart(weekday,@today_date),@today_date)

----***************************SQL Question 5:

drop table person;

create table person 
(
PersonID varchar(50),
name varchar(100),
Email varchar(100),
score int
);

insert into person values 
('1','Alice','alice2018@hotmail.com',88),
('2','Bob','bob2018@hotmail.com',88),
('3','Davis','davis2018@hotmail.com',88),
('4','Tara','tara2018@hotmail.com',88),
('5','John','john2018@hotmail.com',88);

drop table friend;

create table friend 
(
PersonID varchar(50),
FriendID varchar(100)
);

insert into friend values 
('1','2'),
('1','3'),
('2','1'),
('2','3'),
('3','5'),
('4','2'),
('4','3'),
('4','5');

--********************************Solution 5:


select a.PersonID, a.name, count(FriendID) as Number_of_friends,sum(friend_score) as sum_of_friends_marks from person a
left join
(select a.PersonID, FriendID, score as friend_score from friend a
left join
person b
on a.FriendID=b.PersonID
)
b
on 
a.PersonID=b.PersonID
group by a.PersonID, a.name
having sum(friend_score)>100;
