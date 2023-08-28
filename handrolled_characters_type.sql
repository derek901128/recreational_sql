with 
base(s) as 
(
    select 'derek' from dual
),
char_nature
(
    n,
    s,
    c,
    ct
) as (
    select 
        1, 
        s, 
        substr(s, 1, 1), 
        case 
        	when ascii(substr(s, 1, 1)) between 48 and 57
        	then 'is_numeric'
        	when ascii(substr(s, 1, 1)) between 65 and 90 or ascii(substr(s, 1, 1)) between 97 and 122
        	then 'is_alpha'
    		when ascii(substr(s, 1, 1)) = 32
    		then 'is_space'
    		when ascii(substr(s, 1, 1)) <= 126
    		then 'is_puntucation'
        	else 'others'
        end
    from
    	base
    union all
    select 
        n + 1, 
        s, 
        substr(s, n + 1, 1), 
        case 
        	when ascii(substr(s, n + 1, 1)) between 48 and 57
        	then 'is_numeric'
        	when ascii(substr(s, n + 1, 1)) between 65 and 90 or ascii(substr(s, n + 1, 1)) between 97 and 122
        	then 'is_alpha'
    		when ascii(substr(s, n + 1, 1)) = 32  
    		then 'is_space'
    		when ascii(substr(s, n + 1, 1)) <= 126
    		then 'is_puntucation'
        	else 'others'
        end
    from
 		char_nature
    where
    	n < length(s)
)
select ct from char_nature group by ct having count(*) = (select count(*) from char_nature );
