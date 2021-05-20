FUNCTION zgtt_mia_update_relevance_tab.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_RELEVANCE) TYPE  ZGTT_MIA_EE_REL
*"----------------------------------------------------------------------

  MODIFY zgtt_mia_ee_rel FROM is_relevance.

ENDFUNCTION.
