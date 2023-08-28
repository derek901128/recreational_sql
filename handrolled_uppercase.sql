with
base (s) as 
(
    select 'derek' from dual
),
uppercase 
(
    n,
    s,
    c,
    uc
) as 
(
    select 
    	1, 
    	s, 
    	substr(s, 1, 1), 
    	case 
            when ascii(substr(s, 1, 1)) between 97 and 122 
            then chr(ascii(substr(s, 1, 1)) -  32) 
            else substr(s, 1, 1) 
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
    		then chr(ascii(substr(s, n  + 1, 1)) -  32) 
    		else substr(s, n + 1, 1) 
    	end
	from 
    	uppercase
    where 
		n < length(s)
)
select listagg(uc) within group(order by n) as us from uppercase;
