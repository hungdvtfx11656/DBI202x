select s.name
from Students as s
    join Friends as f on s.id = f.id
    join Packages as p1 on f.id = p1.id
    join Packages as p2 on f.friend_id = p2.id
where p1.salary < p2.salary
order by p2.salary;