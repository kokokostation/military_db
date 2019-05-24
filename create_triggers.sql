\c military_db

CREATE OR REPLACE FUNCTION check_fuel_on_launch() RETURNS trigger AS $check_fuel_on_launch$
    DECLARE
        _new_fuel_capacity  REAL;
    BEGIN
        SELECT fuel_capacity INTO _new_fuel_capacity
        FROM flying_object_type
        WHERE id = NEW.flying_object_type_id;

        IF NEW.fuel_on_launch > _new_fuel_capacity THEN
            RAISE EXCEPTION 'You are trying to % flying_object with flying_object_type_id=%, '
                            'fuel_on_launch=%. Though this flying_object_type has maximum '
                            'fuel_capacity=%', TG_OP, NEW.flying_object_type_id, NEW.fuel_on_launch, _new_fuel_capacity;
        END IF;

        RETURN NEW;
    END;
$check_fuel_on_launch$ LANGUAGE plpgsql;

CREATE TRIGGER check_fuel_on_launch BEFORE INSERT OR UPDATE ON flying_object
    FOR EACH ROW EXECUTE PROCEDURE check_fuel_on_launch();


CREATE OR REPLACE FUNCTION check_flying_object_tracks() RETURNS trigger AS $check_flying_object_tracks$
    DECLARE
        _registered_track_status CHAR(50);
        _real_track_status CHAR(50);
    BEGIN
        SELECT status INTO _registered_track_status
        FROM track
        WHERE id = NEW.registered_track_id;

        SELECT status INTO _real_track_status
        FROM track
        WHERE id = NEW.real_track_id;

        IF (_real_track_status <> 'FINISHED' AND _real_track_status <> 'PROGRESS') OR _registered_track_status <> 'REGISTERED' THEN
            RAISE EXCEPTION 'Wrong real/registered track status for flying_object id=% on %', NEW.id, TG_OP;
        END IF;

        RETURN NEW;
    END;
$check_flying_object_tracks$ LANGUAGE plpgsql;

CREATE TRIGGER check_flying_object_tracks BEFORE INSERT OR UPDATE ON flying_object
    FOR EACH ROW EXECUTE PROCEDURE check_flying_object_tracks();
