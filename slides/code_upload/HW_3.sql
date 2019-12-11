-- 第一题
SELECT stu.stu_name AS 学生姓名, MIN(grade) AS 最低分 FROM stu CROSS JOIN enroll ON stu.stu_id = enroll.stu_id WHERE stu.birth_year IN (SELECT zodiac_year FROM zodiac WHERE zodiac_name LIKE '龙_') GROUP BY stu.stu_name;
-- 第二题
-- 通过嵌套子查询的方式，先在子查询中查出所有人的相关课程各自的平均分，外层的查询就只需要加一个比这些分都高的条件就可以
-- 这个查询的问题在于要求学生不重名
SELECT stu.stu_name AS 学生姓名, AVG(grade) AS 平均分 FROM stu,enroll,course WHERE stu.stu_id = enroll.stu_id AND course.course_id = enroll.course_id AND course_name LIKE '%数据%' GROUP BY stu.stu_name HAVING 平均分 >= ALL(SELECT AVG(grade) FROM enroll CROSS JOIN course ON course.course_id = enroll.course_id WHERE course_name LIKE '%数据%' GROUP BY stu_id);

-- 下面这个是完整的语句，但是MySQL版本问题，不支持WITH 语句
-- 先用WITH语句创建一个临时表table1（查询完后自动删除），然后联接table1和stu查询出姓名
-- WITH table1 AS (SELECT stu.stu_id AS 学号, AVG(grade) AS 平均分 FROM stu,enroll,course WHERE stu.stu_id = enroll.stu_id AND course.course_id = enroll.course_id AND course_name LIKE '%数据%' GROUP BY stu.stu_id HAVING 平均分 >= ALL(SELECT AVG(grade) FROM enroll CROSS JOIN course ON course.course_id = enroll.course_id WHERE course_name LIKE '%数据%' GROUP BY stu_id) SELECT stu.stu_name AS 学生姓名, 平均分 FROM stu JOIN table1 ON stu.stu_id = table1.学号;