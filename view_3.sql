\c military_db

CREATE OR REPLACE VIEW real_track_segments AS
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
    WHERE track.status = 'PROGRESS';


CREATE OR REPLACE VIEW real_coordinates AS
    SELECT DISTINCT ON (fo.id)
        fo.id AS flying_object_id,
        get_coordinates(rts.begin_coordinates, rts.end_coordinates, rts.begin_ts, rts.end_ts, 1514841633) AS coordinates
    FROM flying_object AS fo
    INNER JOIN real_track_segments AS rts
        ON fo.real_track_id = rts.track_id
    WHERE lies_between(rts.begin_ts, rts.end_ts, 1514841633);


CREATE OR REPLACE VIEW flying_object_missile_station_distance AS
    SELECT 
        rc.flying_object_id AS flying_object_id,
        ms.id AS missile_station_id,
        ms.coordinates <-> rc.coordinates AS distance
    FROM real_coordinates AS rc
    CROSS JOIN missile_station AS ms;


CREATE OR REPLACE VIEW flying_object_missile_station_min_distance AS
    SELECT
        fo_ms_d.flying_object_id AS flying_object_id,
        MIN(fo_ms_d.distance) AS min_distance
    FROM flying_object_missile_station_distance AS fo_ms_d
    GROUP BY fo_ms_d.flying_object_id;


CREATE OR REPLACE VIEW flying_object_missile_station_assignment AS
    SELECT 
        fo_ms_d.flying_object_id AS flying_object_id,
        fo_ms_d.missile_station_id AS missile_station_id
    FROM flying_object_missile_station_distance AS fo_ms_d
    INNER JOIN flying_object_missile_station_min_distance AS fo_ms_md
        ON fo_ms_d.flying_object_id = fo_ms_md.flying_object_id
    WHERE fo_ms_d.distance = fo_ms_md.min_distance;
