select case
           when poli.ITEM in ('FW1G', 'FW2G', 'SW1G', 'SW2G', 'MFT1') then SUBSTR(DIGITS(regi2.DSBDT), 5, 2)
           else SUBSTR(DIGITS(regi2.POLDT), 5, 2) end as THEMONTH,
       regi2.OCCID,
       regi2.OCCNM,
       regi2.OCCBD,
       regi2.INSID,
       regi2.POLSER,
       regi2.CLMNO,
       regi2.COUNTER,
       acrst.DTACDN                                   as ICD,
       acrst.ACDN_NAME,
       mxday.MXYY,
       regi2.DDRAT,
       regi2.DSBCLS,
       regi2.DSBITM,
       adhp2.LITEM,
       poli.ITEM,
       regi2.CLMSTS,
       poli.CNCT_STAT,
       poli.EFF_DATE,
       regi2.DSBDT,
       regi2.TEXT1,
       regi2.SERID,
       regi2.SERNM,
       drep.ADA2C1,
       regi2.AGNCY,
       drep.ADAOC1,
       poli.ADDR,
       poli.TEL,
       pynf.TEL_NO,
       conf.BENENTID,
       conf.BENNM,
       conf.ACCBK,
       conf.ACCBKSUB,
       bank.SHR_BQ,
       conf.ACCNO,
       regi3.APLKIN
from (select adhp.INSID, adhp.POLSER, max(PAYYY) as MXYY
      from LIBALICA/FDPADHP adhp
         inner join LIBALICA/FDPREGI regi
      on (adhp.CLMNO = regi.CLMNO
          and regi.CLMSTS not in ('E','D'))
          and regi.APLKIN in ('DDD','ADD','DDH','FADD')
      group by adhp.INSID, adhp.POLSER) mxday
         inner join LIBALICA/FDPADHP adhp2
on (mxday.INSID = adhp2.INSID
    and mxday.POLSER = adhp2.POLSER
    and mxday.MXYY = adhp2.PAYYY)
    inner join LIBALICA/FDPREGI regi2
    on (adhp2.CLMNO = regi2.CLMNO
    and regi2.CLMSTS not in ('E','D'))
    inner join LIBALICA/FCVPOLI poli
    on (regi2.INSID = poli.INS_ID
    and regi2.POLSER = poli.SEQ_NO)
    left join (select distinct adhp.INSID||adhp.POLSER as polno,regi.occid
    from LIBALICA/FDPADHP adhp
    inner join LIBALICA/FDPREGI regi
    on (adhp.INSID||adhp.POLSER = regi.INSID||regi.POLSER)
    where regi.TEXT1 like '%死亡%'
    or regi.TEXT1 like '%身故%'
    or regi.TEXT1 like '%過世%'
    or regi.TEXT1 like '%去世%'
    or regi.TEXT1 like '%往生%'
    or regi.TEXT1 like '%CAD%'
    or regi.TEXT1 like '%病故%') dead
    on (dead.polno = regi2.INSID||regi2.POLSER)
    left join LP_FBDB/FCLPYNF0 pynf
    on (regi2.CLMNO = pynf.RGST_NO
    and pynf.SOURCE = 'FA'
    and pynf.APLY_ID = regi2.OCCID
    and pynf.NOTE_TYPE ='C')
    left join LIBALICA/FDPCONF conf
    on (regi2.CLMNO = conf.CLMNO)
    left join LP_FBDB/FDCBANKA0 bank
    on (substr(conf.ACCBK,1,3) = substr(bank.BANK_NO,1,3)
    and substr(conf.ACCBKSUB,1,4) = substr(bank.BANK_NO,4,4))
    left join AASAPF/AAADREP drep
    on (regi2.SERID = drep.ADAAC1)
    left join (select acr.DTACDN,acrs.ACDN_NAME,acr.DTCLMNO,acr.DTLLNA
    from CLMGEN/FCPACRS acr
    inner join LP_FBDB/FCLACRS0 acrs
    on acr.DTACDN = acrs.ACDN_REA
    and acr.DTLLNA='1') acrst
    on (regi2.CLMNO =acrst.DTCLMNO)
    left join LIBALICA/FDPREGI regi3
    on (regi3.INSID = regi2.INSID
    and regi3.POLSER = regi2.POLSER
    and regi3.OCCID = regi2.OCCID
    and regi3.REL = regi2.REL
    and regi3.CLMSTS <> 'E'
    and regi3.APLKIN in ('AD','DD','CAD'))
where poli.CNCT_STAT not in ('R'
    , '13')
  and dead.polno is null
  and ( (poli.item in ('FW1G'
    , 'FW2G'
    , 'SW1G'
    , 'SW2G'
    , 'MFT1')
  and substr(digits(regi2.dsbdt)
    , 5
    , 2) = ?)
   or (poli.item not in ('FW1G'
    , 'FW2G'
    , 'SW1G'
    , 'SW2G'
    , 'MFT1')
  and substr(digits(regi2.poldt)
    , 5
    , 2) = ?)
    )
  and regi3.APLKIN is null
order by mxday.INSID, mxday.POLSER