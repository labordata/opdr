UPDATE
    lm_data
SET
    next_election = trim(next_election);

UPDATE
    lm_data
SET
    next_election = NULL
WHERE
    next_election = '';

UPDATE
    lm_data
SET
    next_election = replace(next_election, '  ', ' ');

UPDATE
    lm_data
SET
    next_election = replace(next_election, '  ', ' ');

UPDATE
    lm_data
SET
    next_election = replace(next_election, '  ', ' ');

UPDATE
    lm_data
SET
    next_election = replace(replace(next_election, ' /', '/'), '/ ', '/');

UPDATE
    lm_data
SET
    next_election = replace(replace(next_election, ' -', '-'), '- ', '-');

UPDATE
    lm_data
SET
    next_election = replace(replace(next_election, ' ,', ','), ', ', ',');

-- This loses a precision for dates written like 'December 10, 2021', these
-- will turn into 2021-12
UPDATE
    lm_data
SET
    next_election = CASE WHEN next_election GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]'
        OR next_election GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]' THEN
        next_election
    WHEN next_election NOT GLOB '*[1-9]*' THEN
        NULL
    WHEN next_election = 0 THEN
        NULL
    WHEN next_election LIKE '%SEE%' THEN
        NULL
    WHEN next_election NOT GLOB '*[^0-9]*' THEN
        CASE WHEN length(next_election) = 8 THEN
            substr(next_election, 5, 4) || '-' || substr(next_election, 1, 2) || '-' || substr(next_election, 3, 2)
        WHEN length(next_election) = 6 THEN
            substr(next_election, 3, 4) || '-' || substr(next_election, 1, 2)
        WHEN length(next_election) = 5 THEN
            substr(next_election, 2, 4) || '-0' || substr(next_election, 1, 1)
        WHEN length(next_election) = 4
            AND substr(next_election, 1, 2)
            NOT IN ('19', '20') THEN
            CASE WHEN substr(next_election, 3, 2) > '50' THEN
                '19' || substr(next_election, 3, 2) || '-' || substr(next_election, 1, 2)
            ELSE
                '20' || substr(next_election, 3, 2) || '-' || substr(next_election, 1, 2)
            END
        WHEN length(next_election) = 4
            AND substring(next_election, 1, 2) IN ('19', '20') THEN
            next_election
        WHEN length(next_election) = 3 THEN
            CASE WHEN substr(next_election, 2, 2) > '50' THEN
                '19' || substr(next_election, 2, 2) || '-0' || substr(next_election, 1, 1)
            ELSE
                '20' || substr(next_election, 2, 2) || '-0' || substr(next_election, 1, 1)
            END
        WHEN length(next_election) = 2 THEN
            CASE WHEN next_election > '50' THEN
                '19' || next_election
            ELSE
                '20' || next_election
            END
        ELSE
            NULL
        END
    WHEN next_election GLOB '[0-9][0-9][^0-9][0-9][0-9][0-9][0-9]' THEN
        substr(next_election, 4, 4) || '-' || substr(next_election, 1, 2)
    WHEN next_election GLOB '[0-9][^0-9][0-9][0-9][0-9][0-9]' THEN
        substr(next_election, 3, 4) || '-0' || substr(next_election, 1, 1)
    WHEN next_election GLOB '[0-9][0-9][^0-9][0-9][0-9]' THEN
        CASE WHEN substr(next_election, 4, 2) > '50' THEN
            '19' || substr(next_election, 4, 2) || '-' || substr(next_election, 1, 2)
        ELSE
            '20' || substr(next_election, 4, 2) || '-' || substr(next_election, 1, 2)
        END
    WHEN next_election GLOB '[0-9][^0-9][0-9][0-9]' THEN
        CASE WHEN substr(next_election, 3, 2) > '50' THEN
            '19' || substr(next_election, 3, 2) || '-0' || substr(next_election, 1, 1)
        ELSE
            '20' || substr(next_election, 3, 2) || '-0' || substr(next_election, 1, 1)
        END
    WHEN next_election GLOB '[0-9][0-9][^0-9][0-9][0-9][^0-9][0-9][0-9][0-9][0-9]' THEN
        substr(next_election, 7, 4) || '-' || substr(next_election, 1, 2) || '-' || substr(next_election, 4, 2)
    WHEN next_election GLOB '[0-9][^0-9][0-9][0-9][^0-9][0-9][0-9][0-9][0-9]' THEN
        substr(next_election, 6, 4) || '-0' || substr(next_election, 1, 1) || '-' || substr(next_election, 3, 2)
    WHEN next_election GLOB '[0-9][0-9][^0-9][0-9][^0-9][0-9][0-9][0-9][0-9]' THEN
        substr(next_election, 6, 4) || '-' || substr(next_election, 1, 2) || '-0' || substr(next_election, 4, 1)
    WHEN next_election GLOB '[0-9][^0-9][0-9][^0-9][0-9][0-9][0-9][0-9]' THEN
        substr(next_election, 5, 4) || '-0' || substr(next_election, 1, 1) || '-0' || substr(next_election, 3, 1)
    WHEN next_election GLOB '[0-9][0-9][^0-9][0-9][0-9][^0-9][0-9][0-9]' THEN
        CASE WHEN substr(next_election, 7, 2) > '50' THEN
            '19' || substr(next_election, 7, 2) || '-' || substr(next_election, 1, 2) || '-' || substr(next_election, 4, 2)
        ELSE
            '20' || substr(next_election, 7, 2) || '-' || substr(next_election, 1, 2) || '-' || substr(next_election, 4, 2)
        END
    WHEN next_election GLOB '[0-9][^0-9][0-9][0-9][^0-9][0-9][0-9]' THEN
        CASE WHEN substr(next_election, 6, 2) > '50' THEN
            '19' || substr(next_election, 6, 2) || '-0' || substr(next_election, 1, 1) || '-' || substr(next_election, 3, 2)
        ELSE
            '20' || substr(next_election, 6, 2) || '-0' || substr(next_election, 1, 1) || '-' || substr(next_election, 3, 2)
        END
    WHEN next_election GLOB '[0-9][0-9][^0-9][0-9][^0-9][0-9][0-9]' THEN
        CASE WHEN substr(next_election, 6, 2) > '50' THEN
            '19' || substr(next_election, 6, 2) || '-' || substr(next_election, 1, 2) || '-0' || substr(next_election, 4, 1)
        ELSE
            '20' || substr(next_election, 6, 2) || '-' || substr(next_election, 1, 2) || '-0' || substr(next_election, 4, 1)
        END
    WHEN next_election GLOB '[0-9][^0-9][0-9][^0-9][0-9][0-9]' THEN
        CASE WHEN substr(next_election, 5, 2) > '50' THEN
            '19' || substr(next_election, 5, 2) || '-0' || substr(next_election, 1, 1) || '-0' || substr(next_election, 3, 1)
        ELSE
            '20' || substr(next_election, 5, 2) || '-0' || substr(next_election, 1, 1) || '-0' || substr(next_election, 3, 1)
        END
    WHEN lower(next_election) GLOB 'jan*[0-9][0-9][0-9][0-9]' THEN
        substr(next_election, length(next_election) - 4 + 1, 4) || '-01'
    WHEN lower(next_election) GLOB 'feb*[0-9][0-9][0-9][0-9]' THEN
        substr(next_election, length(next_election) - 4 + 1, 4) || '-02'
    WHEN lower(next_election) GLOB 'mar*[0-9][0-9][0-9][0-9]' THEN
        substr(next_election, length(next_election) - 4 + 1, 4) || '-03'
    WHEN lower(next_election) GLOB 'apr*[0-9][0-9][0-9][0-9]' THEN
        substr(next_election, length(next_election) - 4 + 1, 4) || '-04'
    WHEN lower(next_election) GLOB 'may*[0-9][0-9][0-9][0-9]' THEN
        substr(next_election, length(next_election) - 4 + 1, 4) || '-05'
    WHEN lower(next_election) GLOB 'jun*[0-9][0-9][0-9][0-9]' THEN
        substr(next_election, length(next_election) - 4 + 1, 4) || '-06'
    WHEN lower(next_election) GLOB 'jul*[0-9][0-9][0-9][0-9]' THEN
        substr(next_election, length(next_election) - 4 + 1, 4) || '-07'
    WHEN lower(next_election) GLOB 'aug*[0-9][0-9][0-9][0-9]' THEN
        substr(next_election, length(next_election) - 4 + 1, 4) || '-08'
    WHEN lower(next_election) GLOB 'sep*[0-9][0-9][0-9][0-9]' THEN
        substr(next_election, length(next_election) - 4 + 1, 4) || '-09'
    WHEN lower(next_election) GLOB 'oct*[0-9][0-9][0-9][0-9]' THEN
        substr(next_election, length(next_election) - 4 + 1, 4) || '-10'
    WHEN lower(next_election) GLOB 'nov*[0-9][0-9][0-9][0-9]' THEN
        substr(next_election, length(next_election) - 4 + 1, 4) || '-11'
    WHEN lower(next_election) GLOB 'dec*[0-9][0-9][0-9][0-9]' THEN
        substr(next_election, length(next_election) - 4 + 1, 4) || '-12'
    WHEN lower(next_election) GLOB 'jan*[0-9][0-9]' THEN
        CASE WHEN substr(next_election, length(next_election) - 2 + 1, 2) > '50' THEN
            '19' || substr(next_election, length(next_election) - 2 + 1, 2) || '-01'
        ELSE
            '20' || substr(next_election, length(next_election) - 2 + 1, 2) || '-01'
        END
    WHEN lower(next_election) GLOB 'feb*[0-9][0-9]' THEN
        CASE WHEN substr(next_election, length(next_election) - 2 + 1, 2) > '50' THEN
            '19' || substr(next_election, length(next_election) - 2 + 1, 2) || '-02'
        ELSE
            '20' || substr(next_election, length(next_election) - 2 + 1, 2) || '-02'
        END
    WHEN lower(next_election) GLOB 'mar*[0-9][0-9]' THEN
        CASE WHEN substr(next_election, length(next_election) - 2 + 1, 2) > '50' THEN
            '19' || substr(next_election, length(next_election) - 2 + 1, 2) || '-03'
        ELSE
            '20' || substr(next_election, length(next_election) - 2 + 1, 2) || '-03'
        END
    WHEN lower(next_election) GLOB 'apr*[0-9][0-9]' THEN
        CASE WHEN substr(next_election, length(next_election) - 2 + 1, 2) > '50' THEN
            '19' || substr(next_election, length(next_election) - 2 + 1, 2) || '-04'
        ELSE
            '20' || substr(next_election, length(next_election) - 2 + 1, 2) || '-04'
        END
    WHEN lower(next_election) GLOB 'may*[0-9][0-9]' THEN
        CASE WHEN substr(next_election, length(next_election) - 2 + 1, 2) > '50' THEN
            '19' || substr(next_election, length(next_election) - 2 + 1, 2) || '-05'
        ELSE
            '20' || substr(next_election, length(next_election) - 2 + 1, 2) || '-05'
        END
    WHEN lower(next_election) GLOB 'jun*[0-9][0-9]' THEN
        CASE WHEN substr(next_election, length(next_election) - 2 + 1, 2) > '50' THEN
            '19' || substr(next_election, length(next_election) - 2 + 1, 2) || '-06'
        ELSE
            '20' || substr(next_election, length(next_election) - 2 + 1, 2) || '-06'
        END
    WHEN lower(next_election) GLOB 'jul*[0-9][0-9]' THEN
        CASE WHEN substr(next_election, length(next_election) - 2 + 1, 2) > '50' THEN
            '19' || substr(next_election, length(next_election) - 2 + 1, 2) || '-07'
        ELSE
            '20' || substr(next_election, length(next_election) - 2 + 1, 2) || '-07'
        END
    WHEN lower(next_election) GLOB 'aug*[0-9][0-9]' THEN
        CASE WHEN substr(next_election, length(next_election) - 2 + 1, 2) > '50' THEN
            '19' || substr(next_election, length(next_election) - 2 + 1, 2) || '-08'
        ELSE
            '20' || substr(next_election, length(next_election) - 2 + 1, 2) || '-08'
        END
    WHEN lower(next_election) GLOB 'sep*[0-9][0-9]' THEN
        CASE WHEN substr(next_election, length(next_election) - 2 + 1, 2) > '50' THEN
            '19' || substr(next_election, length(next_election) - 2 + 1, 2) || '-09'
        ELSE
            '20' || substr(next_election, length(next_election) - 2 + 1, 2) || '-09'
        END
    WHEN lower(next_election) GLOB 'oct*[0-9][0-9]' THEN
        CASE WHEN substr(next_election, length(next_election) - 2 + 1, 2) > '50' THEN
            '19' || substr(next_election, length(next_election) - 2 + 1, 2) || '-10'
        ELSE
            '20' || substr(next_election, length(next_election) - 2 + 1, 2) || '-10'
        END
    WHEN lower(next_election) GLOB 'nov*[0-9][0-9]' THEN
        CASE WHEN substr(next_election, length(next_election) - 2 + 1, 2) > '50' THEN
            '19' || substr(next_election, length(next_election) - 2 + 1, 2) || '-11'
        ELSE
            '20' || substr(next_election, length(next_election) - 2 + 1, 2) || '-11'
        END
    WHEN lower(next_election) GLOB 'dec*[0-9][0-9]' THEN
        CASE WHEN substr(next_election, length(next_election) - 2 + 1, 2) > '50' THEN
            '19' || substr(next_election, length(next_election) - 2 + 1, 2) || '-12'
        ELSE
            '20' || substr(next_election, length(next_election) - 2 + 1, 2) || '-12'
        END
    ELSE
        NULL
    END;

UPDATE
    lm_data
SET
    next_election = NULL
WHERE
    cast(substr(next_election, 1, 4) AS int) - yr_covered > 15;

