INSERT INTO staging.hotel_bookings
    (trip_id, customer_id, hotel_id, check_in_date, check_out_date, price, breakfast_included, hotel_booking_date)

SELECT
    trip_id,
    customer_id,
    hotel_id,
    check_in_date,
    check_out_date,
    price,
    CASE
        WHEN breakfast_included::boolean = true THEN 'Yes'
        WHEN breakfast_included::boolean = false THEN 'No'
        ELSE 'Unknown'
    END AS breakfast_included,
    (check_in_date - floor(random() * 30)::int) as hotel_booking_date

FROM public.hotel_bookings

ON CONFLICT(trip_id)
DO UPDATE SET
    customer_id = EXCLUDED.customer_id,
    hotel_id = EXCLUDED.hotel_id,
    check_in_date = EXCLUDED.check_in_date,
    check_out_date = EXCLUDED.check_out_date,
    price = EXCLUDED.price,
    breakfast_included = EXCLUDED.breakfast_included,
    hotel_booking_date = EXCLUDED.hotel_booking_date,

    updated_at = CASE WHEN 
                        staging.hotel_bookings.customer_id <> EXCLUDED.customer_id
                        OR staging.hotel_bookings.hotel_id <> EXCLUDED.hotel_id
                        OR staging.hotel_bookings.check_in_date <> EXCLUDED.check_in_date                       
                        OR staging.hotel_bookings.check_out_date <> EXCLUDED.check_out_date
                        OR staging.hotel_bookings.price <> EXCLUDED.price
                        OR staging.hotel_bookings.breakfast_included <> EXCLUDED.breakfast_included
                        OR staging.hotel_bookings.hotel_booking_date <> EXCLUDED.hotel_booking_date    
                THEN
                        CURRENT_TIMESTAMP
                ELSE
                        staging.hotel_bookings.updated_at
                END;