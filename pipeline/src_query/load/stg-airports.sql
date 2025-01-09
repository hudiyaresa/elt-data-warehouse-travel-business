INSERT INTO staging.airports
    (airport_id, airport_name, city, latitude, longitude)

SELECT
    airport_id,
    airport_name,
    city,
    latitude,
    longitude

FROM public.airports

ON CONFLICT(airport_id) 
DO UPDATE SET
    airport_name = EXCLUDED.airport_name,
    city = EXCLUDED.city,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,

    updated_at = CASE WHEN 
                        staging.airports.airport_name <> EXCLUDED.airport_name 
                        OR staging.airports.city <> EXCLUDED.city
                        OR staging.airports.latitude <> EXCLUDED.latitude
                        OR staging.airports.longitude <> EXCLUDED.longitude
                THEN
                        CURRENT_TIMESTAMP
                ELSE
                        staging.airports.updated_at
                END;