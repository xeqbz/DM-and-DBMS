-- Запросы с несколькими условиями
SELECT * 
FROM Patients
WHERE first_name = 'Анна' AND email LIKE '%@example.com';

SELECT * 
FROM Doctors d
JOIN DoctorSpecializations ds ON d.specialization_id = ds.id
WHERE d.experience_years > 5 AND ds.name = 'Диагност';

-- Запросы с вложенными конструкциями
SELECT * 
FROM Patients 
WHERE id IN (
    SELECT a.patient_id
    FROM Appointments a
    JOIN Doctors d ON a.doctor_id = d.id
    WHERE d.experience_years > 10
);

SELECT * 
FROM administrators
WHERE service_id IN (
	SELECT id
	FROM services
	WHERE cost > 25
);

-- INNER JOIN
SELECT 
    a.id AS appointment_id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name,
    a.appointment_date
FROM 
    Appointments a
INNER JOIN 
    Patients p ON a.patient_id = p.id
INNER JOIN 
    Doctors d ON a.doctor_id = d.id;

SELECT 
    aps.appointment_id,
    s.name AS service_name,
    sc.name AS category_name,
    s.cost
FROM 
    AppointmentServices aps
INNER JOIN 
    Services s ON aps.service_id = s.id
INNER JOIN 
    ServiceCategories sc ON s.category_id = sc.id;

--LEFT JOIN
SELECT 
    p.id AS patient_id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    a.id AS appointment_id,
    a.appointment_date
FROM 
    Patients p
LEFT JOIN 
    Appointments a ON p.id = a.patient_id;

--FULL JOIN
SELECT 
    d.id AS doctor_id,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name,
    a.id AS administrator_id,
    a.first_name AS admin_first_name,
    a.last_name AS admin_last_name
FROM 
    Doctors d
FULL JOIN 
    Administrators a ON d.id = a.profile_id;

--CROSS JOIN
SELECT 
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name,
    sc.name AS service_category_name
FROM 
    Doctors d
CROSS JOIN 
    ServiceCategories sc
WHERE d.experience_years > 5;

--SELF JOIN
SELECT 
    d1.id AS doctor1_id,
    d1.first_name AS doctor1_first_name,
    d1.last_name AS doctor1_last_name,
    d2.id AS doctor2_id,
    d2.first_name AS doctor2_first_name,
    d2.last_name AS doctor2_last_name,
    ds.name AS specialization
FROM 
    Doctors d1
JOIN 
    Doctors d2 ON d1.specialization_id = d2.specialization_id
    AND d1.id <> d2.id
JOIN 
    DoctorSpecializations ds ON d1.specialization_id = ds.id;

-- GROUP BY 
SELECT 
    d.id AS doctor_id,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name,
    COUNT(a.id) AS appointment_count
FROM 
    Doctors d
LEFT JOIN 
    Appointments a ON d.id = a.doctor_id
GROUP BY 
    d.id, d.first_name, d.last_name;

SELECT 
    p.id AS patient_id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    SUM(pay.amount) AS total_paid,
    AVG(pay.amount) AS average_payment
FROM 
    Patients p
JOIN 
    Payments pay ON p.id = pay.patient_id
GROUP BY 
    p.id, p.first_name, p.last_name;

--PARTITION
SELECT 
    a.id AS appointment_id,
    a.appointment_date,
    d.id AS doctor_id,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name,
    COUNT(a.id) OVER (PARTITION BY d.id) AS total_appointments_for_doctor,
    ROW_NUMBER() OVER (PARTITION BY d.id ORDER BY a.appointment_date) AS appointment_number
FROM 
    Appointments a
JOIN 
    Doctors d ON a.doctor_id = d.id;

SELECT 
    pay.id AS payment_id,
    pay.patient_id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    pay.amount AS payment_amount,
    SUM(pay.amount) OVER (PARTITION BY pay.patient_id) AS total_paid_by_patient,
    ROUND(
        pay.amount * 100.0 / SUM(pay.amount) OVER (PARTITION BY pay.patient_id),
        2
    ) AS payment_percentage
FROM 
    Payments pay
JOIN 
    Patients p ON pay.patient_id = p.id;

--UNION
SELECT 
    first_name,
    last_name,
    'Patient' AS role
FROM 
    Patients
UNION
SELECT 
    first_name,
    last_name,
    'Doctor' AS role
FROM 
    Doctors;

--EXISTS
SELECT 
    p.id AS patient_id,
    p.first_name,
    p.last_name,
    p.email
FROM 
    Patients p
WHERE 
    EXISTS (
        SELECT 1
        FROM Appointments a
        WHERE a.patient_id = p.id
    );

--CASE
SELECT 
    d.id AS doctor_id,
    d.first_name,
    d.last_name,
    d.experience_years,
    CASE
        WHEN d.experience_years < 10 THEN 'Young Specialist'
        WHEN d.experience_years BETWEEN 5 AND 15 THEN 'Experienced Doctor'
        ELSE 'Expert'
    END AS doctor_status
FROM 
    Doctors d;
