SELECT 'Institutions' AS tbl, COUNT(*) AS cnt FROM SchoolDB_Restore.Institutions
UNION ALL
SELECT 'Classes', COUNT(*) FROM SchoolDB_Restore.Classes
UNION ALL
SELECT 'Children', COUNT(*) FROM SchoolDB_Restore.Children
UNION ALL
SELECT 'Parents', COUNT(*) FROM SchoolDB_Restore.Parents;

SELECT
    TABLE_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'SchoolDB_Restore'
  AND REFERENCED_TABLE_NAME IS NOT NULL;

USE SchoolDB_Restore;

SELECT
    c.child_id, c.first_name, c.last_name,
    i.institution_name, cl.direction
FROM Children c
         JOIN Institutions i ON i.institution_id = c.institution_id
         JOIN Classes cl ON cl.class_id = c.class_id;
