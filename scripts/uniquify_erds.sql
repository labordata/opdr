BEGIN;

CREATE TABLE ar_erds_codes_unique AS SELECT DISTINCT
    *
FROM
    ar_erds_codes
WHERE
    "CODE_TYPE" NOT IN ('SCHEDULE_CODE', 'STATE_CODE', 'EFS_LETTER_SIGNER', 'EFS_LOGIN_STATUS');

DROP TABLE ar_erds_codes;

ALTER TABLE ar_erds_codes_unique RENAME TO ar_erds_codes;

COMMIT;

