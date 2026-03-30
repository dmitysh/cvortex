-- +goose Up
ALTER TABLE candidate ADD COLUMN type SMALLINT;
UPDATE candidate SET type = 1 WHERE type IS NULL;
ALTER TABLE candidate ALTER COLUMN type SET NOT NULL;

-- +goose Down
ALTER TABLE candidate DROP COLUMN type;
