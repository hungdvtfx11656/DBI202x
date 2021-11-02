with cte as(
    select rank() over(partition by Occupation order by Name) as Rank,
    case when Occupation = 'Doctor' then Name else null end as Doctor,
    case when Occupation = 'Professor' then Name else null end as Professor,
    case when Occupation = 'Singer' then Name else null end as Singer,
    case when Occupation = 'Actor' then Name else null end as Actor
    from Occupations
)
select min(Doctor), min(Professor), min(Singer), min(Actor) from cte
group by Rank