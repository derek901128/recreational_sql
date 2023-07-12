with 
para (w_cnt, l_cnt) as( select 100, 500 from dual ),
generate_letters(word_id, letter_lvl, letter) as (
    select 
        floor(dbms_random.value(1, ( select w_cnt from para ))),
        level,
        chr(floor(dbms_random.value(97, 123)))
    from 
        dual
    connect by 
        level <= ( select l_cnt from para )
),
form_words as (
    select 
        word_id,
        listagg(letter) within group(order by letter_lvl) as word,
        count(letter) as word_len
    from
        generate_letters
    group by
        word_id
),
len_distrib as (
    select 
        word_len,
        count(word_len) as len_freq,
        lpad('*', count(word_len), '*') as bar
    from
        form_words
    group by
        word_len
)
select * from len_distrib order by word_len;