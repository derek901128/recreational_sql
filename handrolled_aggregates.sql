with 
base(row_no, n) as (
    select 
        rownum, 
        level 
    from 
        dual 
    connect by 
        level <= 10
),
find_max(
    lvl, 
    cur_val, 
    prev_val, 
    max_so_far,
    min_so_far,
    sum_so_far,
    count_so_far,
    avg_so_far
) as (
  select 
    	1,
    	n,
    	null,
    	n,
    	n,
    	n,
    	1,
    	n / 1
	from
    	base
    where
    	row_no = 1
    union all
    select
	fm.lvl + 1,
    	b.n,
    	fm.cur_val, 
    	case when b.n > fm.max_so_far then b.n else fm.max_so_far end,
    	case when b.n < fm.min_so_far then b.n else fm.min_so_far end,
    	b.n + fm.sum_so_far,
  	fm.count_so_far + 1,
    	(b.n + fm.sum_so_far) / (fm.count_so_far + 1)
    from 
    	find_max fm
	join	
    	base b
	on
    	fm.lvl + 1 = b.row_no
    where
    	fm.lvl + 1 <= ( select max(row_no) from base )
)
select 
    max_so_far as max_final,
    min_so_far as min_final,
    sum_so_far as sum_final,
    count_so_far as count_final,
    avg_so_far as average_final
from 
    find_max
where 
    lvl = ( select max(lvl) from find_max )
;
