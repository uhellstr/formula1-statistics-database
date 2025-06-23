
-- Tracks and races for current season

select vr.season
      ,vr.round
      ,vt.circuitid
      ,vt.circuitname
      ,vt.locality
      ,vt.country
  from v_f1_tracks vt
 inner join v_f1_races vr
on vt.circuitid = vr.circuitid
 where vr.season = 2025
 order by vr.season desc
                ,vr.round asc;

-- get current standings 	in current season			
select vfd.season
      ,vfd.round
      ,vfr.racename
      ,vfr.circuitid
      ,vfd.points
      ,vfd.wins
      ,vfd1.givenmame
      ,vfd1.familyname
      ,vfc.name as constructorname
 from v_f1_driverstandings vfd
 inner join v_f1_drivers vfd1
on vfd1.driverid = vfd.driverid
 inner join v_f1_constructors vfc
on vfd.constructorid = vfc.constructorid
  inner join v_f1_races vfr
on vfr.round = vfd.round and vfr.season = vfd.season
 where vfd.season = 2025
 order by vfd.points desc;