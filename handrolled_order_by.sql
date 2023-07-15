with 
base (row_no, num) as (
	select 
    	level, 
    	floor(dbms_random.value(1, 11)) 
    from 
    	dual 
    connect by 
    	level <= 10
),
order_by_desc (new_order, row_no, num) as (
	select 
    	1,
    	row_no,
    	num
    from
    	base
    where
    	num = ( select max(num) from base )
    union all
    select 	
		a.new_order + 1,
    	b.row_no,
    	b.num
    from 
    	order_by_desc a
    join
    	base b
    on
    	a.num > b.num
    where
    	b.num = ( select max(num) from base c where c.num < a.num )
    and
    	a.new_order  < ( select count(*) from base )
),
order_by_asc (new_order, row_no, num) as (
	select 
    	1,
    	row_no,
    	num
    from
    	base
    where
    	num = ( select min(num) from base )
    union all
    select 	
		a.new_order + 1,
    	b.row_no,
    	b.num
    from 
    	order_by_asc a
    join
    	base b
    on
    	a.num < b.num
    where
    	b.num = ( select min(num) from base c where c.num > a.num )
    and
    	a.new_order  < ( select count(*) from base )
)
select distinct * from order_by_asc
--select distinct * from order_by_desc
;
