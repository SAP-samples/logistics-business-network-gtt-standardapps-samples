*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 04.11.2022 at 13:13:28
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZGTT_SOTYPE_RST.................................*
DATA:  BEGIN OF STATUS_ZGTT_SOTYPE_RST               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZGTT_SOTYPE_RST               .
CONTROLS: TCTRL_ZGTT_SOTYPE_RST
            TYPE TABLEVIEW USING SCREEN '9000'.
*.........table declarations:.................................*
TABLES: *ZGTT_SOTYPE_RST               .
TABLES: ZGTT_SOTYPE_RST                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
