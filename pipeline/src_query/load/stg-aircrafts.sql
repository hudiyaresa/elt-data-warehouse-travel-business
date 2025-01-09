INSERT INTO staging.aircrafts 
    (aircraft_id, aircraft_name, aircraft_iata, aircraft_icao)

SELECT
    aircraft_id,
    aircraft_name,
    aircraft_iata,
    aircraft_icao

FROM public.aircrafts

ON CONFLICT(aircraft_id) 
DO UPDATE SET
    aircraft_name = EXCLUDED.aircraft_name,
    aircraft_iata = EXCLUDED.aircraft_iata,
    aircraft_icao = EXCLUDED.aircraft_icao,

    updated_at = CASE WHEN 
                        staging.aircrafts.aircraft_name <> EXCLUDED.aircraft_name 
                        OR staging.aircrafts.aircraft_iata <> EXCLUDED.aircraft_iata
                        OR staging.aircrafts.aircraft_icao <> EXCLUDED.aircraft_icao
                THEN
                        CURRENT_TIMESTAMP
                ELSE
                        staging.aircrafts.updated_at
                END;