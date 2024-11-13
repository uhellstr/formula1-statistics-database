CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_F1_JSON_DOCS" 
 ( "DOC_ID", "DOC_TYPE", "DATE_LOADED", "SEASON", "RACE", "LAPNUMBER", "RACETYPE", "F1_DOCUMENT"
  )  AS 
  SELECT
    f1d.doc_id,
    fjd.doc_type,
    f1d.date_loaded,
    f1d.season,
    f1d.race,
    f1d.lapnumber,
    f1d.racetype,
    f1d.f1_document
FROM
    f1_json_docs f1d
inner join f1_json_doctype fjd
on f1d.doc_type = fjd.id
order by doc_type,season,race,lapnumber,racetype