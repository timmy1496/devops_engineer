#!/bin/bash
set -euo pipefail

DB_NAME="SchoolDB"

echo "$DB_NAME"

sudo mysql "$DB_NAME" <<'SQL'
UPDATE Children
SET
  first_name = 'Child',
  last_name  = 'Anonymous';

SET @p := 0;
UPDATE Parents
SET
  first_name = CONCAT('Parent', (@p := @p + 1)),
  last_name  = 'Anon'
ORDER BY parent_id;

SET @i := 0;
UPDATE Institutions
SET
  institution_name = CONCAT('Institution', (@i := @i + 1)),
  address = 'Hidden address'
ORDER BY institution_id;

UPDATE Parents
SET tuition_fee = ROUND(8000 + (RAND() * 8000), 2);

SELECT
  c.child_id,
  c.first_name AS child_first_name,
  c.last_name  AS child_last_name,
  i.institution_name,
  i.address,
  cl.class_name,
  cl.institution_direction,
  p.parent_id,
  p.first_name AS parent_first_name,
  p.last_name  AS parent_last_name,
  p.tuition_fee
FROM Children c
JOIN Institutions i ON i.institution_id = c.institution_id
JOIN Classes cl ON cl.class_id = c.class_id
LEFT JOIN Parents p ON p.child_id = c.child_id
ORDER BY c.child_id, p.parent_id;
SQL

echo "Anonymization completed"
