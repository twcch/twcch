-- STEP 1

SELECT DISTINCT(ITEM), 
        CLAIM_ITEM
    FROM `LP_FBDB/FCLDDTM0`
    WHERE ITEM NOT LIKE 'PCC%'
    GROUP BY ITEM, 
                RGST_CODE,
                CLAIM_ITEM;

-- STEP 2

SELECT T02.RGST_NO,
        T02.ITEM,
        T02.CLAIM_ITEM,
        T02.GIVE_YY,
        T02.GIVE_MM,
        T02.GIVE_DD,
        T02.CNCT_STAT
    FROM 
    (
        SELECT DISTINCT(ITEM), 
                CLAIM_ITEM
            FROM `LP_FBDB/FCLDDTM0`
            WHERE ITEM NOT LIKE 'PCC%'
            GROUP BY ITEM, 
                        RGST_CODE,
                CLAIM_ITEM
    ) AS T01
    LEFT JOIN `LP_FBDB/FCLDDPA0` AS T02
        ON T01.ITEM = T02.ITEM 
            AND T01.CLAIM_ITEM = T02.CLAIM_ITEM
    WHERE T02.RGST_NO <> NULL 
            AND (T02.CNCT_STAT IS NULL 
                    OR T02.CNCT_STAT IN (' ', '01', '02', '03', '04', '05', '06', '07', '16', '20', '25', '27', 'WP'));

-- STEP 3

SELECT S01.RGST_NO,
        S01.ITEM,
        S01.CLAIM_ITEM,
        S01.GIVE_YY,
        S01.GIVE_MM,
        S01.GIVE_DD,
        S01.CNCT_STAT,
        S02.STEP_CODE
    FROM 
    (
        SELECT T02.RGST_NO,
                T02.ITEM,
                T02.CLAIM_ITEM,
                T02.GIVE_YY,
                T02.GIVE_MM,
                T02.GIVE_DD,
                T02.CNCT_STAT
            FROM 
            (
                SELECT DISTINCT(ITEM), 
                        CLAIM_ITEM
                    FROM `LP_FBDB/FCLDDTM0`
                    WHERE ITEM NOT LIKE 'PCC%'
                    GROUP BY ITEM, 
                                RGST_CODE,
                        CLAIM_ITEM
            ) AS T01
            LEFT JOIN `LP_FBDB/FCLDDPA0` AS T02
                ON T01.ITEM = T02.ITEM 
                    AND T01.CLAIM_ITEM = T02.CLAIM_ITEM
            WHERE T02.RGST_NO <> NULL 
                    AND (T02.CNCT_STAT IS NULL 
                            OR T02.CNCT_STAT IN (' ', '01', '02', '03', '04', '05', '06', '07', '16', '20', '25', '27', 'WP'))
    ) AS S01
    LEFT JOIN `LP_FBDB/FCLPRIM0` AS S02
        ON S01.RGST_NO = S02.RGST_NO
    WHERE S02.STEP_CODE <> 'C' AND S02.STEP_CODE <> 'X';