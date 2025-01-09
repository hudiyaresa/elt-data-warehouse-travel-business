INSERT INTO staging.customers
    (customer_id, customer_first_name, customer_family_name, customer_gender, customer_birth_date, customer_country, customer_phone_number)

SELECT
    customer_id,
    customer_first_name,
    customer_family_name,
    customer_gender,
    customer_birth_date,
    customer_country,
    customer_phone_number

FROM public.customers

ON CONFLICT(customer_id)
DO UPDATE SET
    customer_first_name = EXCLUDED.customer_first_name,
    customer_family_name = EXCLUDED.customer_family_name,
    customer_gender = EXCLUDED.customer_gender,
    customer_birth_date = EXCLUDED.customer_birth_date,
    customer_country = EXCLUDED.customer_country,
    customer_phone_number = EXCLUDED.customer_phone_number,

    updated_at = CASE WHEN 
                        staging.customers.customer_first_name <> EXCLUDED.customer_first_name
                        OR staging.customers.customer_family_name <> EXCLUDED.customer_family_name
                        OR staging.customers.customer_gender <> EXCLUDED.customer_gender
                        OR staging.customers.customer_birth_date <> EXCLUDED.customer_birth_date
                        OR staging.customers.customer_country <> EXCLUDED.customer_country
                        OR staging.customers.customer_phone_number <> EXCLUDED.customer_phone_number
                THEN
                        CURRENT_TIMESTAMP
                ELSE
                        staging.customers.updated_at
                END;