with 
base as 
    ( select level as n from dual connect by level < 63 ),
grid as 
    ( select y.n as y, x.n as x from base y, base x	),
check_fractals as 
    ( select y, x, case bitand(x, y) when 0 then '**' else '  ' end as s from grid ),
draw as 
    ( select y, listagg(s, '') within group(order by x) as s from check_fractals group by y )
select 
    listagg(s, chr(10)) as st
from 
    draw
;