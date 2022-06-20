*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 23.05.2022 at 04:44:01
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZGTT_TRACK_CONF.................................*
DATA:  BEGIN OF STATUS_ZGTT_TRACK_CONF               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZGTT_TRACK_CONF               .
CONTROLS: TCTRL_ZGTT_TRACK_CONF
            TYPE TABLEVIEW USING SCREEN '9000'.
*.........table declarations:.................................*
TABLES: *ZGTT_TRACK_CONF               .
TABLES: ZGTT_TRACK_CONF                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
