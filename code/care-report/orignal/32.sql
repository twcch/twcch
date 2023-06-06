select distinct lasted.GIVE_MM,
                lasted.GIVE_YY * 10000 + lasted.GIVE_MM * 100 + lasted.GIVE_DD            as GIVE_DATE,
                substr(prim1.RGST_NO, 4, 2)                                               as AREA,
                lasted.EFF_TIMES,
                lasted.EFF_DATE,
                lasted.ITEM,
                lasted.CLAIM_ITEM,
                lasted.DD_CLASS,
                lasted.POLICY_NO,
                lasted.POLICY_SEQ,
                lasted.ID_DUP,
                lasted.CNCT_STAT,
                prim1.ACCID_ID,
                prim1.ACCID_NAME,
                (prim1.BIRTH_YY * 10000 + prim1.BIRTH_MM * 100 + prim1.BIRTH_DD)          as BIRTH_DATE,
                lasted.ACCD_DATE,
                prim1.rgst_no,
                prrs.ACDN_NAME,
                note.CL_TEXT,
                pynf.TEL_NO,
                prim1.APPLY_UNIT,
                prim1.APPLY_ID,
                case when agpn.EMPY_NAME is null then drep.ADAAI1 else agpn.EMPY_NAME end as APPLY_NAME,
                case when agpn.EMPY_NAME is null then drep.ADAOC1 else agpn.MOBILE end    as MOBILE_NO,
                drep.ADA2C1,
                bene.PAID_ID,
                bene.PAID_NAME,
                copl.BANK_NO,
                bank.SHR_BQ,
                copl.BANK_ACT,
                addr1.ADDR,
                addr1.TEL,
                lasted.CNCT_STAT || lasted.DECL_YN                                        as checkcode
from LP_FBDB/FCLPRIM0 prim1
  inner join (select ddta.GIVE_YY,ddta.GIVE_MM,ddta.GIVE_DD,
                     ddta.ACCID_ID, ddta.POLICY_NO,ddta.POLICY_SEQ, ddta.ID_DUP, ddta.ITEM,
                     ddta.CLAIM_ITEM,ride.CNCT_STAT, ddta.DD_CLASS,
                     ddta.ACCD_YY*10000+ddta.ACCD_MM*100+ddta.ACCD_DD as ACCD_DATE,
                     ddta.EFF_YY*10000+ddta.EFF_MM*100+ddta.EFF_DD as EFF_DATE,
                     ddta.EFF_TIMES, ddtm1.DECL_YN, ddtm1.acdntype , max(prim.ENTRY_YY*10000+prim.ENTRY_MM*100+prim.ENTRY_DD) as LASTED
                from LP_FBDB/FCLDDTA0 ddta
               inner join LP_FBDB/FPMRIDE0 ride
                  on (ddta.POLICY_NO = ride.POLICY_NO
                     and ddta.POLICY_SEQ = ride.POLICY_SEQ
                     and ddta.ID_DUP = ride.ID_DUP
                     and ddta.MAIN_RIDR = ride.MAIN_RIDR
                     and ddta.SEQ_NO = ride.SEQ_NO
                     and ride.CNCT_STAT in ('01','02','03','04','05','07','16','20','25','27','WP')
                     and ddta.CLAIM_ITEM in ('A11E','A172','H116','A102','G105','A11P','A113','A11H','A11I','H117','G101','A171','A112','A11O')
                     and ddta.ITEM not in ('PCC','PCC1')
                     and ddta.EFF_TIMES <> ddta.IPAY_TIMES)
               inner join (select ddtm.ITEM,ddtm.DECL_YN,max(ddtm.ACDN_TYPE) as acdntype
                             from LP_FBDB/FCLDDTM0 ddtm
                            group by ddtm.ITEM,ddtm.DECL_YN) ddtm1
                  on (ddtm1.ITEM =ddta.ITEM)
               inner join LP_FBDB/FCLPRIM0 prim
                  on (ddta.ACCID_ID = prim.ACCID_ID
                     and prim.STEP_CODE <>'X')
               group by ddta.GIVE_YY,ddta.GIVE_MM,ddta.GIVE_DD,
                        ddta.ACCID_ID, ddta.POLICY_NO, ddta.POLICY_SEQ, ddta.ID_DUP, ddta.ITEM, ddta.CLAIM_ITEM,ride.CNCT_STAT,ddta.DD_CLASS,
                        ddta.ACCD_YY*10000+ddta.ACCD_MM*100+ddta.ACCD_DD,
                        ddta.EFF_YY*10000+ddta.EFF_MM*100+ddta.EFF_DD,
                        ddta.EFF_TIMES, ddtm1.DECL_YN, ddtm1.acdntype
               order by ddta.GIVE_YY,ddta.GIVE_MM,ddta.GIVE_DD,
                        ddta.ACCID_ID, ddta.POLICY_NO, ddta.POLICY_SEQ, ddta.ID_DUP, ddta.ITEM, ddta.CLAIM_ITEM,ride.CNCT_STAT,ddta.DD_CLASS,
                        ddta.ACCD_YY*10000+ddta.ACCD_MM*100+ddta.ACCD_DD,
                        ddta.EFF_YY*10000+ddta.EFF_MM*100+ddta.EFF_DD,
                        ddta.EFF_TIMES, ddtm1.DECL_YN, ddtm1.acdntype
               ) lasted
on (lasted.ACCID_ID = prim1.ACCID_ID
    and prim1.STEP_CODE <>'X'
    and prim1.ENTRY_YY*10000+prim1.ENTRY_MM*100+prim1.ENTRY_DD = lasted.LASTED)
    inner join LP_FBDB/FCLPRRS0 prrs
    on (prim1.RGST_NO = prrs.RGST_NO
    and prrs.SEQL <= 1)
    left join LP_FBDB/FCLBENE0 bene
    on (bene.RGST_NO = prim1.RGST_NO)
    left join LP_FBDB/FRTCOPL0 copl
    on (copl.PAID_ID = bene.PAID_ID
    and copl.CHANGE_ID = bene.RGST_NO
    and copl.COPL0_RESOURCE = 'CL')
    left join LP_FBDB/FCLNOTE0 note
    on (prim1.RGST_NO = note.RGST_NO)
    left join AASAPF/AAADREP drep
    on (prim1.APPLY_ID= drep.ADAAC1)
    left join LP_FBDB/FBRAGPN0 agpn
    on prim1.APPLY_ID = agpn.EMPY_ID
    left join LP_FBDB/FCLPYNF0 pynf
    on (prim1.RGST_NO = pynf.RGST_NO
    and pynf.SOURCE = 'FB'
    and pynf.APLY_ID = prim1.ACCID_ID
    and pynf.NOTE_TYPE ='C')
    left join LP_FBDB/FPMADDR0 addr1
    on (lasted.POLICY_NO = addr1.POLICY_NO
    and lasted.POLICY_SEQ = addr1.POLICY_SEQ
    and lasted.ID_DUP = addr1.ID_DUP
    and addr1.ADDR_CODE = '01')
    left join LP_FBDB/FDCBANKA0 bank
    on (copl.BANK_NO = bank.BANK_NO)
where lasted.CNCT_STAT ||lasted.DECL_YN <>'25Y'
  and lasted.GIVE_MM = ?