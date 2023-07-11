with recursive num_to_binary(
	cur_num,
	ibit,
	ibinary,
	next_num
) as (
	select 
		( select v from param ), 
		mod(( select v from param ), 2), 
		mod(( select v from param ), 2)::integer::text, 
		floor( (select v from param)  / 2)
	union all
	select 
		next_num, 
		mod(next_num, 2),  
		mod(next_num, 2)::integer::text || ibinary, 
		floor(next_num / 2)
	from 
		num_to_binary
	where 
		next_num > 0
),
param(v) as ( select 12 )
select ibinary from num_to_binary where next_num = 0;