\c military_db

CREATE OR REPLACE VIEW border_points AS
    SELECT 
        *
    FROM guarded_object_border
    WHERE guarded_object_id = 1;


CREATE OR REPLACE VIEW coverage_ratio AS
    SELECT 
        l.coordinates AS left_coordinates, 
        r.coordinates AS right_coordinates, 
        (
            SELECT 
                COUNT(*) 
            FROM missile_station AS ms 
            INNER JOIN missile_station_type AS mst 
                ON ms.missile_station_type_id = mst.id 
            WHERE (ms.coordinates <-> l.coordinates) < mst.action_radius AND (ms.coordinates <-> r.coordinates) < mst.action_radius
        ) AS ratio
    FROM border_points AS l
    INNER JOIN border_points AS r 
        ON (l.index + 1) % (SELECT COUNT(*) FROM border_points) = r.index;
