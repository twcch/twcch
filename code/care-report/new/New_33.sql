SELECT DISTINCT(prim.RGST_NO),
                deta2.POLICY_NO,
                deta2.POLICY_SEQ,
                deta2.ID_DUP,
                prim.ACCID_ID,
                prim.ACCID_NAME,
                (prim.ACDN_YY * 10000 + prim.ACDN_MM * 100 + prim.ACDN_DD) AS ACDN_DATE,
                accd.ACCD_DATE,
                lastday.lastdate,
                lastday.ITEM,
                CASE WHEN ride.CNCT_STAT IS NULL THEN fhsf.CNCT_STAT ELSE ride.CNCT_STAT END AS cnst,
                deta2.CLAIM_ITEM,
                item.CLAIM_NAME,
                deta2.CLAIM_AMT,
                deta2.CLAIM_STS,
                (prim.BIRTH_YY * 10000 + prim.BIRTH_mm * 100 + prim.BIRTH_dd) AS BRITHDAY,
                prim.APPLY_ID,
                prim.APPLY_UNIT,
                prrs.ACDN_NAME,
                note.CL_TEXT,
                pynf.TEL_NO,
                prim.APPLY_UNIT,
                prim.APPLY_ID,
                CASE WHEN agpn.EMPY_NAME IS NULL THEN drep.ADAAI1 ELSE agpn.EMPY_NAME END AS APPLY_NAME,
                CASE WHEN agpn.EMPY_NAME IS NULL THEN drep.ADAOC1 ELSE agpn.MOBILE END AS MOBILE_NO,
                drep.ADA2C1,
                bene.PAID_ID,
                bene.PAID_NAME,
                copl.BANK_NO,
                bank.SHR_BQ,
                copl.BANK_ACT,
                addr1.ADDR,
                addr1.TEL,
                CASE WHEN ride.CNCT_STAT IS NULL THEN fhsf.CNCT_STAT ELSE ride.CNCT_STAT END ||lastday.DECL_YN AS checkcode
FROM
(
    SELECT DISTINCT(deta.POLICY_NO),
                      deta.ID_DUP,
                      deta.POLICY_SEQ,
                      deta.ID_NO,
                      deta.ITEM,
                      ddtm1.acdntype,
                      prrs1.primtype,
                      ddtm1.DECL_YN,
                      CASE WHEN ddtm1.acdntype = ' ' THEN 'Y' WHEN ddtm1.acdntype = prrs1.primtype THEN 'Y' ELSE 'N' END AS exam,
                      MAX(deta.UPD_YY * 10000 + deta.UPD_MM * 100 + deta.UPD_DD) AS lastdate
        FROM `LP_FBDB/FCLDETA0` AS deta
        INNER JOIN `LP_FBDB/FCLDFPL0` AS dfpl
            ON (deta.ITEM = dfpl.ITEM)
        INNER JOIN
        (
            SELECT ddtm.ITEM,
                   ddtm.DECL_YN,
                   MAX(ddtm.ACDN_TYPE)
                FROM `LP_FBDB/FCLDDTM0` AS ddtm
                GROUP BY ddtm.ITEM,
                         ddtm.DECL_YN
        ) AS ddtm1
            ON (ddtm1.ITEM = dfpl.ITEM)
        INNER JOIN `LP_FBDB/FCLPRIM0` AS prim
            ON (prim.RGST_NO = deta.RGST_NO)
        INNER JOIN
        (
            SELECT prrs.RGST_NO,
                   MAX(SUBSTR(prrs.ACDN_REA,1,1)) AS primtype
                FROM `LP_FBDB/FCLPRRS0` AS prrs
                GROUP BY prrs.RGST_NO
        ) AS prrs1
            ON (prim.RGST_NO = prrs1.RGST_NO)
        WHERE dfpl.DFYN_TAB LIKE 'N%'
            AND deta.CLAIM_STS LIKE 'P%'
            AND deta.CLAIM_ITEM IN ('A11E', 'A172', 'H116', 'A102', 'G105', 'A11P', 'A113', 'A11H', 'A11I', 'H117',
                                    'G101', 'A171', 'A112', 'A11O', 'A11F', 'A604', 'A603', 'A601', 'A11D', 'A11Q',
                                    'A12B', 'A12D', 'A12E', 'A12F', 'A18B', 'A181', 'A812', 'A814', 'G10A', 'G118',
                                    'G604', 'G806', 'H115')
            AND (CASE WHEN ddtm1.acdntype = ' ' THEN 'Y' WHEN ddtm1.acdntype = prrs1.primtype THEN 'Y' ELSE 'N' END) = 'Y'
        GROUP BY deta.POLICY_NO,
                 deta.ID_DUP,
                 deta.POLICY_SEQ,
                 deta.ID_NO,
                 deta.ITEM,
                 ddtm1.acdntype,
                 prrs1.primtype,
                 ddtm1.DECL_YN,
                 CASE WHEN ddtm1.acdntype = ' ' THEN 'Y' WHEN ddtm1.acdntype = prrs1.primtype THEN 'Y' ELSE 'N' END
        ORDER BY deta.POLICY_NO,
                 deta.ID_DUP,
                 deta.POLICY_SEQ,
                 deta.ID_NO,
                 deta.ITEM,
                 ddtm1.acdntype,
                 prrs1.primtype,
                 ddtm1.DECL_YN,
                 CASE WHEN ddtm1.acdntype = ' ' THEN 'Y' WHEN ddtm1.acdntype = prrs1.primtype THEN 'Y' ELSE 'N' END
) AS lastday
INNER JOIN `LP_FBDB/FCLDETA0` AS deta2
    ON
    (
        lastday.POLICY_NO = deta2.POLICY_NO
        AND lastday.ID_DUP = deta2.ID_DUP
        AND lastday.POLICY_SEQ= deta2.POLICY_SEQ
        AND lastday.ID_NO= deta2.ID_NO
        AND lastday.ITEM = deta2.ITEM
        AND lastday.lastdate= (deta2.UPD_YY*10000+deta2.UPD_MM*100+deta2.UPD_DD)
        AND deta2.CLAIM_STS LIKE 'P%'
        AND deta2.CLAIM_ITEM IN ('A11E', 'A172', 'H116', 'A102', 'G105', 'A11P', 'A113', 'A11H', 'A11I',
                                 'H117', 'G101', 'A171', 'A112', 'A11O', 'A11F', 'A604', 'A603', 'A601',
                                 'A11D', 'A11Q', 'A12B', 'A12D', 'A12E', 'A12F', 'A18B', 'A181', 'A812',
                                 'A814', 'G10A', 'G118', 'G604', 'G806', 'H115')
    )
INNER JOIN `LP_FBDB/FCLPRIM0` AS prim
    ON (prim.RGST_NO = deta2.RGST_NO)
INNER JOIN `LP_FBDB/FCLBENE0` AS bene
    ON (bene.RGST_NO = prim.RGST_NO)
INNER JOIN `LP_FBDB/FCLPRRS0` AS prrs
    ON
    (
        prim.RGST_NO = prrs.RGST_NO
        AND prrs.SEQL <= 1
    )
LEFT JOIN `LP_FBDB/FPMRIDE0` AS ride
    ON
    (
        deta2.POLICY_NO = ride.POLICY_NO
        AND deta2.POLICY_SEQ = ride.POLICY_SEQ
        AND deta2.ID_DUP = ride.ID_DUP
        AND deta2.MAIN_RIDR = ride.MAIN_RIDR
        AND deta2.SEQ_NO = ride.SEQ_NO
        AND ride.CNCT_STAT IN ('01', '02', '03', '04', '05', '06', '07', '16', '20', '25', '27', 'WP')
    )
LEFT JOIN `LP_FBDB/FPMFHSF0` AS fhsf
    ON
    (
        deta2.POLICY_NO = fhsf.POLICY_NO
        AND deta2.POLICY_SEQ = fhsf.POLICY_SEQ
        AND deta2.ID_DUP = fhsf.ID_DUP
        AND deta2.ITEM = fhsf.ITEM
        AND deta2.ID_NO = fhsf.FHS_ID
        AND fhsf.CNCT_STAT IN ('01', '02', '03', '04', '05', '06', '07', '16', '20', '25', '27', 'WP')
    )
LEFT JOIN `LP_FBDB/FCLNOTE0` AS note
    ON (prim.RGST_NO = note.RGST_NO)
LEFT JOIN `LP_FBDB/FCLITEM0` AS item
    ON (item.CLAIM_ITEM = deta2.CLAIM_ITEM)
LEFT JOIN `LP_FBDB/FRTCOPL0` AS copl
    ON
    (
        copl.PAID_ID = bene.PAID_ID
        AND prim.RGST_NO = copl.CHANGE_ID
        AND copl.COPL0_RESOURCE = 'CL'
    )
LEFT JOIN
(
    SELECT deta3.POLICY_NO,
            ID_DUP,
            POLICY_SEQ,
            ITEM,
            max(CASE WHEN regi.DATA_DISP IS NULL THEN regi2.DATA_DISP END) AS ACCD_DATE
        FROM `LP_FBDB/FCLDETA0` AS deta3
        LEFT JOIN `LP_FBDB/FCLREGI0` AS regi
            on
            (
                deta3.RGST_NO = regi.RGST_NO
                AND regi.CARD_TYPE = '2'
                AND regi.RGST_CODE = 'B34'
            )
        LEFT JOIN `LP_FBDB/FCLREGI0` AS regi2
            ON
            (
                deta3.RGST_NO = regi2.RGST_NO
                AND regi2.CARD_TYPE = '2'
                AND regi2.RGST_CODE = 'B26'
            )
        WHERE deta3.ITEM IN ('CLJ', 'CLL', 'EDUC', 'XLJ', 'XCR', 'XWU', 'XLT', 'XDA', 'XDB', 'XDC', 'XTF', 'XDH',
                                'XAR', 'XAR1', 'XDK', 'XDN', 'XIR', 'XOR', 'XTG', 'XTR', 'XWO', 'SWC', 'EDUB',
                                'AIH', 'AIO', 'AHY', 'IPAC', 'FIB1', 'F1B2', 'FIB3', 'FIB4', 'FIB5', 'FIC1',
                                'FIC2', 'FIC3', 'FIC4', 'FIC5', 'XDN1', 'XDR', 'XDR1', 'XLZ', 'XNR', 'XTO', 'XDS',
                                'XQR', 'PCC2', 'XNR', 'IXB', 'SWC', 'AI55', 'AI60', 'AI65')
            AND deta3.CLAIM_STS LIKE 'P%'
            AND deta3.CLAIM_ITEM IN ('A11E', 'A172', 'H116', 'A102', 'G105', 'A11P', 'A113', 'A11H', 'A11I', 'H117',
                                        'G101', 'A171', 'A112', 'A11O', 'A11F', 'A604', 'A603', 'A601', 'A11D', 'A11Q',
                                        'A12B', 'A12D', 'A12E', 'A12F', 'A18B', 'A181', 'A812', 'A814', 'G10A', 'G118',
                                        'G604', 'G806', 'H115')
        GROUP BY deta3.POLICY_NO,
                    ID_DUP,
                    POLICY_SEQ,
                    ITEM
        ORDER BY deta3.POLICY_NO,
                    ID_DUP,
                    POLICY_SEQ,
                    ITEM
) AS accd
    ON
    (
        accd.POLICY_NO = deta2.POLICY_NO
        AND accd.POLICY_SEQ = deta2.POLICY_SEQ
        AND accd.ID_DUP = deta2.ID_DUP
        AND accd.ITEM = deta2.ITEM
    )
LEFT JOIN `AASAPF/AAADREP` AS drep
    ON (prim.APPLY_ID= drep.ADAAC1)
LEFT JOIN `LP_FBDB/FBRAGPN0` AS agpn
    ON (prim.APPLY_ID = agpn.EMPY_ID)
LEFT JOIN `LP_FBDB/FCLPYNF0` AS pynf
    ON
    (
        prim.RGST_NO = pynf.RGST_NO
        AND pynf.SOURCE = 'FB'
        AND pynf.APLY_ID = prim.ACCID_ID
        AND pynf.NOTE_TYPE ='C'
    )
LEFT JOIN `LP_FBDB/FPMADDR0` AS addr1
    ON
    (
        lastday.POLICY_NO = addr1.POLICY_NO
        AND lastday.POLICY_SEQ = addr1.POLICY_SEQ
        AND lastday.ID_DUP = addr1.ID_DUP
        AND addr1.ADDR_CODE = '01'
    )
LEFT JOIN `LP_FBDB/FDCBANKA0` AS bank
    ON (copl.BANK_NO = bank.BANK_NO)
WHERE CASE WHEN ride.CNCT_STAT IS NULL THEN fhsf.CNCT_STAT ELSE ride.CNCT_STAT END IS NOT NULL
        AND CASE WHEN ride.CNCT_STAT IS NULL THEN fhsf.CNCT_STAT ELSE ride.CNCT_STAT END ||lastday.DECL_YN <> '25Y'
ORDER BY prim.ACCID_ID,
            deta2.POLICY_NO,
            deta2.ID_DUP,
            deta2.POLICY_SEQ;