\c military_db

CREATE OR REPLACE VIEW registered_track_points AS
    SELECT 
        tp.track_id AS track_id,
        tp.coordinates AS coordinates
    FROM track_points AS tp
    INNER JOIN track AS rt
        ON rt.id = tp.track_id
    WHERE rt.status = 'REGISTERED';


CREATE OR REPLACE VIEW missile_station_load AS
    SELECT
        ms.id AS missile_station_id,
        COUNT(DISTINCT rtp.track_id) AS flying_objects_num
    FROM missile_station AS ms
    INNER JOIN missile_station_type AS mst
        ON ms.missile_station_type_id = mst.id
    CROSS JOIN registered_track_points AS rtp
    WHERE (ms.coordinates <-> rtp.coordinates) <= mst.action_radius
    GROUP BY ms.id
    ORDER BY COUNT(DISTINCT rtp.track_id) DESC;
