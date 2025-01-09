INSERT INTO staging.airlines
    (airline_id, airline_name, country, airline_iata, airline_icao)

SELECT
    airline_id,
    airline_name,
    country,
    airline_iata,
    airline_icao

FROM public.airlines

ON CONFLICT(airline_id) 
DO UPDATE SET
    airline_name = EXCLUDED.airline_name,
    country = EXCLUDED.country,
    airline_iata = EXCLUDED.airline_iata,
    airline_icao = EXCLUDED.airline_icao,

    updated_at = CASE WHEN 
                        staging.airlines.airline_name <> EXCLUDED.airline_name 
                        OR staging.airlines.country <> EXCLUDED.country
                        OR staging.airlines.airline_iata <> EXCLUDED.airline_iata
                        OR staging.airlines.airline_icao <> EXCLUDED.airline_icao
                THEN
                        CURRENT_TIMESTAMP
                ELSE
                        staging.airlines.updated_at
                END;