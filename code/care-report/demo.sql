-- STEP 1

SELECT DISTINCT(ITEM), 
        RGST_CODE,
        CLAIM_ITEM
    FROM `LP_FBDB/FCLDDTM0`
    WHERE ITEM NOT LIKE 'PCC%'
    GROUP BY ITEM, 
                RGST_CODE,
                CLAIM_ITEM;

-- STEP 2

SELECT * 
    FROM 
    (
        SELECT DISTINCT(ITEM), 
                RGST_CODE,
                CLAIM_ITEM
            FROM `LP_FBDB/FCLDDTM0`
            WHERE ITEM NOT LIKE 'PCC%'
            GROUP BY ITEM, 
                        RGST_CODE,
                CLAIM_ITEM
    ) AS T01
    LEFT JOIN `LP_FBDB/FCLDDPA0` AS T02
        ON T01.ITEM = T02.ITEM 
            AND T01.CLAIM_ITEM = T02.CLAIM_ITEM;