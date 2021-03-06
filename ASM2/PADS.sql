SELECT CONCAT(NAME,'(',LEFT(Occupation,1),')')
FROM OCCUPATIONS
ORDER BY NAME;

SELECT CONCAT('There are a total of ',COUNT(1),' ',LOWER(Occupation),'s.') AS TOTAL
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY TOTAL;