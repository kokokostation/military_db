\c military_db

CREATE OR REPLACE FUNCTION get_coordinates(begin_coordinates POINT, end_coordinates POINT, begin_ts INT, end_ts INT, ts INT)
    RETURNS POINT AS $get_coordinates$
BEGIN
    RETURN begin_coordinates + (end_coordinates - begin_coordinates) * POINT(CAST((ts - begin_ts) AS REAL) / (end_ts - begin_ts), 0);
END
$get_coordinates$ language plpgsql;


CREATE OR REPLACE FUNCTION lies_between(begin_ts INT, end_ts INT, ts INT)
    RETURNS BOOLEAN AS $lies_between$
BEGIN
    RETURN begin_ts <= ts AND ts <= end_ts;
END
$lies_between$ language plpgsql;
