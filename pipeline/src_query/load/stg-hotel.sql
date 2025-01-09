INSERT INTO staging.hotel
    (hotel_id, hotel_name, hotel_address, city, country, hotel_score)

SELECT
    hotel_id,
    hotel_name,
    hotel_address,
    city,
    country,
    hotel_score

FROM public.hotel

ON CONFLICT(hotel_id)
DO UPDATE SET
    hotel_name = EXCLUDED.hotel_name,
    hotel_address = EXCLUDED.hotel_address,
    city = EXCLUDED.city,
    country = EXCLUDED.country,
    hotel_score = EXCLUDED.hotel_score,

    updated_at = CASE WHEN 
                        staging.hotel.hotel_name <> EXCLUDED.hotel_name
                        OR staging.hotel.hotel_address <> EXCLUDED.hotel_address
                        OR staging.hotel.city <> EXCLUDED.city
                        OR staging.hotel.country <> EXCLUDED.country
                        OR staging.hotel.hotel_score <> EXCLUDED.hotel_score
                THEN
                        CURRENT_TIMESTAMP
                ELSE
                        staging.hotel.updated_at
                END;