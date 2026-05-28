select e.event_type , count(*) from events e group by e.event_type;

/*Product getting High engagement from users*/
select p.category, count(*) as Total_views  from events e join products p on 
e.product_id = p.product_id where e.event_type ='view' group by p.category order by Total_views desc ;
--Product wise details for highest view
select p.product_name ,p.category, count(*) as Total_views  from events e join products p on 
e.product_id = p.product_id where e.event_type ='view' group by p.category,p.product_name order by Total_views desc ;

--Category with high purchase count
select p.category, count(*) as Total_purchases  from events e join products p on 
e.product_id = p.product_id where e.event_type ='purchase' group by p.category order by Total_purchases desc ;

--Category with high cart count
select p.category, count(*) as Total_cart_count  from events e join products p on 
e.product_id = p.product_id where e.event_type ='cart' group by p.category order by Total_cart_count desc ;

--Category with high wishlist count
select p.category, count(*) as Total_wishlist_count  from events e join products p on 
e.product_id = p.product_id where e.event_type ='wishlist' group by p.category order by Total_wishlist_count desc ;

--views vs purchases 
select p.category, count(*) as Total_cart_count  from events e join products p on 
e.product_id = p.product_id where e.event_type ='cart' group by p.category order by Total_cart_count desc ;

select distinct count(*) from products p ;
select * from reviews;
select * from events ;
select * from products ;

select * from orders o  where o.order_id in('O00001959','O00004533','O00010807') 
 


