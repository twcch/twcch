SELECT DISTINCT prim.RGST_NO,
                deta2.POLICY_NO,
                deta2.POLICY_SEQ,
                deta2.ID_DUP,
                - -RELA prim.ACCID_ID, prim.ACCID_NAME,
                (prim.ACDN_YY * 10000 + prim.ACDN_MM * 100 + prim.ACDN_DD)    AS ACDN_DATE,
                accd.ACCD_DATE,
                lastday.lastdate,
                lastday.ITEM,
                CASE
                    WHEN ride.CNCT_STAT IS NULL THEN fhsf.CNCT_STAT
                    ELSE ride.CNCT_STAT
                    END                                                       AS cnst,
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
                CASE
                    WHEN agpn.EMPY_NAME IS NULL THEN drep.ADAAI1
                    ELSE agpn.EMPY_NAME
                    END                                                       AS APPLY_NAME,
                CASE
                    WHEN agpn.EMPY_NAME IS NULL THEN drep.ADAOC1
                    ELSE agpn.MOBILE
                    END                                                       AS MOBILE_NO,
                drep.ADA2C1,
                bene.PAID_ID,
                bene.PAID_NAME,
                copl.BANK_NO,
                bank.SHR_BQ,
                copl.BANK_ACT,
                addr1.ADDR,
                addr1.TEL,
                CASE
                    WHEN ride.CNCT_STAT IS NULL THEN fhsf.CNCT_STAT
                    ELSE ride.CNCT_STAT
                    END || lastday.DECL_YN                                    AS checkcode
FROM (SELECT DISTINCT deta.POLICY_NO,
                      deta.ID_DUP,
                      deta.POLICY_SEQ,
                      deta.ID_NO,
                      deta.ITEM,
                      ddtm1.acdntype,
                      prrs1.primtype,
                      ddtm1.DECL_YN,
                      CASE
                          WHEN ddtm1.acdntype = ' ' THEN 'Y'
                          WHEN ddtm1.acdntype = prrs1.primtype THEN 'Y'
                          ELSE 'N'
                          END                                                    AS exam,
                      max(deta.UPD_YY * 10000 + deta.UPD_MM * 100 + deta.UPD_DD) AS lastdate
      FROM LP_FBDB/FCLDETA0 deta -- PCL1400
			INNER JOIN LP_FBDB/FCLDFPL0 dfpl -- PCL0400
      ON (deta.ITEM = dfpl.ITEM) -- PCL1400 : PCL0400
          INNER JOIN
          (
          SELECT ddtm.ITEM,
          ddtm.DECL_YN,
          max(ddtm.ACDN_TYPE) AS acdntype
          FROM LP_FBDB/FCLDDTM0 ddtm -- ** PCL0P10 **
          GROUP BY ddtm.ITEM,
          ddtm.DECL_YN
          ) ddtm1 -- ** PCL0P10' **
          ON (ddtm1.ITEM = dfpl.ITEM) -- PCL0P10' : PCL0400
          INNER JOIN LP_FBDB/FCLPRIM0 prim -- 理賠主檔
          ON (prim.RGST_NO = deta.RGST_NO) -- 理賠主檔 : PCL1400
          INNER JOIN
          (
          SELECT prrs.RGST_NO,
          max(substr(prrs.ACDN_REA, 1, 1)) AS primtype
          FROM LP_FBDB/FCLPRRS0 prrs -- 事故代號
          GROUP BY prrs.RGST_NO
          ) prrs1 -- 事故代號'
          ON (prim.RGST_NO = prrs1.RGST_NO) -- 理賠主檔 : 事故代號'
      WHERE dfpl.DFYN_TAB like 'N%'
        AND deta.CLAIM_STS like 'P%'
        AND deta.CLAIM_ITEM in
          (
          'A11E'
          , 'A172'
          , 'H116'
          , 'A102'
          , 'G105'
          , 'A11P'
          , 'A113'
          , 'A11H'
          , 'A11I'
          , 'H117'
          , 'G101'
          , 'A171'
          , 'A112'
          , 'A11O'
          , 'A11F'
          , 'A604'
          , 'A603'
          )
        AND
          (
          CASE
          WHEN ddtm1.acdntype = ' ' THEN 'Y'
          WHEN ddtm1.acdntype = prrs1.primtype THEN 'Y'
          ELSE 'N'
          END
          ) = 'Y'
      GROUP BY deta.POLICY_NO,
          deta.ID_DUP,
          deta.POLICY_SEQ,
          deta.ID_NO,
          deta.ITEM,
          ddtm1.acdntype,
          prrs1.primtype,
          ddtm1.DECL_YN,
          CASE
          WHEN ddtm1.acdntype = ' ' THEN 'Y'
          WHEN ddtm1.acdntype = prrs1.primtype THEN 'Y'
          ELSE 'N'
          END
      ORDER BY deta.POLICY_NO,
          deta.ID_DUP,
          deta.POLICY_SEQ,
          deta.ID_NO,
          deta.ITEM,
          ddtm1.acdntype,
          prrs1.primtype,
          ddtm1.DECL_YN,
          CASE
          WHEN ddtm1.acdntype = ' ' THEN 'Y'
          WHEN ddtm1.acdntype = prrs1.primtype THEN 'Y'
          ELSE 'N'
          END) lastday
         INNER JOIN LP_FBDB/FCLDETA0 deta2 -- PCL1400
ON
    (
    lastday.POLICY_NO = deta2.POLICY_NO
    AND lastday.ID_DUP = deta2.ID_DUP
    AND lastday.POLICY_SEQ= deta2.POLICY_SEQ
    AND lastday.ID_NO= deta2.ID_NO
    AND lastday.ITEM = deta2.ITEM
    AND lastday.lastdate= (deta2.UPD_YY*10000+deta2.UPD_MM*100+deta2.UPD_DD)
    AND deta2.CLAIM_STS like 'P%'
    AND deta2.CLAIM_ITEM in ('A11E',
    'A172',
    'H116',
    'A102',
    'G105',
    'A11P',
    'A113',
    'A11H',
    'A11I',
    'H117',
    'G101',
    'A171',
    'A112',
    'A11O',
    'A11F',
    'A604',
    'A603')
    ) -- ???????????????????????????????
    INNER JOIN LP_FBDB/FCLPRIM0 prim -- 理賠主檔
    ON (prim.RGST_NO = deta2.RGST_NO) -- 理賠主檔 : PCL1400
    INNER JOIN LP_FBDB/FCLBENE0 bene -- 理賠給付檔
    ON (bene.RGST_NO = prim.RGST_NO) -- 理賠給付檔 : 理賠主檔
    INNER JOIN LP_FBDB/FCLPRRS0 prrs -- 事故代號
    ON (prim.RGST_NO = prrs.RGST_NO AND prrs.SEQL <= 1) -- 理賠主檔 : 事故代號 : ?????????????
    LEFT OUTER JOIN LP_FBDB/FPMRIDE0 ride -- 保單主附約檔
    ON
    (
    deta2.POLICY_NO = ride.POLICY_NO
    AND deta2.POLICY_SEQ = ride.POLICY_SEQ
    AND deta2.ID_DUP = ride.ID_DUP
    AND deta2.MAIN_RIDR = ride.MAIN_RIDR
    AND deta2.SEQ_NO = ride.SEQ_NO
    AND ride.CNCT_STAT in ('01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '16',
    '20',
    '25',
    '27',
    'WP')
    ) -- ?????????????????????
    LEFT OUTER JOIN LP_FBDB/FPMFHSF0 fhsf -- 保單眷屬附約
    ON
    (
    deta2.POLICY_NO = fhsf.POLICY_NO
    AND deta2.POLICY_SEQ = fhsf.POLICY_SEQ
    AND deta2.ID_DUP = fhsf.ID_DUP
    AND deta2.ITEM = fhsf.ITEM
    AND deta2.ID_NO = fhsf.FHS_ID
    AND fhsf.CNCT_STAT in ('01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '16',
    '20',
    '25',
    '27',
    'WP')
    ) -- ?????????????????????
    LEFT OUTER JOIN LP_FBDB/FCLNOTE0 note --
    ON (prim.RGST_NO = note.RGST_NO)
    LEFT OUTER JOIN LP_FBDB/FCLITEM0 item -- PCL0500
    ON (item.CLAIM_ITEM = deta2.CLAIM_ITEM)
    LEFT OUTER JOIN LP_FBDB/FRTCOPL0 copl --
    ON
    (
    copl.PAID_ID = bene.PAID_ID
    AND prim.RGST_NO = copl.CHANGE_ID
    AND copl.COPL0_RESOURCE = 'CL'
    )-- and copl.PROC_YN = 'Y')
    LEFT OUTER JOIN
    (
SELECT deta3.POLICY_NO, ID_DUP, POLICY_SEQ, ITEM, MAX
    (
    CASE
    WHEN regi.DATA_DISP IS NULL THEN regi2.DATA_DISP
    END
    ) AS ACCD_DATE
FROM LP_FBDB/FCLDETA0 deta3               -- PCL1400
    LEFT OUTER JOIN LP_FBDB/FCLREGI0 regi -- 理賠受理明細檔
ON (deta3.RGST_NO = regi.RGST_NO
    AND regi.CARD_TYPE = '2'
    AND regi.RGST_CODE = 'B34')
    LEFT OUTER JOIN LP_FBDB/FCLREGI0 regi2 -- 理賠受理明細檔
    ON (deta3.RGST_NO = regi2.RGST_NO
    AND regi2.CARD_TYPE = '2'
    AND regi2.RGST_CODE = 'B26')
WHERE deta3.ITEM in ('CLJ'
    , 'CLL'
    , 'EDUC'
    , 'CIW'
    , 'XLJ'
    , 'XCR'
    , 'XWU'
    , 'XLT'
    , 'XDA'
    , 'XDB'
    , 'XDC'
    , 'XTF'
    , 'XDH'
    , 'XAR'
    , 'XAR1'
    , 'XDK'
    , 'XDN'
    , 'XDO'
    , 'XIR'
    , 'XOR'
    , 'XWU'
    , 'XTG'
    , 'XTR'
    , 'XWO'
    , 'SWC'
    , 'EDUB'
    , 'AIH'
    , 'AIO'
    , 'AHY'
    , 'IPAC'
    , 'FIB1'
    , 'F1B2'
    , 'FIB3'
    , 'FIB4'
    , 'FIB5'
    , 'FIC1'
    , 'FIC2'
    , 'FIC3'
    , 'FIC4'
    , 'FIC5'
    , 'XDN1'
    , 'XDR'
    , 'XDR1'
    , 'XLZ'
    , 'XNR'
    , 'XTO'
    , 'XDS'
    , 'XQR'
    , 'XTE')
  AND deta3.CLAIM_STS like 'P%'
  AND deta3.CLAIM_ITEM in ('A11E'
    , 'A172'
    , 'H116'
    , 'A102'
    , 'G105'
    , 'A11P'
    , 'A113'
    , 'A11H'
    , 'A11I'
    , 'H117'
    , 'G101'
    , 'A171'
    , 'A112'
    , 'A11O'
    , 'A11F'
    , 'A604'
    , 'A603')
GROUP BY deta3.POLICY_NO,
    ID_DUP,
    POLICY_SEQ,
    ITEM
ORDER BY deta3.POLICY_NO,
    ID_DUP,
    POLICY_SEQ,
    ITEM
    ) accd
ON (accd.POLICY_NO = deta2.POLICY_NO
    AND accd.POLICY_SEQ = deta2.POLICY_SEQ
    AND accd.ID_DUP = deta2.ID_DUP
    AND accd.ITEM = deta2.ITEM)
    LEFT OUTER JOIN AASAPF/AAADREP drep --
    ON (prim.APPLY_ID= drep.ADAAC1)
    LEFT OUTER JOIN LP_FBDB/FBRAGPN0 agpn --
    ON (prim.APPLY_ID = agpn.EMPY_ID)
    LEFT OUTER JOIN LP_FBDB/FCLPYNF0 pynf --
    ON (prim.RGST_NO = pynf.RGST_NO
    AND pynf.SOURCE = 'FB'
    AND pynf.APLY_ID = prim.ACCID_ID
    AND pynf.NOTE_TYPE ='C')
    LEFT OUTER JOIN LP_FBDB/FPMADDR0 addr1 --
    ON (lastday.POLICY_NO = addr1.POLICY_NO
    AND lastday.POLICY_SEQ = addr1.POLICY_SEQ
    AND lastday.ID_DUP = addr1.ID_DUP
    AND addr1.ADDR_CODE = '01')
    LEFT OUTER JOIN LP_FBDB/FDCBANK0 bank --
    ON (copl.BANK_NO = bank.BANK_NO)
WHERE
    (
    CASE
    WHEN ride.CNCT_STAT IS NULL THEN fhsf.CNCT_STAT
    ELSE ride.CNCT_STAT
    END IS NOT NULL
  AND CASE
    WHEN ride.CNCT_STAT IS NULL THEN fhsf.CNCT_STAT
    ELSE ride.CNCT_STAT
    END ||lastday.DECL_YN <>'25Y'
    )
ORDER BY prim.ACCID_ID,
    deta2.POLICY_NO,
    deta2.ID_DUP,
    deta2.POLICY_SEQ