select s.hacker_id, H.name
from Submissions as s
    join Hackers as h on s.hacker_id = h.hacker_id
    join Challenges as c on s.challenge_id = c.challenge_id
    join Difficulty as d on c.difficulty_level = d.difficulty_level
where s.score = d.score
and c.difficulty_level = d.difficulty_level
group by s.hacker_id, h.name
having count(s.hacker_id) > 1
order by count(s.hacker_id) desc, s.hacker_id;