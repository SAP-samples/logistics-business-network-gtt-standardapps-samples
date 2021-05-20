*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 29.04.2021 at 15:33:13
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZGTT_AOTYPE_RST.................................*
DATA:  BEGIN OF STATUS_ZGTT_AOTYPE_RST               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZGTT_AOTYPE_RST               .
CONTROLS: TCTRL_ZGTT_AOTYPE_RST
            TYPE TABLEVIEW USING SCREEN '2001'.
*.........table declarations:.................................*
TABLES: *ZGTT_AOTYPE_RST               .
TABLES: ZGTT_AOTYPE_RST                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
