with 
base(
    str,
    endstr
) as (
    select 'derek', 'rek' from dual     
),
ends_with as (
    select 
    	case 
    		when substr(str, length(endstr) * -1, length(endstr)) = endstr
    		then 'Yes'
    		else 'No'
    	end as ends_with 
    from
    	base
)
select * from ends_with;