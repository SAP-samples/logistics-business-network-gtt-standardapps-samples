*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 04.11.2022 at 08:39:09
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZGTT_DLVTYPE_RST................................*
DATA:  BEGIN OF STATUS_ZGTT_DLVTYPE_RST              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZGTT_DLVTYPE_RST              .
CONTROLS: TCTRL_ZGTT_DLVTYPE_RST
            TYPE TABLEVIEW USING SCREEN '9000'.
*.........table declarations:.................................*
TABLES: *ZGTT_DLVTYPE_RST              .
TABLES: ZGTT_DLVTYPE_RST               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
