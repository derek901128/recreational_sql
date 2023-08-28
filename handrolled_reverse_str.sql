with
base (s) as 
(
    select 'derek' from dual
),
breakup 
(
    n,
    s,
    c
) as 
(
    select 1, s, substr(s, 1, 1) from base
    union all
    select 
        n + 1, 
        s, 
        substr(s, n + 1, 1) 
    from 
        breakup
    where 
        n < length(s)
),
reversed_str(rs) as 
(
    select 
        listagg(c) within group (order by n desc) 
    from 
        breakup
)
select rs from reversed_str;
