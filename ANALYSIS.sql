--  Which brand is cheapest to buy used?
SELECT 
    make,
    COUNT(*) as cars_available,
    ROUND(AVG(price), 2) as avg_price,
    ROUND(MIN(price), 2) as cheapest,
    ROUND(MAX(price), 2) as most_expensive
FROM cars
GROUP BY make
HAVING COUNT(*) >= 100
ORDER BY avg_price ASC
LIMIT 15;
-- Chevrolet followed by smart

--  Does mileage really affect price?
SELECT 
    CASE 
        WHEN mileage < 50000 THEN '0-50k'
        WHEN mileage < 100000 THEN '50-100k'
        WHEN mileage < 150000 THEN '100-150k'
        WHEN mileage < 200000 THEN '150-200k'
        WHEN mileage < 250000 THEN '200-250k'
        ELSE '250k+'
    END as mileage_bracket,
    COUNT(*) as cars,
    ROUND(AVG(price), 0) as avg_price,
    ROUND(AVG(mileage), 0) as avg_mileage,
    ROUND(AVG(price)::NUMERIC / NULLIF(AVG(mileage), 0) * 1000, 3) as euro_per_1000km
FROM cars
GROUP BY mileage_bracket
ORDER BY avg_mileage;
-- The BIGGEST value loss happens in the first 50k km. After 100k, cars become "beaters" with a price floor.

-- Which fuel type holds value best?
SELECT 
    fuel_type,
    COUNT(*) as cars,
    ROUND(AVG(price), 0) as avg_price,
    ROUND(AVG(mileage), 0) as avg_mileage,
    ROUND(AVG(price)::NUMERIC / NULLIF(AVG(mileage), 0) * 1000, 2) as euro_per_1000km
FROM cars
WHERE year >= 2015
GROUP BY fuel_type
ORDER BY avg_price DESC;
-- Hybrid wins

-- Manual vs Automatic Price Difference?
SELECT 
    transmission,
    COUNT(*) as cars,
    ROUND(AVG(price), 0) as avg_price,
    ROUND(AVG(horsepower), 0) as avg_hp,
    ROUND(AVG(mileage), 0) as avg_mileage
FROM cars
GROUP BY transmission
ORDER BY avg_price DESC;
-- Automatic car's price is hugee

--  Best Value Cars (Low Price + Low Mileage)
SELECT 
    make,
    model,
    year,
    price,
    mileage,
    fuel_type,
    transmission,
    ROUND(price::NUMERIC / NULLIF(mileage, 0) * 1000, 2) as euro_per_1000km
FROM cars
WHERE mileage < 50000 
    AND price < 10000
    AND year >= 2010
ORDER BY euro_per_1000km ASC
LIMIT 20;
--  Skoda, Suzuki, Renault, Hyundai

-- Which Brand Has Lowest Maintenance Costs?
SELECT 
    c.make,
    COUNT(DISTINCT c.id) as cars_serviced,
    COUNT(m.id) as total_services,
    ROUND(AVG(m.cost), 2) as avg_service_cost,
    ROUND(SUM(m.cost) / COUNT(DISTINCT c.id), 2) as avg_total_cost_per_car
FROM cars c
JOIN maintenance_log m ON c.id = m.car_id
GROUP BY c.make
HAVING COUNT(DISTINCT c.id) >= 20
ORDER BY avg_total_cost_per_car ASC
LIMIT 15;
-- Fiat dominates, Jeep is the cheapest and Porche is suprisingly in the Top 5