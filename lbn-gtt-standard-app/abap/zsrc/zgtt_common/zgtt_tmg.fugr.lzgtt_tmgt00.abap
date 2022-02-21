*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 07.12.2021 at 03:34:16
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZGTT_AOTYPE_RST.................................*
DATA:  BEGIN OF STATUS_ZGTT_AOTYPE_RST               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZGTT_AOTYPE_RST               .
CONTROLS: TCTRL_ZGTT_AOTYPE_RST
            TYPE TABLEVIEW USING SCREEN '2001'.
*...processing: ZGTT_EVTYPE_RST.................................*
DATA:  BEGIN OF STATUS_ZGTT_EVTYPE_RST               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZGTT_EVTYPE_RST               .
CONTROLS: TCTRL_ZGTT_EVTYPE_RST
            TYPE TABLEVIEW USING SCREEN '2002'.
*.........table declarations:.................................*
TABLES: *ZGTT_AOTYPE_RST               .
TABLES: *ZGTT_EVTYPE_RST               .
TABLES: ZGTT_AOTYPE_RST                .
TABLES: ZGTT_EVTYPE_RST                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
