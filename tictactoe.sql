with 
dimensions(dim) as 
( 
    select 
        level 
    from 
        dual 
    connect by 
        level <= 3
),
grid as 
(
    select 
        y.dim as y, 
        x.dim as x
    from 
        dimensions x 
        cross join dimensions y 
),
multi_grids(grid_no, y, x) as 
(
    select 
        1, 
        y, 
        x 
    from 
        grid 
    union all 
    select 
        grid_no + 1, 
        y, 
        x 
    from 
        multi_grids 
    where 
        grid_no < 9
),
moves as 
(
    select
        row_number() over (order by dbms_random.value()) as round_no,
        y, 
        x
    from
        grid
),
rounds as 
(
    select 
        round_no,
        y,
        x,
        case 
            when mod(round_no, 2) = 0 
            then 'O' 
            else 'X' 
        end as player
    from
        moves
),
game_play(game_no, y, x, player) as 
(
    select 
        1,
        a.y,
        a.x,
        b.player
    from 
        multi_grids a
        left join rounds b
            on a.grid_no = b.round_no
            and a.x = b.x
            and a.y = b.y
    where 
        a.grid_no = 1
    union all
    select 
        a.game_no + 1,
        a.y,
        a.x,
        nvl(a.player, b.player)
    from
        game_play a
        left join rounds b
            on a.game_no + 1 = b.round_no
            and a.x = b.x 
            and a.y = b.y 
    where
        a.game_no < 9
),
calculate as 
(
    select 
        * 
    from 
        game_play
    model 
    partition by 
    (
        game_no
    ) 
    dimension by 
    (
        y, 
        x
    )
    measures 
    (
        player,
        case player when 'X' then 1 else 0 end as player_X,
        case player when 'O' then 1 else 0 end as player_O,
        0 as sum_X_1,
        0 as sum_X_2,
        0 as sum_X_3,
        0 as sum_X_4,
        0 as sum_X_5,
        0 as sum_X_6,
        0 as sum_X_7,
        0 as sum_X_8,
        0 as sum_O_1,
        0 as sum_O_2,
        0 as sum_O_3,
        0 as sum_O_4,
        0 as sum_O_5,
        0 as sum_O_6,
        0 as sum_O_7,
        0 as sum_O_8
    )
    rules 
    (
        sum_X_1[1, any] = sum(case player when 'X' then 1 else 0 end)[cv(), x between cv() - 2 and cv() + 2],
        sum_X_2[2, any] = sum(case player when 'X' then 1 else 0 end)[cv(), x between cv() - 2 and cv() + 2],
        sum_X_3[3, any] = sum(case player when 'X' then 1 else 0 end)[cv(), x between cv() - 2 and cv() + 2],
        sum_X_4[any, 1] = sum(case player when 'X' then 1 else 0 end)[y between cv() - 2 and cv() + 2, cv()],
        sum_X_5[any, 2] = sum(case player when 'X' then 1 else 0 end)[y between cv() - 2 and cv() + 2, cv()],
        sum_X_6[any, 3] = sum(case player when 'X' then 1 else 0 end)[y between cv() - 2 and cv() + 2, cv()],
        sum_X_7[2, 2] = player_X[cv()-1, cv()-1] + player_X[cv()+1, cv()+1] + player_X[cv(), cv()],
        sum_X_8[2, 2] = player_X[cv()-1, cv()+1] + player_X[cv()+1, cv()-1] + player_X[cv(), cv()],
        sum_O_1[1, any] = sum(case player when 'O' then 1 else 0 end)[cv(), x between cv() - 2 and cv() + 2],
        sum_O_2[2, any] = sum(case player when 'O' then 1 else 0 end)[cv(), x between cv() - 2 and cv() + 2],
        sum_O_3[3, any] = sum(case player when 'O' then 1 else 0 end)[cv(), x between cv() - 2 and cv() + 2],
        sum_O_4[any, 1] = sum(case player when 'O' then 1 else 0 end)[y between cv() - 2 and cv() + 2, cv()],
        sum_O_5[any, 2] = sum(case player when 'O' then 1 else 0 end)[y between cv() - 2 and cv() + 2, cv()],
        sum_O_6[any, 3] = sum(case player when 'O' then 1 else 0 end)[y between cv() - 2 and cv() + 2, cv()],
        sum_O_7[2, 2] = player_O[cv()-1, cv()-1] + player_O[cv()+1, cv()+1] + player_O[cv(), cv()],
        sum_O_8[2, 2] = player_O[cv()-1, cv()+1] + player_O[cv()+1, cv()-1] + player_O[cv(), cv()]
    )
),
game_result as 
(
    select 
        game_no, 
        y, 
        x, 
        player, 
        max(greatest(sum_X_1, sum_X_2, sum_X_3, sum_X_4, sum_X_5, sum_X_6, sum_X_7, sum_X_8)) over(partition by game_no) as score_X,
        max(greatest(sum_O_1, sum_O_2, sum_O_3, sum_O_4, sum_O_5, sum_O_6, sum_O_7, sum_O_8)) over(partition by game_no) as score_O
    from 
        calculate
),
board as 
(
    select 
        game_no,
        y,
        listagg(case player when 'X' then 'X' when 'O' then 'O' else ' ' end, ' | ') within group (order by x) as grids,
        max(score_X) as score_X,
        max(score_O) as score_O
    from 
        game_result
    group by 
        game_no, 
        y
)
select 
    game_no,
    grids,
    score_X,
    score_O,
    case 
        when 
            (
                first_value(case when score_x = 3 then game_no else 0 end) over(order by score_x desc, game_no) = 0 and 
                first_value(case when score_o = 3 then game_no else 0 end) over(order by score_o desc, game_no) = 0
            )
        then 'Square'
        when 
            ( 
                first_value(case when score_x = 3 then game_no else 0 end) over(order by score_x desc, game_no) < first_value(case when score_o = 3 then game_no else 0 end) over(order by score_o desc, game_no) and 
                first_value(case when score_o = 3 then game_no else 0 end) over(order by score_o desc, game_no) <> 0
            ) or 
            ( 
                first_value(case when score_x = 3 then game_no else 0 end) over(order by score_x desc, game_no) > first_value(case when score_o = 3 then game_no else 0 end) over(order by score_o desc, game_no) and 
                first_value(case when score_o = 3 then game_no else 0 end) over(order by score_o desc, game_no) = 0
            ) 
        then '''X'' wins at Round Number ' || first_value(case when score_x = 3 then game_no else 0 end) over(order by score_x desc, game_no) 
        else '''O'' wins at Round Number ' || first_value(case when score_o = 3 then game_no else 0 end) over(order by score_o desc, game_no) 
    end as game_result
from 
    board 
order by 
    game_no, 
    y
;
