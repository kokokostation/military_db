\c military_db

CREATE TABLE flying_object_type (
    id SERIAL PRIMARY KEY,
    is_military BOOLEAN NOT NULL,
    max_speed INT NOT NULL CHECK(max_speed > 0),
    fuel_capacity REAL NOT NULL CHECK (fuel_capacity > 0),
    fuel_per_kilometer REAL NOT NULL CHECK (fuel_per_kilometer > 0)
);

CREATE TABLE flying_object_weapon_type (
    id SERIAL PRIMARY KEY,
    name CHAR(50) NOT NULL
);

CREATE TABLE flying_object_type_weapon_type (
    flying_object_weapon_type_id INT NOT NULL REFERENCES flying_object_weapon_type (id) ON DELETE CASCADE,
    flying_object_type_id INT NOT NULL REFERENCES flying_object_type (id) ON DELETE CASCADE,
    number INT NOT NULL CHECK (number > 0),
    UNIQUE(flying_object_weapon_type_id, flying_object_type_id)
);

CREATE TABLE track (
    id SERIAL PRIMARY KEY,
    status CHAR(50) NOT NULL CHECK (status = 'PROGRESS' OR status = 'FINISHED' OR status = 'REGISTERED')
);

CREATE TABLE track_points (
    track_id INT NOT NULL REFERENCES track (id) ON DELETE RESTRICT,
    index INT NOT NULL CHECK (index >= 0),
    coordinates POINT NOT NULL,
    ts INT NOT NULL
);

CREATE TABLE guarded_object (
    id SERIAL PRIMARY KEY,
    name CHAR(50) NOT NULL
);

CREATE TABLE guarded_object_border (
    index INT NOT NULL,
    guarded_object_id INT NOT NULL REFERENCES guarded_object (id) ON DELETE RESTRICT,
    coordinates POINT NOT NULL
);

CREATE TABLE flying_object (
    id SERIAL PRIMARY KEY,
    flying_object_type_id INT NOT NULL REFERENCES flying_object_type (id) ON DELETE RESTRICT,
    registered_track_id INT NOT NULL REFERENCES track (id) ON DELETE RESTRICT UNIQUE,
    real_track_id INT REFERENCES track (id) ON DELETE RESTRICT UNIQUE,
    fuel_on_launch REAL NOT NULL CHECK (fuel_on_launch > 0)
);

CREATE TABLE missile_station_type (
    id SERIAL PRIMARY KEY,
    name CHAR(50) NOT NULL,
    action_radius REAL NOT NULL CHECK (action_radius > 0)
);

CREATE TABLE missile_station_weapon_type (
    id SERIAL PRIMARY KEY,
    name CHAR(50) NOT NULL,
    maximal_distance REAL NOT NULL CHECK (maximal_distance > 0)
);

CREATE TABLE missile_station_type_weapon_type (
    missile_station_weapon_type_id INT NOT NULL REFERENCES missile_station_weapon_type (id) ON DELETE CASCADE,
    missile_station_type_id INT NOT NULL REFERENCES missile_station_type (id) ON DELETE CASCADE,
    number INT NOT NULL CHECK (number > 0),
    UNIQUE(missile_station_weapon_type_id, missile_station_type_id)
);

CREATE TABLE number_needed_to_destroy (
    missile_station_weapon_type_id INT NOT NULL REFERENCES missile_station_weapon_type (id) ON DELETE CASCADE,
    flying_object_type_id INT NOT NULL REFERENCES flying_object_type (id) ON DELETE CASCADE,
    number INT NOT NULL CHECK (number > 0),
    UNIQUE(missile_station_weapon_type_id, flying_object_type_id)
);

CREATE TABLE missile_station (
    id SERIAL PRIMARY KEY,
    missile_station_type_id INT NOT NULL REFERENCES missile_station_type (id) ON DELETE RESTRICT,
    coordinates POINT NOT NULL,
    stand_to INT NOT NULL CHECK (0 < stand_to AND stand_to < 5)
);
