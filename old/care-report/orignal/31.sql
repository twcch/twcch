select distinct ddta.GIVE_MM,
                substr(prim.RGST_NO, 4, 2)                                                                    as AREA,
                ddta.EFF_TIMES,
                ddta.ITEM,
                ddta.POLICY_NO,
                ddta.POLICY_SEQ,
                ddta.ID_DUP,
                case when ride.CNCT_STAT is null then fhsf.CNCT_STAT else ride.CNCT_STAT end                  as cnst,
                prim.ACCID_ID,
                prim.ACCID_NAME,
                (prim.BIRTH_YY * 10000 + prim.BIRTH_MM * 100 + prim.BIRTH_DD)                                 as BIRTH_DATE,
                (ddta.ACCD_YY * 10000 + ddta.ACCD_MM * 100 + ddta.ACCD_DD)                                    as ACCD_DATE,
                deta3.RGST_NO,
                prim.PAID_AMT,
                prrs.ACDN_NAME,
                note.CL_TEXT,
                pynf.TEL_NO,
                prim.APPLY_UNIT,
                prim.APPLY_ID,
                case
                    when agpn.EMPY_NAME is null then drep.ADAAI1
                    else agpn.EMPY_NAME end                                                                   as APPLY_NAME,
                case when agpn.EMPY_NAME is null then drep.ADAOC1 else agpn.MOBILE end                        as MOBILE_NO,
                drep.ADA2C1,
                bene.PAID_ID,
                bene.PAID_NAME,
                copl.BANK_NO,
                bank.SHR_BQ,
                copl.BANK_ACT,
                addr1.ADDR,
                addr1.TEL,
                case when ride.CNCT_STAT is null then fhsf.CNCT_STAT else ride.CNCT_STAT end ||
                ddtm1.DECL_YN                                                                                 as checkcode
from LP_FBDB/FCLDDTA0 ddta
  inner join (select deta2.POLICY_NO,deta2.POLICY_SEQ,deta2.ID_DUP,deta2.ITEM,deta2.lastdate,deta1.RGST_NO
                from (select deta.POLICY_NO,deta.POLICY_SEQ,deta.ID_DUP,deta.ITEM,MAX(deta.ENTRY_YY*10000+deta.ENTRY_MM*100+deta.ENTRY_DD) as lastdate
                        from  LP_FBDB/FCLDETA0 deta
                        where deta.CLAIM_ITEM in ('H115','A103')
                          and deta.ITEM in ('PCC','PCC1')
                        group by deta.POLICY_NO,deta.POLICY_SEQ,deta.ID_DUP,deta.ITEM
                        order by deta.POLICY_NO,deta.POLICY_SEQ,deta.ID_DUP,deta.ITEM
                      ) deta2
                inner join LP_FBDB/FCLDETA0 deta1
                   on (deta2.POLICY_NO =deta1.POLICY_NO
                      and deta2.POLICY_SEQ =deta1.POLICY_SEQ
                      and deta2.ID_DUP =deta1.ID_DUP
                      and deta2.ITEM =deta1.ITEM
                      and deta2.lastdate = deta1.ENTRY_YY*10000+deta1.ENTRY_MM*100+deta1.ENTRY_DD
                      and deta1.CLAIM_ITEM in ('H115','A103')
                      and deta1.ITEM in ('PCC','PCC1'))
                    order by deta2.POLICY_NO,deta2.POLICY_SEQ,deta2.ID_DUP,deta2.ITEM,deta2.lastdate,deta1.RGST_NO
             ) deta3
on (deta3.POLICY_NO = ddta.POLICY_NO
    and deta3.POLICY_SEQ = ddta.POLICY_SEQ
    and deta3.ID_DUP = ddta.ID_DUP
    and deta3.ITEM in ('PCC','PCC1')
    and ddta.ITEM in ('PCC','PCC1')
    and ddta.EFF_TIMES <> ddta.IPAY_TIMES)
    inner join LP_FBDB/FCLPRIM0 prim
    on (prim.RGST_NO = deta3.RGST_NO)
    inner join LP_FBDB/FCLPRRS0 prrs
    on (prim.RGST_NO = prrs.RGST_NO
    and prrs.SEQL <= 1)
    inner join (select ddtm.ITEM,ddtm.DECL_YN,max(ddtm.ACDN_TYPE) as acdntype
    from LP_FBDB/FCLDDTM0 ddtm
    group by ddtm.ITEM,ddtm.DECL_YN) ddtm1
    on (ddtm1.ITEM =ddta.ITEM)
    left join LP_FBDB/FCLBENE0 bene
    on (bene.RGST_NO = prim.RGST_NO)
    left join LP_FBDB/FRTCOPL0 copl
    on (copl.PAID_ID = bene.PAID_ID
    and copl.CHANGE_ID = bene.RGST_NO
    and copl.COPL0_RESOURCE = 'CL')
    left join LP_FBDB/FCLNOTE0 note
    on (prim.RGST_NO = note.RGST_NO)
    left join LP_FBDB/FPMRIDE0 ride
    on (ddta.POLICY_NO = ride.POLICY_NO
    and ddta.POLICY_SEQ = ride.POLICY_SEQ
    and ddta.ID_DUP = ride.ID_DUP
    and ddta.MAIN_RIDR = ride.MAIN_RIDR
    and ddta.SEQ_NO = ride.SEQ_NO
    and ride.CNCT_STAT in ('01','02','03','04','05','07','16','20','25','27','WP'))
    left join LP_FBDB/FPMFHSF0 fhsf
    on (ddta.POLICY_NO = fhsf.POLICY_NO
    and ddta.POLICY_SEQ = fhsf.POLICY_SEQ
    and ddta.ID_DUP = fhsf.ID_DUP
    and prim.ACCID_ID = fhsf.FHS_ID
    and fhsf.CNCT_STAT in ('01','02','03','04','05','07','16','20','25','27','WP'))
    left join AASAPF/AAADREP drep
    on (prim.APPLY_ID= drep.ADAAC1)
    left join LP_FBDB/FBRAGPN0 agpn
    on prim.APPLY_ID = agpn.EMPY_ID
    left join LP_FBDB/FCLPYNF0 pynf
    on (prim.RGST_NO = pynf.RGST_NO
    and pynf.SOURCE = 'FB'
    and pynf.APLY_ID = prim.ACCID_ID
    and pynf.NOTE_TYPE ='C')
    left join LP_FBDB/FPMADDR0 addr1
    on (ddta.POLICY_NO = addr1.POLICY_NO
    and ddta.POLICY_SEQ = addr1.POLICY_SEQ
    and ddta.ID_DUP = addr1.ID_DUP
    and addr1.ADDR_CODE = '01')
    left join LP_FBDB/FDCBANKA0 bank
    on (copl.BANK_NO = bank.BANK_NO)
where case when ride.CNCT_STAT is null then fhsf.CNCT_STAT else ride.CNCT_STAT end is not null
  and case when ride.CNCT_STAT is null then fhsf.CNCT_STAT else ride.CNCT_STAT end ||ddtm1.DECL_YN <>'25Y'
  and ddta.GIVE_MM = ?