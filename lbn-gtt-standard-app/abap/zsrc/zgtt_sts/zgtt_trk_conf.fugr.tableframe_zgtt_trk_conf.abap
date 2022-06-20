*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZGTT_TRK_CONF
*   generation date: 23.05.2022 at 04:44:00
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZGTT_TRK_CONF      .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
