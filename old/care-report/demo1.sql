-- STEP 1

SELECT ITEM 
    FROM `LP_FBDB/FCLDFPL0` 
    WHERE DFYN_TAB LIKE 'N%' 
            AND PL_SOURCE = 'LF';

-- STEP 2

SELECT T01.ITEM,
        T01.CLAIM_ITEM
    FROM 
    (
        SELECT DISTINCT(ITEM),
                CLAIM_ITEM 
            FROM `LP_FBDB/FCLDDTM0`
            GROUP BY ITEM,
                        CLAIM_ITEM
    ) AS T01
    LEFT JOIN 
    (
        SELECT ITEM 
            FROM `LP_FBDB/FCLDFPL0` 
            WHERE DFYN_TAB LIKE 'N%'
                    AND PL_SOURCE = 'LF'
    ) AS T02
        ON T01.ITEM = T02.ITEM
    WHERE T02.ITEM <> NULL;

-- STEP 3

SELECT S02.RGST_NO 
    FROM 
    (
        SELECT T01.ITEM,
                T01.CLAIM_ITEM
            FROM 
            (
                SELECT DISTINCT(ITEM),
                        CLAIM_ITEM 
                    FROM `LP_FBDB/FCLDDTM0`
                    GROUP BY ITEM,
                                CLAIM_ITEM
            ) AS T01
            LEFT JOIN 
            (
                SELECT ITEM 
                    FROM `LP_FBDB/FCLDFPL0` 
                    WHERE DFYN_TAB LIKE 'N%'
                            AND PL_SOURCE = 'LF'
            ) AS T02
                ON T01.ITEM = T02.ITEM
            WHERE T02.ITEM <> NULL
    ) AS S01
    LEFT JOIN `LP_FBDB/FCLDETA0` AS S02
        ON S01.ITEM = S02.ITEM 
            AND S01.CLAIM_ITEM = S02.CLAIM_ITEM
    WHERE S02.CLAIM_STS LIKE 'P%'
            AND (S02.CNCT_STAT = NULL 
            OR S02.CNCT_STAT IN (' ', '01', '02', '03', '04', '05', '06', '07', '16', '20', '25', '27', 'WP'));

-- STEP 4

SELECT * 
    FROM 
    (
        SELECT S02.RGST_NO 
            FROM 
            (
                SELECT T01.ITEM,
                        T01.CLAIM_ITEM
                    FROM 
                    (
                        SELECT DISTINCT(ITEM),
                                CLAIM_ITEM 
                            FROM `LP_FBDB/FCLDDTM0`
                            GROUP BY ITEM,
                                        CLAIM_ITEM
                    ) AS T01
                    LEFT JOIN 
                    (
                        SELECT ITEM 
                            FROM `LP_FBDB/FCLDFPL0` 
                            WHERE DFYN_TAB LIKE 'N%'
                                    AND PL_SOURCE = 'LF'
                    ) AS T02
                        ON T01.ITEM = T02.ITEM
                    WHERE T02.ITEM <> NULL
            ) AS S01
            LEFT JOIN `LP_FBDB/FCLDETA0` AS S02
                ON S01.ITEM = S02.ITEM 
                    AND S01.CLAIM_ITEM = S02.CLAIM_ITEM
            WHERE S02.CLAIM_STS LIKE 'P%'
                    AND (S02.CNCT_STAT = NULL 
                    OR S02.CNCT_STAT IN (' ', '01', '02', '03', '04', '05', '06', '07', '16', '20', '25', '27', 'WP'))
    ) AS M01
    LEFT JOIN `LP_FBDB/FCLPRIM0` AS M02
        ON M01.RGST_NO = M02.RGST_NO
    WHERE M02.STEP_CODE = 'S';

