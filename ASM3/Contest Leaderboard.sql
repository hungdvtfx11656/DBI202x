with t as(
    select hacker_id, max(score) as score
    from submissions
    group by hacker_id, challenge_id
)
select t.hacker_id, h.name, sum(t.score)
from t
join hackers h on t.hacker_id = h.hacker_id
having sum(score) > 0
order by sum(score)
group by t.hacker_id, h.name
