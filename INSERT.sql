INSERT INTO cars (make, model, year, price, mileage, fuel_type, transmission, horsepower)
SELECT 
    make,
    model,
    year,
    price,
    mileage,
    CASE 
        WHEN fuel = 'Gasoline' THEN 'gasoline'
        WHEN fuel = 'Diesel' THEN 'diesel'
        WHEN fuel = 'Electric' THEN 'electric'
        WHEN fuel = 'Electric/Gasoline' THEN 'hybrid'
        ELSE 'other'
    END as fuel_type,
    CASE 
        WHEN gear = 'Manual' THEN 'manual'
        WHEN gear = 'Automatic' THEN 'automatic'
        ELSE 'other'
    END as transmission,
    hp as horsepower
FROM staging_cars
WHERE make IS NOT NULL 
    AND model IS NOT NULL
    AND price > 0;

SELECT COUNT(*) FROM cars;

INSERT INTO sales (car_id, sale_date, sale_price, buyer_type)
SELECT 
    id as car_id,
    CURRENT_DATE - (random() * 365)::INTEGER * INTERVAL '1 day' as sale_date,
    price * (0.85 + random() * 0.15) as sale_price,
    CASE 
        WHEN random() < 0.6 THEN 'private'
        WHEN random() < 0.9 THEN 'dealer'
        ELSE 'export'
    END as buyer_type
FROM cars
WHERE random() < 0.7;

SELECT COUNT(*) FROM sales;

INSERT INTO maintenance_log (car_id, service_date, service_type, cost)
SELECT 
    id as car_id,
    MAKE_DATE(year, 1, 1) + (random() * 1825)::INTEGER * INTERVAL '1 day' as service_date,
    CASE (random() * 5)::INTEGER
        WHEN 0 THEN 'Oil Change'
        WHEN 1 THEN 'Brake Service'
        WHEN 2 THEN 'Tire Replacement'
        WHEN 3 THEN 'Inspection'
        ELSE 'General Repair'
    END as service_type,
    (random() * 800 + 100)::NUMERIC(10,2) as cost
FROM cars
CROSS JOIN generate_series(1, (random() * 3 + 1)::INTEGER) as service_number
WHERE random() < 0.5;

SELECT COUNT(*) FROM maintenance_log;