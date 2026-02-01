SELECT
    c.child_id,
    c.first_name,
    c.last_name,
    i.institution_name,
    i.institution_type,
    cl.class_name,
    cl.institution_direction
FROM Children c
         JOIN Institutions i ON i.institution_id = c.institution_id
         JOIN Classes cl ON cl.class_id = c.class_id
ORDER BY c.child_id;

SELECT
    p.parent_id,
    p.first_name  AS parent_first_name,
    p.last_name   AS parent_last_name,
    c.child_id,
    c.first_name  AS child_first_name,
    c.last_name   AS child_last_name,
    p.tuition_fee
FROM Parents p
         JOIN Children c ON c.child_id = p.child_id
ORDER BY p.parent_id;


SELECT
    i.institution_id,
    i.institution_name,
    i.institution_type,
    i.address,
    COUNT(c.child_id) AS children_count
FROM Institutions i
         LEFT JOIN Children c ON c.institution_id = i.institution_id
GROUP BY i.institution_id, i.institution_name, i.institution_type, i.address
ORDER BY i.institution_id;
