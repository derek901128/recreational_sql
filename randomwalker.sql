with 
param(no_of_dimensions, no_of_moves) as 
(
    select 
        10,     -- decide the size the grid
        100     -- decide how many moves there will be
    from
        dual
),
dimensions(dim) as 
(
    select
        level 
    from 
        dual 
    connect by 
        level <= ( select no_of_dimensions from param )
),
grids(y, x) as 
(
    select 
        y.dim,
        x.dim
    from
        dimensions y
        cross join dimensions x
),
multi_grid(grid_no, y, x) as 
(
    select 
        1, y, x
    from 
        grids 
    union all
    select 
        grid_no + 1, y, x
    from 
        multi_grid 
    where 
        grid_no < ( select no_of_moves from param )
),
random_first(y, x) as 
(
    select 
        floor(dbms_random.value(1, ( select no_of_dimensions from param ) + 1 )),
        floor(dbms_random.value(1, ( select no_of_dimensions from param ) + 1 ))
    from 
        dual
),
moves(step_no, yx) as 
(
    select 
        level,
        decode
        (
            floor(dbms_random.value(1, 9)), 
            1, '10',
            2, '-01',
            3, '01',
            4, '0-1',
            5, '11',
            6, '-1-1',
            7, '-11',
            8, '1-1'
        )
    from
        dual
    connect by 
        level <= ( select no_of_moves from param )
),
new_pos(step_no, cur_y, cur_x, next_y, next_x, footprint) as (
    select 
        0, 
        0, 
        0,
        ( select y from random_first ),
        ( select x from random_first ),
        1
    from
        dual
    union all
    select
        new_pos.step_no + 1,
        new_pos.next_y,
        new_pos.next_x,
        case new_pos.next_y
            when ( select no_of_dimensions from param ) 
            then new_pos.next_y - abs(to_number(regexp_substr(moves.yx, '-?\d{1}', 1, 1)))
            when 1 
            then new_pos.next_y + abs(to_number(regexp_substr(moves.yx, '-?\d{1}', 1, 1)))
            else new_pos.next_y + to_number(regexp_substr(moves.yx, '-?\d{1}', 1, 1))
        end,
            case new_pos.next_x
            when ( select no_of_dimensions from param ) 
            then new_pos.next_x - abs(to_number(regexp_substr(moves.yx, '-?\d{1}', 1, 2)))
            when 1 
            then new_pos.next_x + abs(to_number(regexp_substr(moves.yx, '-?\d{1}', 1, 2)))
            else new_pos.next_x + to_number(regexp_substr(moves.yx, '-?\d{1}', 1, 2))
        end,
        footprint
    from
        new_pos
        left join moves
            on new_pos.step_no + 1 = moves.step_no
    where
        new_pos.step_no < ( select no_of_moves from param )
),
random_walker(step_no, y, x, footprint) as
(
    select 
        1, 
        multi_grid.y, 
        multi_grid.x,
        new_pos.footprint
    from 
        multi_grid
        left join new_pos
            on new_pos.step_no = multi_grid.grid_no
            and multi_grid.x = new_pos.next_x
            and multi_grid.y = new_pos.next_y
    where
        multi_grid.grid_no = 1
    union all
    select 
        random_walker.step_no + 1, 
        random_walker.y, 
        random_walker.x,
        nvl(random_walker.footprint, new_pos.footprint)
    from 
        random_walker
        left join new_pos
            on new_pos.step_no = random_walker.step_no + 1
            and random_walker.x = new_pos.next_x
            and random_walker.y = new_pos.next_y
    where
        random_walker.step_no < ( select no_of_moves from param )
),
board as (
    select
        step_no,
        y,
        listagg(case footprint when 1 then ' X ' else '---' end, ' ') within group (order by x) as walkpath
    from
        random_walker
    group by
        step_no,
        y
    union all
    select 
        level + 0.1, 
        11,
        '> > > > > > > > > > ' || level || ' < < < < < < < < < <' 
    from 
        dual 
    connect by 
        level <= ( select no_of_moves from param )
)
select walkpath from board order by step_no, y
;
