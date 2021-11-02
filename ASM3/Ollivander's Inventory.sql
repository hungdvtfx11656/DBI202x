select id, age, coins_needed, power
from(
    select W.id, WP.age, W.coins_needed, W.power,
        row_number()
        over(
            partition by W.code, W.power
            order by W.coins_needed, W.power desc
        ) as rn
    from Wands W
    join Wands_Property WP on W.code = WP.code
    where WP.is_evil = 0
) as Wand_Data
where rn = 1
order by power desc, age desc;