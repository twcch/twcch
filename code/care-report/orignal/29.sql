select distinct clmd2.CDSTRDT,
                clmd2.CDENDDT,
                npay.NPSTRDT,
                npay.NPENDDT,
                rgst.RTOCCDT                           as                                      ACCRDATE,
                rgst.RTOCCID,
                rgst.RTOCCNM,
                lastno.CDINSID,
                lastno.CDSEQNO,
                lastno.CDREL,
                lastno.CDITEM,
                case when ride.CNCT_STAT is null then fhsf.CNCT_STAT else ride.CNCT_STAT end   ctst,
                case when ride.CNCT_STAT is null then fhsf.BIRTH_DATE else poli.BIRTH_DATE end BIRTH_DATE,
                case when a8times.a8times2 is null then 0 else a8times.a8times2 end            a8t2,
                lastno.lstno,
                rgst.RTCOUNTER,
                acrst.DTACDN                           as                                      ICD,
                acrst.ACDN_NAME,
                rgst.RTTXT1,
                clmd2.CDBENCD,
                clmd2.CDPAIDAMT,
                conf1.CFPAYDT,
                polp1.LPUNTCD || '-' || polp1.LPUNTSEQ as                                      UNIT,
                polp1.LPSERID                          as                                      AGID,
                polp1.LPSERNM                          as                                      AGNM,
                polp1.ADA2C1,
                polp1.ADAOC1,
                conf1.CFRCVID                          as                                      BENFID,
                conf1.CFCHKTIL                         as                                      BENFNM,
                conf1.CFACCBK                          as                                      BANK,
                conf1.SHR_BQ,
                conf1.CFRSC101                         as                                      ACCT,
                conf1.CFACCNO,
                pynf.TEL_NO                            as                                      CLMTEL,
                poli.TEL,
                poli.ADDR
from (select clmd.CDINSID, clmd.CDSEQNO, clmd.CDREL, clmd.CDITEM, max(clmd.CDCLMNO) lstno
      from CLMGEN/FCPCLMD clmd
          inner join CLMGEN/FCPCLMH clmh
      on (clmd.CDCLMNO = clmh.CHCLMNO
          and clmd.CDITEM = clmh.CHITEM
          and clmh.CHCLMSTS not in ('R','D','T','E','U','C','B'))
      where clmd.CDITEM in ('PCB'
          , 'NPCB'
          , 'XPCB'
          , 'PCC'
          , 'PCC1')
        and clmd.CDBENCD in ('A1'
          , 'A8'
          , 'A11')
      group by clmd.CDINSID, clmd.CDSEQNO, clmd.CDREL, clmd.CDITEM
      order by clmd.CDINSID, clmd.CDSEQNO, clmd.CDREL, clmd.CDITEM) lastno
         left join (select clmd.CDINSID,
                           clmd.CDSEQNO,
                           clmd.CDREL,
                           clmd.CDITEM,
                           clmd.CDBENCD,
                           sum(clmd.CDPAYDAY) as A8times2
                    from CLMGEN/FCPCLMD clmd
               inner join CLMGEN/FCPCLMH clmh
                    on (clmd.CDCLMNO = clmh.CHCLMNO
                        and clmd.CDITEM = clmh.CHITEM
                        and clmh.CHCLMSTS not in ('R','D','T','E','U','C','B'))
                    where clmd.CDITEM in ('PCB'
                        , 'NPCB'
                        , 'XPCB'
                        , 'PCC'
                        , 'PCC1')
                      and clmd.CDBENCD = 'A8'
                    group by clmd.CDINSID, clmd.CDSEQNO, clmd.CDREL, clmd.CDITEM, clmd.CDBENCD
                    order by clmd.CDINSID, clmd.CDSEQNO, clmd.CDREL, clmd.CDITEM, clmd.CDBENCD) a8times
                   on (lastno.CDINSID = a8times.CDINSID
                       and lastno.CDSEQNO = a8times.CDSEQNO
                       and lastno.CDREL = a8times.CDREL
                       and lastno.CDITEM = a8times.CDITEM)
         left join LIBALICA/FCVRIDE ride
on (ride.INS_ID = lastno.CDINSID
    and ride.SEQ_NO = lastno.CDSEQNO
    and ride.ITEM = lastno.CDITEM
    and lastno.CDREL = 'SL'
    and ride.CNCT_STAT in ('00','01','06','10','28','29','WP','AP','27'))
    left join LIBALICA/FCVFHSF FHSF
    on (fhsf.INS_ID = lastno.CDINSID
    and fhsf.SEQ_NO = lastno.CDSEQNO
    and fhsf.ITEM = lastno.CDITEM
    and lastno.CDREL <> 'SL'
    and FHSF.CNCT_STAT in ('00','01','06','10','28','29','WP','AP','27'))
    left join CLMGEN/FCPCLMD clmd2
    on (clmd2.CDCLMNO = lastno.lstno
    and clmd2.CDITEM = lastno.CDITEM
    and clmd2.CDBENCD in ('A1','A8','A11'))
    left join CLMGEN/FCPRGST rgst
    on (lastno.LSTNO =rgst.RTCLMNO
    and lastno.CDREL =rgst.RTREL)
    left join (select *
    from CLMGEN/FCPPOLP polp
    left join AASAPF/AAADREP ag
    on polp.LPSERID = ag.ADAAC1) polp1
    on (lastno.lstno=polp1.LPCLMNO
    and lastno.CDREL=polp1.LPREL)
    left join CLMGEN/FCPNPAY npay
    on (lastno.lstno=npay.NPCLMNO
    and npay.NPNPAYCD in 'A0080')
    left join (select *
    from CLMGEN/FCPCONF conf
    left join LP_FBDB/FDCBANKA0 bank
    on conf.CFACCBK = bank.BANK_NO) conf1
    on (lastno.LSTNO =conf1.CFCLMNO)
    left join (select acr.DTACDN,acrs.ACDN_NAME,acr.DTCLMNO,acr.DTLLNA
    from CLMGEN/FCPACRS acr
    inner join LP_FBDB/FCLACRS0 acrs
    on acr.DTACDN = acrs.ACDN_REA
    and acr.DTLLNA='1') acrst
    on (lastno.LSTNO =acrst.DTCLMNO)
    left join LIBALICA /FCVPOLI poli
    on (lastno.CDINSID = poli.INS_ID
    and lastno.CDSEQNO = poli.SEQ_NO)
    left join LP_FBDB/FCLPYNF0 pynf
    on (lastno.LSTNO =pynf.RGST_NO
    and pynf.NOTE_TYPE='C'
    and pynf.SYSTEM_OP='CP')
where case when a8times.a8times2 is null then 0 else a8times.a8times2 end <> 5
  and case when a8times.a8times2 is null then 0 else a8times.a8times2 end <> 10
  and case when ride.CNCT_STAT is null then fhsf.CNCT_STAT else ride.CNCT_STAT end is not null
  and (substr(digits(clmd2.cdstrdt)
    , 5
    , 2) = ?
   or substr(digits(clmd2.cdenddt)
    , 5
    , 2) = ?
   or substr(digits(npay.npstrdt)
    , 5
    , 2) = ?
   or substr(digits(npay.npenddt)
    , 5
    , 2) = ?)
order by rgst.RTOCCID, lastno.CDINSID, lastno.CDSEQNO, lastno.CDREL, lastno.CDITEM