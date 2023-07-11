with recursive reverse_number(
	num, 
	next_num,
	reversed,
	cur_div,
	next_div
) as (
	select 
		( select v from param ),
		( select v from param ) - mod(( select v from param ), 10),
		mod(( select v from param ), 10)::text,
		10,
		10 * 10
	union all
	select 
		next_num, 
		next_num - mod(next_num, next_div),
		reversed || (mod(next_num, next_div) / cur_div)::text,
		next_div,
		next_div * 10
	from 
		reverse_number
	where 
		next_num / cur_div  > 0

),
param(v) as ( select 342019 )
select reversed from reverse_number where next_num = 0
;