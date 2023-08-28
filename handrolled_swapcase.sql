with 
base(s) as 
(
    select 'DeReK' from dual
),
swap_case
(
    n,
    s,
    c,
    sc
) as 
(
    select 
    	1, 
    	s, 
    	substr(s, 1, 1), 
   	 	case 
    		when ascii(substr(s, 1, 1)) between 97 and 122 
    		then chr(ascii(substr(s, 1, 1)) - 32)
    		when ascii(substr(s, 1, 1)) between 65 and 90
    		then chr(ascii(substr(s, 1, 1)) + 32)
    		else chr(ascii(substr(s, 1, 1)))
    	end
    from 
    	base
    union all
    select 
    	n + 1,
    	s,
    	substr(s, n + 1, 1),
    	case 
    		when ascii(substr(s, n + 1, 1)) between 97 and 122 
    		then chr(ascii(substr(s, n + 1, 1)) - 32)
    		when ascii(substr(s, n + 1, 1)) between 65 and 90
    		then chr(ascii(substr(s, n + 1, 1)) + 32)
    		else chr(ascii(substr(s, n + 1, 1)))
    	end
    from
		swap_case
    where
    	n < length(s)
)
select listagg(sc) within group(order by n) as sc from swap_case
;
