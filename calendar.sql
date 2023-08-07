with 
base 
(
    dt,
    dy,
    w
)as 
(
    select 
    	trunc(sysdate, 'mm') + level - 1,
    	to_char(trunc(sysdate, 'mm') + level - 1, 'Dy'),
    	to_char(trunc(sysdate, 'mm') + level - 1, 'ww')
    from
    	dual
    connect by 
    	level <= trunc(sysdate, 'mm') + interval '1' month - trunc(sysdate, 'mm')
),
calendar as 
(
    select 
		*
    from 
    	base
    pivot
    	(
    		max(to_char(dt, 'dd')) 
    		for 
    			dy 
    		in 
    			(
    				'Sun' as Sun, 
    				'Mon' as Mon, 
    				'Tue' as Tue, 
    				'Wed' as Wed, 
    				'Thu' as Thu, 
    				'Fri' as Fri,
    				'Sat' as Sat
    			)
        )
)
select * from calendar order by w;