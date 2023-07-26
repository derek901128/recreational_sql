with 
"parameters"(input_str, repeat_times, delim) as (select 'derek', 7, '|' from dual),
"output"(output_str) as (
	select 
    	rpad(input_str, length(delim || input_str) * repeat_times - 1, delim || input_str) 
    from 
    	"parameters"
)
select output_str from "output";