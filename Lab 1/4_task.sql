ALTER TABLE users DROP CONSTRAINT isadmin_check;

ALTER TABLE users
ALTER COLUMN isadmin TYPE boolean
USING (isadmin = 1);