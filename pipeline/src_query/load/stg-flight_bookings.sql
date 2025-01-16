INSERT INTO staging.flight_bookings
    (trip_id, customer_id, flight_number, airline_id, aircraft_id, airport_src, airport_dst, departure_time, departure_date,
     flight_duration, travel_class, seat_number, price, flight_booking_date)

SELECT
    trip_id,
    customer_id,
    flight_number,
    airline_id,
    aircraft_id,
    airport_src,
    airport_dst,
    departure_time,
    departure_date,
    flight_duration, 
    travel_class,
    seat_number,
    price,
    departure_date as flight_booking_date


FROM public.flight_bookings

ON CONFLICT(trip_id, flight_number, seat_number)
DO UPDATE SET
    customer_id = EXCLUDED.customer_id,
    airline_id = EXCLUDED.airline_id,
    aircraft_id = EXCLUDED.aircraft_id,
    airport_src = EXCLUDED.airport_src,
    airport_dst = EXCLUDED.airport_dst,
    departure_time = EXCLUDED.departure_time,
    departure_date = EXCLUDED.departure_date,
    flight_duration = EXCLUDED.flight_duration, 
    travel_class = EXCLUDED.travel_class,
    price = EXCLUDED.price,
    flight_booking_date = EXCLUDED.flight_booking_date,

    updated_at = CASE WHEN 
                        staging.flight_bookings.customer_id <> EXCLUDED.customer_id
                        OR staging.flight_bookings.airline_id <> EXCLUDED.airline_id
                        OR staging.flight_bookings.aircraft_id <> EXCLUDED.aircraft_id
                        OR staging.flight_bookings.airport_src <> EXCLUDED.airport_src
                        OR staging.flight_bookings.airport_dst <> EXCLUDED.airport_dst
                        OR staging.flight_bookings.departure_time <> EXCLUDED.departure_time
                        OR staging.flight_bookings.departure_date <> EXCLUDED.departure_date
                        OR staging.flight_bookings.flight_duration <> EXCLUDED.flight_duration
                        OR staging.flight_bookings.travel_class <> EXCLUDED.travel_class
                        OR staging.flight_bookings.price <> EXCLUDED.price
                        OR staging.flight_bookings.flight_booking_date <> EXCLUDED.flight_booking_date
                THEN
                        CURRENT_TIMESTAMP
                ELSE
                        staging.flight_bookings.updated_at
                END;