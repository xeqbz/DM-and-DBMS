--Логирование при изменении профиля 
CREATE OR REPLACE FUNCTION log_patient_profile_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO UserActionLogs (patient_id, description)
    VALUES (NEW.id, 'Обновление профиля');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_patient_update
AFTER UPDATE ON Patients
FOR EACH ROW
EXECUTE FUNCTION log_patient_profile_update();

--Изменение статуса записи при завершении
CREATE OR REPLACE FUNCTION update_appointment_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.appointment_date < CURRENT_TIMESTAMP AND NEW.status = 'Запланировано' THEN
        UPDATE Appointments
        SET status = 'Завершено'
        WHERE id = NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_appointment_check
BEFORE UPDATE ON Appointments
FOR EACH ROW
EXECUTE FUNCTION update_appointment_status();

--Логирование изменений мед карты
CREATE OR REPLACE FUNCTION log_medical_record_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO UserActionLogs (patient_id, description)
    VALUES (
        NEW.patient_id,
        'Обновление медицинской карты: диагноз ' || NEW.diagnosis
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_medical_record_update
AFTER UPDATE ON MedicalRecords
FOR EACH ROW
EXECUTE FUNCTION log_medical_record_update();

--Уведомление о новых выплатах
CREATE OR REPLACE FUNCTION log_new_payment()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO UserActionLogs (patient_id, description)
    VALUES (
        NEW.patient_id,
        'Новая оплата: сумма ' || NEW.amount || ', метод оплаты: ' || NEW.payment_method
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_payment_insert
AFTER INSERT ON Payments
FOR EACH ROW
EXECUTE FUNCTION log_new_payment();

--Проверка пересечения расписаний
CREATE OR REPLACE FUNCTION validate_schedule()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Schedules
        WHERE doctor_id = NEW.doctor_id
        AND day_of_week = NEW.day_of_week
        AND ((NEW.start_time BETWEEN start_time AND end_time) OR
             (NEW.end_time BETWEEN start_time AND end_time))
    ) THEN
        RAISE EXCEPTION 'Расписание пересекается с существующими записями';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_schedule_insert
BEFORE INSERT ON Schedules
FOR EACH ROW
EXECUTE FUNCTION validate_schedule();
