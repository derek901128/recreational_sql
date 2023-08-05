with
parameters(row_count, background, paddings) as 
(
	select 
    	20,
    	'\s', 
    	'*'
    from 
    	dual
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
    	regexp_replace
    	( 
    		regexp_replace
    		(
    			s, 
      			( select background from parameters ), 
    			( select paddings from parameters ), 
    			( select row_count from parameters ) + lvl, 
    			1
    		),
            ( select background from parameters ), 
            ( select paddings from parameters ), 
            ( select row_count from parameters ) - lvl, 
            1
    	)
    from
    	shape
    where 
    	lvl < ( select row_count from parameters )
)
select listagg(s, chr(10)) as t from shape;