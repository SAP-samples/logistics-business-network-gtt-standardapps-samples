*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 13.12.2022 at 04:39:35
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZGTT_POTYPE_RST.................................*
DATA:  BEGIN OF STATUS_ZGTT_POTYPE_RST               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZGTT_POTYPE_RST               .
CONTROLS: TCTRL_ZGTT_POTYPE_RST
            TYPE TABLEVIEW USING SCREEN '9000'.
*.........table declarations:.................................*
TABLES: *ZGTT_POTYPE_RST               .
TABLES: ZGTT_POTYPE_RST                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
