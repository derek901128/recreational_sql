with
parameters(row_count, background, paddings) as 
(
	select 30, '\s', '*' from dual
),
shape(lvl, s) as 
(
    select 
    	1,     
		regexp_replace
    	(
    		rpad(' ', ( select row_count * 2 - 1 from parameters ), ' '),
    		( select background from parameters ),
    		( select paddings from parameters ),
    		( select row_count from parameters ),
    		1
        )
    from
    	dual
    union all 
    select 
    	lvl + 1,     
    	case 
    		when lvl < ( select row_count from parameters ) / 3
    		then 
            	regexp_replace
            	( 
            		regexp_replace
            		(
            			s, 
              			( select background from parameters ), 
            			( select paddings from parameters ), 
            			( select row_count from parameters ) + lvl * 2, 
            			1
            		),
                    ( select background from parameters ), 
                    ( select paddings from parameters ), 
                    ( select row_count from parameters ) - lvl * 2, 
                    1
            	)
			else 
    			regexp_replace
    			(
    				regexp_replace
        			(
                        s,
                        '\*',
                        ' ',
                        1,
                        regexp_count(s, '\*')
                    ),
    				'\*',
    				' ',
    				1,
    				1
                )
			end
    from
    	shape
    where 
    	lvl < ( select row_count from parameters )
)
select listagg(s, chr(10)) as t  from shape where trim(s) is not null;