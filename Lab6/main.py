from user_service import UserService
from doctor_service import DoctorService
from admin_service import AdminService


def main():
    user_service = UserService()
    doctor_service = DoctorService()
    admin_service = AdminService()

    while True:
        print("\n1. Пациент")
        print("2. Врач")
        print("3. Администратор")
        print("4. Список пациентов")
        print("5. Список врачей")
        print("6. Список админов")
        print("7. Список услуг")
        print("0. Выйти")
        role = input("Выберите роль: ")

        if role == "1":
            print("\n1. Регистрация")
            print("2. Вход")
            print("3. Запись на прием")
            print("4. Изменить запись")
            print("5. Оплатить запись")
            print("6. Обновить профиль")
            action = input("Выберите действие: ")
            if action == "1":
                user_service.register_user()
            elif action == "2":
                user_service.login_user()
            elif action == "3":
                user_service.book_appointment()
            elif action == "4":
                user_service.cancel_or_update_appointment()
            elif action == "5":
                user_service.pay_for_service()
            elif action == "6":
                user_service.update_patient_profile()
        elif role == "2":
            print("\n1. Посмотреть расписание")
            print("2. Посмотреть карточу пациента")
            action = input("Выберите действие: ")
            if action == "1":
                doctor_service.view_schedule()
            if action == "2":
                doctor_service.view_medical_record()
        elif role == "3":
            print("\n1. Добавить/изменить услугу")
            print("2. Удалить услугу")
            action = input("Выберите действие: ")
            if action == "1":
                admin_service.manage_service()
            if action == "2":
                admin_service.delete_service()
        elif role == '4':
            user_service.display_patients()
        elif role == '5':
            doctor_service.display_doctors()
        elif role == '6':
            admin_service.display_admins()
        elif role == '7':
            admin_service.display_services()
        elif role == "0":
            print("До свидания!")
            break


if __name__ == "__main__":
    main()
