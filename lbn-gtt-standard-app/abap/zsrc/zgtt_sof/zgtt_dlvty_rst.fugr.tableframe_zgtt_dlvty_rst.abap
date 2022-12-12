*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZGTT_DLVTY_RST
*   generation date: 04.11.2022 at 08:39:08
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZGTT_DLVTY_RST     .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
