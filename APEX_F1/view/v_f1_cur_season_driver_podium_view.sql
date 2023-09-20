CREATE OR REPLACE FORCE EDITIONABLE VIEW "APEX_F1"."V_F1_CUR_SEASON_DRIVER_PODIUM" 
 ( "SEASON", "GIVENNAME", "FAMILYNAME", "NUMBER_OF_PODIUMS", "POINTS"
  )  AS 
  select season
       ,givenname
       ,familyname
       ,number_of_podiums
       ,points
from
(
select vfs.season
       ,vfd.givenname
       ,vfd.familyname
       ,vfs.points
       ,count(vfr.position) as number_of_podiums
from v_f1_results vfr
inner join v_f1_drivers vfd
on vfr.driverid = vfd.driverid
inner join v_f1_driverstandings vfs
on vfr.driverid = vfs.driverid
where vfr.season = f1_logik.get_cur_f1_season
 and vfr.position < 4
 and vfs.race = (select max(race) from v_f1_driverstandings where season = f1_logik.get_cur_f1_season)
group by vfs.season,vfd.givenname,vfd.familyname,vfs.points
) order by number_of_podiums desc,points desc