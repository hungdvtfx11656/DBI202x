select f1.X, f1.Y
from Functions f1
join Functions f2 on f1.X = f2.Y and f1.Y = f2.X
group by f1.X, f1.Y
having count(f1.x) > 1 or f1.X < f1.Y
order by f1.X;