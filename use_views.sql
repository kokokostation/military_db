\c military_db

\echo "Получить список воздушных целей в заданный момент времени в зоне ответственности ЗРК с учетом зарегистрированных трасс"

SELECT * FROM missile_station_flying_objects;

\echo "Получить список целей, отклонившихся от своих трасс"

SELECT * FROM deviated_flying_objects;

\echo "Получить текущую разбивку целей по зонам ответственности подчиненных зенитно ракетных средств"

SELECT * FROM flying_object_missile_station_assignment;

\echo "Получить список перегруженных зенитно ракетных средств"

SELECT * FROM missile_station_load;

\echo "Получить кратность покрытия охраняемых сегментов границы объекта"

SELECT * FROM coverage_ratio;
