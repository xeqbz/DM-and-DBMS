--Регистрация пользователя 
CREATE OR REPLACE PROCEDURE register_patient(
	p_first_name VARCHAR,
	p_last_name VARCHAR,
	p_date_of_birth DATE,
	p_adress VARCHAR,
	p_phone_number VARCHAR,
	p_email VARCHAR,
	p_password VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
	IF EXISTS (SELECT 1 FROM Patients WHERE email = p_email) THEN
		RAISE EXCEPTION 'Email % уже зарегистрирован', p_email;
	END IF;

	INSERT INTO Patients (first_name, last_name, date_of_birth, adress, phone_number, email, password)
	VALUES (p_first_name, p_last_name, p_date_of_birth, p_adress, p_phone_number, p_email, p_password);
END;
$$;
--CALL register_patient('Иван', 'Иванов', '1990-01-01', 'Минск, ул. Ленина', '+375291234567', 'ivanov@email.com', 'secret123');

-- Вход в аккаунт
CREATE OR REPLACE PROCEDURE login_patient(
    p_email VARCHAR,
    p_password VARCHAR
)
LANGUAGE plpgsql AS $$
DECLARE
    v_patient_id INT;
BEGIN
    SELECT id INTO v_patient_id
    FROM Patients
    WHERE email = p_email AND password = p_password;

    IF v_patient_id IS NULL THEN
        RAISE EXCEPTION 'Неверный email или пароль';
    END IF;
    
    RAISE NOTICE 'Авторизация успешна. Пациент ID: %', v_patient_id;
END;
$$;
--CALL login_patient('ivanov@email.com', 'secret123');

--Запись на прием
CREATE OR REPLACE PROCEDURE book_appointment(
    p_patient_id INT,
    p_doctor_id INT,
    p_appointment_date TIMESTAMP
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Appointments (appointment_date, status, patient_id, doctor_id)
    VALUES (p_appointment_date, 'Запланировано', p_patient_id, p_doctor_id);
    
    RAISE NOTICE 'Запись на прием для пациента ID % к врачу ID % на %', p_patient_id, p_doctor_id, p_appointment_date;
END;
$$;
--CALL book_appointment(22, 1, '2024-12-15 10:00:00');

--Отмена или изменение записи на прием
CREATE OR REPLACE PROCEDURE update_appointment(
    p_appointment_id INT,
    p_new_appointment_date TIMESTAMP,
    p_new_status VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Appointments
    SET appointment_date = p_new_appointment_date, status = p_new_status
    WHERE id = p_appointment_id;

    RAISE NOTICE 'Запись на прием обновлена: ID %', p_appointment_id;
END;
$$;
--CALL update_appointment(1, '2024-12-15 14:00:00', 'Перенос');

--Оплата услуг
CREATE OR REPLACE PROCEDURE pay_for_service(
    p_patient_id INT,
    p_appointment_id INT,
    p_amount DECIMAL(10, 2),
    p_payment_method VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Payments (patient_id, appointment_id, amount, payment_status, payment_method)
    VALUES (p_patient_id, p_appointment_id, p_amount, 'Оплачено', p_payment_method);
    
    RAISE NOTICE 'Оплата успешна: Пациент ID % на прием ID % сумма %', p_patient_id, p_appointment_id, p_amount;
END;
$$;
--CALL pay_for_service(1, 1, 100.00, 'Карта');

--Обновление профиля
CREATE OR REPLACE PROCEDURE update_patient_profile(
    p_patient_id INT,
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_address VARCHAR,
    p_phone_number VARCHAR,
    p_email VARCHAR,
    p_password VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Patients
    SET first_name = p_first_name,
        last_name = p_last_name,
        adress = p_address,
        phone_number = p_phone_number,
        email = p_email,
        password = p_password
    WHERE id = p_patient_id;

    RAISE NOTICE 'Профиль пациента ID % обновлен', p_patient_id;
END;
$$;
--CALL update_patient_profile(1, 'Иван', 'Иванов', 'Минск, ул. Пролетарская', '+375292345678', 'ivanov_new@email.com', 'new_secret123');

--Просмотр медицинской карты 
CREATE OR REPLACE PROCEDURE view_medical_record(
    p_patient_id INT
)
LANGUAGE plpgsql AS $$
DECLARE
    record RECORD;
BEGIN
    FOR record IN
        SELECT diagnosis, prescriptions, recommendations, visit_date
        FROM MedicalRecords
        WHERE patient_id = p_patient_id
    LOOP
        RAISE NOTICE 'Диагноз: %, Прописания: %, Рекомендации: %, Дата визита: %',
            record.diagnosis, record.prescriptions, record.recommendations, record.visit_date;
    END LOOP;
END;
$$;
--CALL view_medical_record(1);

--Просмотр расписания
CREATE OR REPLACE PROCEDURE view_doctor_schedule(
    p_doctor_id INT
)
LANGUAGE plpgsql AS $$
DECLARE
    schedule RECORD;
BEGIN
    FOR schedule IN
        SELECT day_of_week, start_time, end_time
        FROM Schedules
        WHERE doctor_id = p_doctor_id
    LOOP
        RAISE NOTICE 'День недели: %, Начало: %, Конец: %',
            schedule.day_of_week, schedule.start_time, schedule.end_time;
    END LOOP;
END;
$$;
--CALL view_doctor_schedule(1);

--Добавление/изменение услуг
CREATE OR REPLACE PROCEDURE manage_service(
    p_service_id INT,
    p_name VARCHAR,
    p_description TEXT,
    p_cost DECIMAL(10, 2),
    p_category_id INT
)
LANGUAGE plpgsql AS $$
BEGIN
    IF p_service_id IS NULL THEN
        INSERT INTO Services (name, description, cost, category_id)
        VALUES (p_name, p_description, p_cost, p_category_id);
        RAISE NOTICE 'Услуга добавлена';
    ELSE
        UPDATE Services
        SET name = p_name, description = p_description, cost = p_cost, category_id = p_category_id
        WHERE id = p_service_id;
        RAISE NOTICE 'Услуга обновлена';
    END IF;
END;
$$;
--CALL manage_service(NULL, 'Терапевт', 'Консультация терапевта', 50.00, 1);
--Для обновления:
--CALL manage_service(1, 'Терапевт', 'Консультация терапевта с осмотром', 55.00, 1);

--Удаление услуг
CREATE OR REPLACE PROCEDURE delete_service(p_service_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Services WHERE id = p_service_id;
    RAISE NOTICE 'Услуга ID % удалена', p_service_id;
END;
$$;
--CALL delete_service(1);