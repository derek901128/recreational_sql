with
base (s) as 
(
    select 'derek lei chan kit' from dual
),
breakup 
(
    n,
    s,
    c,	
    ac
) as 
(
    select 
    	1, 
    	s, 
    	substr(s, 1, 1), 
    	ascii(substr(s, 1, 1))
    from 
    	base
    union all
    select 
    	n + 1, 
    	s, 
    	substr(s, n + 1, 1), 
    	ascii(substr(s, n + 1, 1))
	from 
    	breakup
    where 
    	n < length(s)
),
islands as 
(
    select 
    	n,
		n - rank() over(partition by case ac when 32 then 'space' else 'not_space' end order by n) as subgroups,
    	s,
    	c,
    	ac
    from
    	breakup
),
first_letters as 
(
    select
     	n, 
    	case ac 
    		when 32 
    		then 0
    		else rank() over(partition by subgroups order by n) 
    	end as first_letters,
    	s, 
    	c, 
    	ac
	from 
    	islands
)
select 
    listagg
	(
    	case
     	 	when first_letters = 1 and ac between 97 and 122
    		then chr(ac - 32)
    		else c
    	end
    ) within group (order by n) as cs
from
	first_letters
;
