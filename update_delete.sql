\c military_db

\echo "list flying_object weapon types"

SELECT * FROM flying_object_weapon_type;

\echo "one of them was renamed weapon_0 -> bomb, let's update"

UPDATE flying_object_weapon_type
SET name = 'bomb'
WHERE name = 'weapon_0';

SELECT * FROM flying_object_weapon_type;

\echo "Then bomb was decommissioned, let's delete it"

DELETE FROM flying_object_weapon_type
WHERE name = 'bomb';

SELECT * FROM flying_object_weapon_type;
