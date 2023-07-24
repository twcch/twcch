select distinct prim.RGST_NO,
                deta2.POLICY_NO,
                deta2.POLICY_SEQ,
                deta2.ID_DUP,
                prim.ACCID_ID,
                prim.ACCID_NAME,
                (prim.ACDN_YY * 10000 + prim.ACDN_MM * 100 + prim.ACDN_DD)                   as ACDN_DATE,
                accd.ACCD_DATE,
                lastday.lastdate,
                lastday.ITEM,
                case when ride.CNCT_STAT is null then fhsf.CNCT_STAT else ride.CNCT_STAT end as cnst,
                deta2.CLAIM_ITEM,
                item.CLAIM_NAME,
                deta2.CLAIM_AMT,
                deta2.CLAIM_STS,
                (prim.BIRTH_YY * 10000 + prim.BIRTH_mm * 100 + prim.BIRTH_dd)                as BRITHDAY,
                prim.APPLY_ID,
                prim.APPLY_UNIT,
                prrs.ACDN_NAME,
                note.CL_TEXT,
                pynf.TEL_NO,
                prim.APPLY_UNIT,
                prim.APPLY_ID,
                case
                    when agpn.EMPY_NAME is null then drep.ADAAI1
                    else agpn.EMPY_NAME end                                                  as APPLY_NAME,
                case when agpn.EMPY_NAME is null then drep.ADAOC1 else agpn.MOBILE end       as MOBILE_NO,
                drep.ADA2C1,
                bene.PAID_ID,
                bene.PAID_NAME,
                copl.BANK_NO,
                bank.SHR_BQ,
                copl.BANK_ACT,
                addr1.ADDR,
                addr1.TEL,
                case when ride.CNCT_STAT is null then fhsf.CNCT_STAT else ride.CNCT_STAT end ||
                lastday.DECL_YN                                                              as checkcode
from (select distinct deta.POLICY_NO,
                      deta.ID_DUP,
                      deta.POLICY_SEQ,
                      deta.ID_NO,
                      deta.ITEM,
                      ddtm1.acdntype,
                      prrs1.primtype,
                      ddtm1.DECL_YN,
                      case
                          when ddtm1.acdntype = ' ' then 'Y'
                          when ddtm1.acdntype = prrs1.primtype then 'Y'
                          else 'N'
                          end                                                    as exam,
                      max(deta.UPD_YY * 10000 + deta.UPD_MM * 100 + deta.UPD_DD) as lastdate
      from LP_FBDB/FCLDETA0 deta
          inner join LP_FBDB/FCLDFPL0 dfpl
      on (deta.ITEM = dfpl.ITEM)
          inner join (select ddtm.ITEM,ddtm.DECL_YN,max(ddtm.ACDN_TYPE) as acdntype
          from LP_FBDB/FCLDDTM0 ddtm
          group by ddtm.ITEM,ddtm.DECL_YN) ddtm1
          on (ddtm1.ITEM = dfpl.ITEM)
          inner join LP_FBDB/FCLPRIM0 prim
          on (prim.RGST_NO = deta.RGST_NO)
          inner join (select prrs.RGST_NO,max(substr(prrs.ACDN_REA,1,1)) as primtype
          from LP_FBDB/FCLPRRS0 prrs
          group by prrs.RGST_NO) prrs1
          on (prim.RGST_NO = prrs1.RGST_NO)
      where dfpl.DFYN_TAB like 'N%'
        and deta.CLAIM_STS like 'P%'
        and deta.CLAIM_ITEM in ('A11E'
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
          , 'A601'
          , 'A11D'
          , 'A11Q'
          , 'A12B'
          , 'A12D'
          , 'A12E'
          , 'A12F'
          , 'A18B'
          , 'A181'
          , 'A812'
          , 'A814'
          , 'G10A'
          , 'G118'
          , 'G604'
          , 'G806'
          , 'H115')
        and (case when ddtm1.acdntype = ' ' then 'Y'
          when ddtm1.acdntype = prrs1.primtype then 'Y'
          else 'N' end) = 'Y'
      group by deta.POLICY_NO, deta.ID_DUP, deta.POLICY_SEQ, deta.ID_NO, deta.ITEM, ddtm1.acdntype, prrs1.primtype, ddtm1.DECL_YN, case when ddtm1.acdntype = ' ' then 'Y' when ddtm1.acdntype = prrs1.primtype then 'Y' else 'N' end
      order by deta.POLICY_NO, deta.ID_DUP, deta.POLICY_SEQ, deta.ID_NO, deta.ITEM, ddtm1.acdntype, prrs1.primtype, ddtm1.DECL_YN, case when ddtm1.acdntype = ' ' then 'Y' when ddtm1.acdntype = prrs1.primtype then 'Y' else 'N' end) lastday
         inner join LP_FBDB/FCLDETA0 deta2
on (lastday.POLICY_NO = deta2.POLICY_NO
    and lastday.ID_DUP = deta2.ID_DUP
    and lastday.POLICY_SEQ= deta2.POLICY_SEQ
    and lastday.ID_NO= deta2.ID_NO
    and lastday.ITEM = deta2.ITEM
    and lastday.lastdate= (deta2.UPD_YY*10000+deta2.UPD_MM*100+deta2.UPD_DD)
    and deta2.CLAIM_STS like 'P%'
    and deta2.CLAIM_ITEM in ('A11E','A172','H116','A102','G105','A11P','A113','A11H','A11I','H117','G101','A171','A112','A11O','A11F','A604','A603','A601','A11D','A11Q','A12B','A12D','A12E','A12F','A18B','A181','A812','A814','G10A','G118','G604','G806','H115')
    )
    inner join LP_FBDB/FCLPRIM0 prim
    on (prim.RGST_NO = deta2.RGST_NO)
    inner join LP_FBDB/FCLBENE0 bene
    on (bene.RGST_NO = prim.RGST_NO)
    inner join LP_FBDB/FCLPRRS0 prrs
    on (prim.RGST_NO = prrs.RGST_NO
    and prrs.SEQL <= 1)
    left join LP_FBDB/FPMRIDE0 ride
    on (deta2.POLICY_NO = ride.POLICY_NO
    and deta2.POLICY_SEQ = ride.POLICY_SEQ
    and deta2.ID_DUP = ride.ID_DUP
    and deta2.MAIN_RIDR = ride.MAIN_RIDR
    and deta2.SEQ_NO = ride.SEQ_NO
    and ride.CNCT_STAT in ('01','02','03','04','05','06','07','16','20','25','27','WP'))
    left join LP_FBDB/FPMFHSF0 fhsf
    on (deta2.POLICY_NO = fhsf.POLICY_NO
    and deta2.POLICY_SEQ = fhsf.POLICY_SEQ
    and deta2.ID_DUP = fhsf.ID_DUP
    and deta2.ITEM = fhsf.ITEM
    and deta2.ID_NO = fhsf.FHS_ID
    and fhsf.CNCT_STAT in ('01','02','03','04','05','06','07','16','20','25','27','WP'))
    left join LP_FBDB/FCLNOTE0 note
    on (prim.RGST_NO = note.RGST_NO)
    left join LP_FBDB/FCLITEM0 item
    on (item.CLAIM_ITEM = deta2.CLAIM_ITEM)
    left join LP_FBDB/FRTCOPL0 copl
    on (copl.PAID_ID = bene.PAID_ID
    and prim.RGST_NO = copl.CHANGE_ID
    and copl.COPL0_RESOURCE = 'CL')
    left join (select deta3.POLICY_NO,ID_DUP,POLICY_SEQ,ITEM,
    max(case when regi.DATA_DISP is null then regi2.DATA_DISP end) as ACCD_DATE
    from LP_FBDB/FCLDETA0 deta3
    left join LP_FBDB/FCLREGI0 regi
    on (deta3.RGST_NO = regi.RGST_NO
    and regi.CARD_TYPE = '2'
    and regi.RGST_CODE = 'B34')
    left join LP_FBDB/FCLREGI0 regi2
    on (deta3.RGST_NO = regi2.RGST_NO
    and regi2.CARD_TYPE = '2'
    and regi2.RGST_CODE = 'B26')
    where deta3.ITEM in ('CLJ','CLL','EDUC','XLJ','XCR','XWU','XLT','XDA','XDB','XDC','XTF','XDH','XAR','XAR1','XDK','XDN','XIR','XOR','XTG','XTR','XWO','SWC','EDUB','AIH','AIO','AHY','IPAC','FIB1','F1B2','FIB3','FIB4','FIB5','FIC1','FIC2','FIC3','FIC4','FIC5','XDN1','XDR','XDR1','XLZ','XNR','XTO','XDS','XQR','PCC2','XNR','IXB','SWC','AI55','AI60','AI65')
    and deta3.CLAIM_STS like 'P%'
    and deta3.CLAIM_ITEM in ('A11E','A172','H116','A102','G105','A11P','A113','A11H','A11I','H117','G101','A171','A112','A11O','A11F','A604','A603','A601','A11D','A11Q','A12B','A12D','A12E','A12F','A18B','A181','A812','A814','G10A','G118','G604','G806','H115')
    group by deta3.POLICY_NO,ID_DUP,POLICY_SEQ,ITEM
    order by deta3.POLICY_NO,ID_DUP,POLICY_SEQ,ITEM) accd
    on (accd.POLICY_NO = deta2.POLICY_NO
    and accd.POLICY_SEQ = deta2.POLICY_SEQ
    and accd.ID_DUP = deta2.ID_DUP
    and accd.ITEM = deta2.ITEM)
    left join AASAPF/AAADREP drep
    on (prim.APPLY_ID= drep.ADAAC1)
    left join LP_FBDB/FBRAGPN0 agpn
    on (prim.APPLY_ID = agpn.EMPY_ID)
    left join LP_FBDB/FCLPYNF0 pynf
    on (prim.RGST_NO = pynf.RGST_NO
    and pynf.SOURCE = 'FB'
    and pynf.APLY_ID = prim.ACCID_ID
    and pynf.NOTE_TYPE ='C')
    left join LP_FBDB/FPMADDR0 addr1
    on (lastday.POLICY_NO = addr1.POLICY_NO
    and lastday.POLICY_SEQ = addr1.POLICY_SEQ
    and lastday.ID_DUP = addr1.ID_DUP
    and addr1.ADDR_CODE = '01')
    left join LP_FBDB/FDCBANKA0 bank
    on (copl.BANK_NO = bank.BANK_NO)
where case when ride.CNCT_STAT is null then fhsf.CNCT_STAT else ride.CNCT_STAT end is not null
  and case when ride.CNCT_STAT is null then fhsf.CNCT_STAT else ride.CNCT_STAT end ||lastday.DECL_YN <>'25Y'
order by prim.ACCID_ID, deta2.POLICY_NO, deta2.ID_DUP, deta2.POLICY_SEQ;