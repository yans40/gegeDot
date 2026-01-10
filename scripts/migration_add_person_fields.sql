-- Migration SQL pour ajouter les nouveaux champs à la table Persons
-- Date: 2026-01-10
-- Description: Ajout des champs Profession, MarriageDate, MarriagePlace, DeathStatus

-- Vérifier si les colonnes n'existent pas déjà avant de les ajouter
SET @dbname = DATABASE();
SET @tablename = "Persons";
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (TABLE_SCHEMA = @dbname)
      AND (TABLE_NAME = @tablename)
      AND (COLUMN_NAME = "Profession")
  ) > 0,
  "SELECT 'Column Profession already exists' AS result;",
  "ALTER TABLE Persons ADD COLUMN Profession VARCHAR(100) NULL AFTER DeathPlace;"
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (TABLE_SCHEMA = @dbname)
      AND (TABLE_NAME = @tablename)
      AND (COLUMN_NAME = "MarriageDate")
  ) > 0,
  "SELECT 'Column MarriageDate already exists' AS result;",
  "ALTER TABLE Persons ADD COLUMN MarriageDate DATETIME NULL AFTER Profession;"
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (TABLE_SCHEMA = @dbname)
      AND (TABLE_NAME = @tablename)
      AND (COLUMN_NAME = "MarriagePlace")
  ) > 0,
  "SELECT 'Column MarriagePlace already exists' AS result;",
  "ALTER TABLE Persons ADD COLUMN MarriagePlace VARCHAR(200) NULL AFTER MarriageDate;"
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (TABLE_SCHEMA = @dbname)
      AND (TABLE_NAME = @tablename)
      AND (COLUMN_NAME = "DeathStatus")
  ) > 0,
  "SELECT 'Column DeathStatus already exists' AS result;",
  "ALTER TABLE Persons ADD COLUMN DeathStatus VARCHAR(50) NULL AFTER MarriagePlace;"
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Afficher un message de confirmation
SELECT 'Migration completed successfully! New columns added: Profession, MarriageDate, MarriagePlace, DeathStatus' AS result;
