CREATE TABLE cars (
    id SERIAL PRIMARY KEY,
    make VARCHAR(100),
    model VARCHAR(100),
    year INTEGER,
    price DECIMAL(10,2),
    mileage INTEGER,
    fuel_type VARCHAR(50),
    transmission VARCHAR(50),
    horsepower INTEGER
);

CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    car_id INTEGER REFERENCES cars(id),
    sale_date DATE,
    sale_price DECIMAL(10,2),
    buyer_type VARCHAR(50)
);

CREATE TABLE maintenance_log (
    id SERIAL PRIMARY KEY,
    car_id INTEGER REFERENCES cars(id),
    service_date DATE,
    service_type VARCHAR(100),
    cost DECIMAL(10,2)
);