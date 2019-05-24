\c military_db

CREATE OR REPLACE VIEW registered_track_segments AS
    SELECT 
        l.track_id AS track_id,
        l.ts AS begin_ts,
        r.ts AS end_ts,
        l.coordinates AS begin_coordinates,
        r.coordinates AS end_coordinates
    FROM track_points AS l
    INNER JOIN track_points AS r
        ON l.index + 1 = r.index AND l.track_id = r.track_id
    INNER JOIN track
        ON l.track_id = track.id
    WHERE track.status = 'REGISTERED';


CREATE OR REPLACE VIEW registered_coordinates AS
    SELECT DISTINCT ON (fo.id)
        fo.id AS flying_object_id,
        get_coordinates(rts.begin_coordinates, rts.end_coordinates, rts.begin_ts, rts.end_ts, 1514843835) AS coordinates
    FROM flying_object AS fo
    INNER JOIN registered_track_segments AS rts
        ON fo.registered_track_id = rts.track_id
    WHERE lies_between(rts.begin_ts, rts.end_ts, 1514843835);


CREATE OR REPLACE VIEW missile_station_flying_objects AS
    SELECT 
        rc.flying_object_id AS flying_object_id,
        ms.id AS missile_station_id
    FROM registered_coordinates AS rc
    CROSS JOIN missile_station AS ms
    INNER JOIN missile_station_type AS mst
        ON mst.id = ms.missile_station_type_id
    WHERE ms.coordinates <-> rc.coordinates <= mst.action_radius
    ORDER BY ms.id;
