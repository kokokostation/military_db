\c military_db

CREATE OR REPLACE VIEW deviated_flying_objects AS
    SELECT
        fo.id AS flying_object_id,
        MAX(real_track.coordinates <-> registered_track.coordinates) AS max_distance
    FROM
        flying_object AS fo
    INNER JOIN track_points AS registered_track
        ON fo.registered_track_id = registered_track.track_id
    INNER JOIN track_points AS real_track
        ON fo.real_track_id = real_track.track_id
    WHERE registered_track.index = real_track.index
    GROUP BY fo.id
    HAVING MAX(real_track.coordinates <-> registered_track.coordinates) > 15;
