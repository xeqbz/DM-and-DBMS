CREATE TABLE Patients (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	date_of_birth DATE NOT NULL,
	adress VARCHAR(255),
	phone_number VARCHAR(20),
	email VARCHAR(100) UNIQUE NOT NULL,
	password VARCHAR(100) NOT NULL,
	registration_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE DoctorSpecializations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE ServiceCategories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE Services (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    cost DECIMAL(10, 2) NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES ServiceCategories(id)
);

CREATE TABLE Doctors (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	specialization_id INT NOT NULL,
    experience_years INT NOT NULL,
    contact_info VARCHAR(255),
    FOREIGN KEY (specialization_id) REFERENCES DoctorSpecializations(id)
);

CREATE TABLE DoctorProfiles (
    id SERIAL PRIMARY KEY,
    doctor_id INT UNIQUE NOT NULL,
    bio TEXT,
    awards TEXT,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(id)
);

CREATE TABLE Administrators (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255),
    service_id INT NOT NULL,
    profile_id INT NOT NULL,
    FOREIGN KEY (service_id) REFERENCES Services(id),
    FOREIGN KEY (profile_id) REFERENCES DoctorProfiles(id)
);

CREATE TABLE Appointments (
    id SERIAL PRIMARY KEY,
    appointment_date TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    administrator_id INT,
    FOREIGN KEY (patient_id) REFERENCES Patients(id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(id),
    FOREIGN KEY (administrator_id) REFERENCES Administrators(id)
);

CREATE TABLE MedicalRecords (
    id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    diagnosis TEXT NOT NULL,
    prescriptions TEXT,
    recommendations TEXT,
    visit_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(id)
);

CREATE TABLE Payments (
    id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    appointment_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_status VARCHAR(50) NOT NULL,
    payment_method VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES Patients(id),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(id)
);

CREATE TABLE Schedules (
    id SERIAL PRIMARY KEY,
    doctor_id INT UNIQUE NOT NULL,
    day_of_week VARCHAR(50) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(id)
);

CREATE TABLE AppointmentServices (
    id SERIAL PRIMARY KEY,
    appointment_id INT NOT NULL,
    service_id INT NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(id),
    FOREIGN KEY (service_id) REFERENCES Services(id)
);

CREATE TABLE UserActionLogs (
    id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    date_and_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255),
    FOREIGN KEY (patient_id) REFERENCES Patients(id)
);
