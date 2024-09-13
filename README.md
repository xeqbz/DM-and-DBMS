# Тема: Платная поликлиника
ФИО: Царук Вадим Александрович  
Номер группы: 253503  
## Функциональные требования  
1. Регистрация и аутентификация:  
   - Пользователи могут зарегистрировать аккаунт.  
   - Пользователи могут войти в аккаунт с помощью своиж учетных данных(Email и пароль).
2. Управление записями на прием:
   - Пользователи могут записатья на прием к врачу, выбрав доступное время.
   - Возможность отмены или изменения записи.
3. Управление медицинскими услугами:
   - Администраторы могут добавлять/редактировать список медицинских услуг и их стоимость.
   - Пользователи могут просматривать список предоставляемых услуг и их стоимость.
4. Система управления медицинскими картами:
   - Ведение медицинской карты пациента, которая хранит историю приемов, диагнозы, результаты анализов и назначения.
5. Оплата услуг:
   - Пациент может оплатить услугу онлайн через систему.
   - Возможность хранения истории платежей и квитанций.
6. Управление персоналом клиники:
   - Администраторы могут управлять информацией о врачах и медицинском персонале.
   - Врачи могут просматривать своё расписание и информацию о пациентах.
7. Отчеты и статистика:
   - Администраторы могут получать отчеты по числу пациентов, проведенным услугам, доходам и т.д.
8. Уведомления:
   - Система предоставляет пользователям уведомления об их записях к врачам.
9. Управление профилем пользователя:
   - Пользователи могут обновлять информацию о своем профиле (например, имя, фамилия, пароль).
   - Пользователи могут просматривать свой профиль и историю действий.
## Описание сущностей ДБ
**Сущность "Пациент"(Patient)**
- id(INT, PK) - связь один ко многим с Appointmet, связь один ко многим с Payment, связь один ко многим с MedicalRecord, связь один ко многим с UserActionLog
- first_name(VARCHAR)
- last_name(VARCHAR)
- date_of_birth(DATE)
- adress(VARCHAR)
- phone_number(VARCHAR)
- email(VARCHAR)
- password(VARCHAR)
- registration_date(DATE)

**Сущность "Врач"(Doctor)**
- id(INT, PK) - связь один ко многим с Appointment, связь один ко многим с MedicalRecord, связь один к одному с DoctorProfile, связь один к одному с Schedule
- first_name(VARCHAR)
- last_name(VARCHAR)
- specialization_id(INT, FK) - связь многие к одному с DoctorSpezialization
- experience_years(INT)
- contact_info(VARCHAR)

**Сущность "Услуга"(Service)**  
- id(INT, PK) - связь многие ко многим с Appointment через таблицу AppointmentService
- name(VARCHAR)
- description(VARCHAR)
- cost(DECIMAL)
- category_id(INT, FK) - связь многие к одному с ServiceCategory

**Сущность "Запись на прием"(Appointment)**  
- id(INT, PK) - связь один ко многим с Payment, связь многие ко многим с Service через таблицу AppoinmentService
- appointment_date(DATETIME)
- status(VARCHAR)
- patient_id(INT, FK) - связь многие к одному с Patient
- doctor_id(INT, FK) - связь многие к одному с Doctor
- administrator_id(INT, FK) - связь многие к одному с Administrator

**Сущность "Медицинская карта"(MedicalRecord)**  
- id(INT, PK)
- patient_id(INT, FK) - связь многие к одному с Patient
- doctor_id(INT, FK) - связь многие к одному с Doctor
- diagnosis(TEXT)
- prescriptions(TEXT)
- recommendations(TEXT)
- visit_date(date)

**Сущность "Платеж"(Payment)**  
- id(INT, PK)
- patient_id(INT, FK) - связь многие к одному с Patient
- appointment_id(INT, FK) - связь многие к одному с Appointment
- amount(decimal)
- payment_date(DATETIME)
- payment_status(VARCHAR)
- payment_method(VARCHAR)

**Сущность "Администратор"(Administrator)**  
- id(INT, PK) - связь один ко мноним с Appointment
- first_name(VARCHAR)
- last_name(VARCHAR)
- contact_info(VARCHAR)

**Сущность "Категория услуги"(ServiceCategory)**  
- id(INT, PK) - связь один ко многим с Service
- name(VARCHAR)
- description(TEXT)

**Сущность "Специализация врача"(DoctorSpecialization)**  
- id(INT, PK) - связь один ко многим с Doctor
- name(VARCHAR)
- description(TEXT)

**Сущность "Профиль врача"(DoctorProfile)**  
- id(INT, PK)
- doctor_id(INT, FK) - связь один к одному с Doctor
- bio(TEXT)
- awards(TEXT)
- photo_url(VARCHAR)

**Сущность "График работы"(Schedule)**  
- id(INT, PK)
- doctor_id(INT, FK) - связь один к одному с Doctor
- day_of_week(VARCHAR)
- start_time(TIME)
- end_time(TIME)

**Сущность AppointmentService**  
- id(INT, PK)
- appointment_id(INT, FK) - связь многие к одному с Appointment
- service_id(INT, FK) - связь многие к одному с Service

**Сущность "Журнал действия пользователя"(UserActionLog)**  
- id(INT, PK)
- patient_id(INT, FK) - связь многие к одному с Patient
- date_and_time(DATETIME)
- description(VARCHAR)

## Схема БД
![](DB.drawio.svg)
