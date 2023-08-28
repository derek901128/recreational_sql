with 
para (v) as ( select 123 from dual ),
reverse_num
(
    row_num,
    cur_num,
    next_num,
    remaining,
    pos,
    cur_div,
    next_div
) as 
(
    select
        1,
        ( select abs(v) from para ),
        ( select abs(v) from para ) - mod(( select abs(v) from para ), 10),
        mod(( select abs(v) from para ), 10),
        1,
        10,
        10 * 10
    from
        dual
    union all
    select 
        row_num + 1,
        next_num,
        next_num - mod(next_num, next_div),
        mod(next_num, next_div) / cur_div,
        pos * 10,
        next_div,
        next_div * 10
    from 
        reverse_num
    where
        floor(next_num / cur_div) > 0
),
reversed(i_reversed) as 
(
    select 
        sum(a.remaining * b.pos)
    from 
        reverse_num a
        join
            ( select row_number()over(order by row_num desc) as row_num, pos from reverse_num ) b 
            on a.row_num = b.row_num
),
num_to_binary
(
    i_reversed,
    cur_num,
    next_num,
    i_bit,
    i_binary,
    bin_cnt
) as 
(
    select 
        i_reversed,
        i_reversed,
        floor(i_reversed / 2),
        mod(i_reversed, 2),
        to_char(mod(i_reversed, 2) ),
        1
    from 
        reversed
    union all
    select 
        i_reversed,
        next_num,
        floor(next_num / 2),
        mod(next_num, 2),
        to_char(mod(next_num, 2)) || i_binary,
        bin_cnt + 1
    from 
        num_to_binary
    where
        next_num >  0
),
solution as 
(
    select 
        case 
            when bin_cnt > 32 
            then 0
            when ( select v from para ) < 0 
            then i_reversed * -1
            else i_reversed
        end as i_reversed, 
        i_binary, 
        bin_cnt 
    from 
        num_to_binary 
    where 
        next_num = 0
)
select * from solution;
