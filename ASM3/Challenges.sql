with s as (
    select c.hacker_id as id, h.name as name, count(c.hacker_id) as counter
    from Hackers h
    join Challenges c on c.hacker_id = h.hacker_id
    group by c.hacker_id, h.name
)
select id, name, counter
from s
where counter = (select max(counter) from s)
or counter in (
    select counter from s
    group by counter
    having count(counter) = 1
)
order by counter desc, id;