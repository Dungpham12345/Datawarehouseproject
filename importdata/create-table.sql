 
 --1. country 
 CREATE TABLE dbo.country
    (
        country_id INT IDENTITY(1,1) NOT NULL,
        country NVARCHAR(MAX) NOT NULL,
        last_update DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT country_pkey PRIMARY KEY (country_id)
    );

	-- 2.city
    CREATE TABLE dbo.city
    (
        city_id INT IDENTITY(1,1) NOT NULL,
        city NVARCHAR(255) NOT NULL,
        country_id INT NOT NULL,
        last_update DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT city_pkey PRIMARY KEY (city_id),
        CONSTRAINT city_country_id_fkey FOREIGN KEY (country_id)
            REFERENCES dbo.country (country_id)
            ON UPDATE NO ACTION
            ON DELETE NO ACTION
    );

	--3.address
	    CREATE TABLE dbo.address
    (
        address_id INT IDENTITY(1,1) NOT NULL,
        address NVARCHAR(255) NOT NULL,
        address2 NVARCHAR(255) NULL,
        district NVARCHAR(255) NOT NULL,
        city_id INT NOT NULL,
        postal_code NVARCHAR(20) NULL,
        phone NVARCHAR(50) NOT NULL,
        last_update DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT address_pkey PRIMARY KEY (address_id),
        CONSTRAINT address_city_id_fkey FOREIGN KEY (city_id)
            REFERENCES dbo.city (city_id)
            ON UPDATE NO ACTION
            ON DELETE NO ACTION
    );


	--4. language
	    CREATE TABLE dbo.language
    (
        language_id INT IDENTITY(1,1) NOT NULL,
        name NCHAR(20) NOT NULL,
        last_update DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT language_pkey PRIMARY KEY (language_id)
    );

	--5.staff
	    CREATE TABLE dbo.staff
    (
        staff_id INT IDENTITY(1,1) NOT NULL,
        first_name NVARCHAR(255) NOT NULL,
        last_name NVARCHAR(255) NOT NULL,
        address_id INT NOT NULL,
        email NVARCHAR(255) NULL,
        store_id INT NOT NULL,
        active BIT NOT NULL DEFAULT 1,
        username NVARCHAR(255) NOT NULL,
        password NVARCHAR(255) NULL,
        last_update DATETIME NOT NULL DEFAULT GETDATE(),
        picture VARBINARY(MAX) NULL,
        CONSTRAINT staff_pkey PRIMARY KEY (staff_id),
        CONSTRAINT staff_address_id_fkey FOREIGN KEY (address_id)
            REFERENCES dbo.address (address_id)
            ON UPDATE NO ACTION
            ON DELETE NO ACTION,
        CONSTRAINT staff_store_id_fkey FOREIGN KEY (store_id)
            REFERENCES dbo.store (store_id)
            ON UPDATE NO ACTION
            ON DELETE NO ACTION
    );

	--6.store 
	    CREATE TABLE dbo.store
    (
        store_id INT IDENTITY(1,1) NOT NULL,
        manager_staff_id INT NOT NULL,
        address_id INT NOT NULL,
        last_update DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT store_pkey PRIMARY KEY (store_id),
        CONSTRAINT store_address_id_fkey FOREIGN KEY (address_id)
            REFERENCES dbo.address (address_id)
            ON UPDATE NO ACTION
            ON DELETE NO ACTION
    );
--7.customer 
CREATE TABLE dbo.customer
(
    customer_id INT IDENTITY(1,1) NOT NULL,
    store_id INT NOT NULL,
    first_name NVARCHAR(255) NOT NULL,
    last_name NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) NULL,
    address_id INT NOT NULL,
    activebool BIT NOT NULL DEFAULT 1,  -- Boolean: true = 1, false = 0
    create_date DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    last_update DATETIMEOFFSET DEFAULT SYSDATETIMEOFFSET(), -- Lưu cả timezone
    active INT NULL,
    CONSTRAINT customer_pkey PRIMARY KEY (customer_id),
    CONSTRAINT customer_address_id_fkey FOREIGN KEY (address_id)
        REFERENCES dbo.address (address_id)
        ON UPDATE NO ACTION  -- Tránh lỗi nhiều đường dẫn NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT customer_store_id_fkey FOREIGN KEY (store_id)
        REFERENCES dbo.store (store_id)
        ON UPDATE NO ACTION  -- Tránh lỗi multiple NO ACTION paths
        ON DELETE NO ACTION
);
	--8.film 
	    CREATE TABLE dbo.film
    (
        film_id INT IDENTITY(1,1) NOT NULL,
        title NVARCHAR(255) NOT NULL,
        description NVARCHAR(MAX) NULL,
        release_year INT NULL,
        language_id INT NOT NULL,
        original_language_id INT NULL,
        rental_duration INT NOT NULL DEFAULT 3,
        rental_rate DECIMAL(4,2) NOT NULL DEFAULT 4.99,
        length INT NULL,
        replacement_cost DECIMAL(5,2) NOT NULL DEFAULT 19.99,
        rating NVARCHAR(10) DEFAULT 'G',
        last_update DATETIME NOT NULL DEFAULT GETDATE(),
        special_features NVARCHAR(MAX) NULL, -- Không có kiểu ARRAY, thay bằng NVARCHAR(MAX)
        fulltext NVARCHAR(MAX) NOT NULL, -- Không có TSVECTOR, thay bằng NVARCHAR(MAX)
        CONSTRAINT film_pkey PRIMARY KEY (film_id),
        CONSTRAINT film_language_id_fkey FOREIGN KEY (language_id)
            REFERENCES dbo.language (language_id)
            ON UPDATE NO ACTION
            ON DELETE NO ACTION,
        CONSTRAINT film_original_language_id_fkey FOREIGN KEY (original_language_id)
            REFERENCES dbo.language (language_id)
            ON UPDATE NO ACTION
            ON DELETE NO ACTION
    );

	--8.actor 
	    CREATE TABLE dbo.actor
    (
        actor_id INT IDENTITY(1,1) NOT NULL,
        first_name NVARCHAR(100) NOT NULL,
        last_name NVARCHAR(100) NOT NULL,
        last_update DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT actor_pkey PRIMARY KEY (actor_id)
    );

	--9.category
	    CREATE TABLE dbo.category
    (
        category_id INT IDENTITY(1,1) NOT NULL,
        name NVARCHAR(255) NOT NULL,
        last_update DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT category_pkey PRIMARY KEY (category_id)
    );

	--10.film_actor
	    CREATE TABLE dbo.film_actor
    (
        actor_id INT NOT NULL,
        film_id INT NOT NULL,
        last_update DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT film_actor_pkey PRIMARY KEY (actor_id, film_id),
        CONSTRAINT film_actor_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES dbo.actor (actor_id) ON UPDATE NO ACTION ON DELETE NO ACTION,
        CONSTRAINT film_actor_film_id_fkey FOREIGN KEY (film_id) REFERENCES dbo.film (film_id) ON UPDATE NO ACTION ON DELETE NO ACTION
    );

	--11.film_category 
	    CREATE TABLE dbo.film_category
    (
        film_id INT NOT NULL,
        category_id INT NOT NULL,
        last_update DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT film_category_pkey PRIMARY KEY (film_id, category_id),
        CONSTRAINT film_category_category_id_fkey FOREIGN KEY (category_id) REFERENCES dbo.category (category_id) ON UPDATE NO ACTION ON DELETE NO ACTION,
        CONSTRAINT film_category_film_id_fkey FOREIGN KEY (film_id) REFERENCES dbo.film (film_id) ON UPDATE NO ACTION ON DELETE NO ACTION
    );

	---12.inventory 
	    CREATE TABLE dbo.inventory
    (
        inventory_id INT IDENTITY(1,1) PRIMARY KEY,
        film_id INT NOT NULL,
        store_id INT NOT NULL,
        last_update DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT inventory_film_id_fkey FOREIGN KEY (film_id) REFERENCES dbo.film (film_id) ON UPDATE NO ACTION ON DELETE NO ACTION,
        CONSTRAINT inventory_store_id_fkey FOREIGN KEY (store_id) REFERENCES dbo.store (store_id) ON UPDATE NO ACTION ON DELETE NO ACTION
    );

	--13.rental 
	    CREATE TABLE dbo.rental
    (
        rental_id INT IDENTITY(1,1) PRIMARY KEY,
        rental_date DATETIME NOT NULL,
        inventory_id INT NOT NULL,
        customer_id INT NOT NULL,
        return_date DATETIME NULL,
        staff_id INT NOT NULL,
        last_update DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT rental_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES dbo.customer (customer_id) ON UPDATE NO ACTION ON DELETE NO ACTION,
        CONSTRAINT rental_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES dbo.inventory (inventory_id) ON UPDATE NO ACTION ON DELETE NO ACTION,
        CONSTRAINT rental_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES dbo.staff (staff_id) ON UPDATE NO ACTION ON DELETE NO ACTION
    );

	--14.payment
	CREATE TABLE payment
(
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    staff_id INT NOT NULL,
    rental_id INT NOT NULL,
    amount DECIMAL(5,2) NOT NULL,
    payment_date DATETIME2 NOT NULL,
    CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT fk_payment_rental FOREIGN KEY (rental_id) REFERENCES rental(rental_id),
    CONSTRAINT fk_payment_staff FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
)