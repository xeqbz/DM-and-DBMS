-- Добавление данных
INSERT INTO Patients (first_name, last_name, date_of_birth, adress, phone_number, email, password, registration_date)
VALUES ('Вадим', 'Царук', '2004-05-07', 'Минск, ул.Космонавтов, 42', '+375333311166', 'tzaruk.vadick@yandex.ru', 'example', CURRENT_DATE) -- Добавление пациента

-- Получение данных
SELECT * FROM Patients; --  Получение списка всех пациентов

SELECT * FROM Doctors
WHERE experience_years >= 10; -- Получение списка врачей со стажем больше либо равным 10 годам

SELECT * FROM Patients
WHERE email = 'ivanov@example.com' AND password = 'password1'; -- Получение информации о пользователе (например при входе в систему) 

SELECT COUNT(*) FROM Doctors; -- Получение количества докторов

SELECT id, amount FROM Payments
ORDER BY amount DESC; -- Получение id платежей отсортированных по убыванию цены

SELECT * FROM Doctors
WHERE specialization_id IN (10, 11); --Получение списка терапевтов и кардиологов

SELECT * FROM Appointments
LIMIT 2 OFFSET 2; --Получение двух записей на прием с пропуском двух первых

SELECT Doctors.first_name, Doctors.last_name, DoctorSpecializations.name FROM Doctors
JOIN DoctorSpecializations ON Doctors.specialization_id = DoctorSpecializations.id; -- Получение списка имен и фамилий врачей с их специализацией

SELECT first_name, last_name, phone_number FROM Patients
WHERE phone_number LIKE '%6'; -- Вывод списка пользователей у которых номер телефона заканчивается на 6

-- Изменение данных
UPDATE Patients SET password = 'example2'
WHERE id = 21; -- Изменение пароля пользователя

-- Удаление данных
DELETE FROM Patients 
WHERE id = 21; -- Удаление пользователя

TRUNCATE TABLE Patients; -- Очистка таблцы пользователей

DROP TABLE Doctors; -- Удаление таблицы докторов