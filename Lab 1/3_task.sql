ALTER TABLE users
ADD COLUMN isadmin INT
CONSTRAINT isadmin_check CHECK (isadmin IN (0, 1));