from db_config import connect_db
from prettytable import PrettyTable


class AdminService:
    def __init__(self):
        self.conn = connect_db()

    def manage_service(self):
        with self.conn.cursor() as cur:
            print("\n=== Добавление/обновление услуги ===")

            service_id = input("Введите ID услуги (если новая, оставьте пустым): ")
            name = input("Введите название услуги: ")
            description = input("Введите описание услуги: ")
            cost = float(input("Введите стоимость услуги: "))
            category_id = int(input("Введите ID категории: "))

            # Если ID пустое, передаем None
            if not service_id:
                service_id = None
            else:
                service_id = int(service_id)

            try:
                query = """
                    SELECT * FROM manage_service(%s, %s, %s, %s, %s)
                """
                cur.execute(query, (service_id, name, description, cost, category_id))
                result = cur.fetchone()

                if result:
                    print(result[0])  # Выводим сообщение о результате
            except Exception as e:
                print(f"Ошибка при добавлении/обновлении услуги: {e}")

    def display_admins(self):
        """Вывод списка администраторов с информацией о сервисах и профилях"""
        print("\n=== Список администраторов ===")
        try:
            with self.conn.cursor() as cur:
                # Выполним запрос с объединением таблиц Administrators, Services и DoctorProfiles
                cur.execute("""
                    SELECT a.id, a.first_name, a.last_name, a.contact_info, 
                           s.name AS service_name, s.description AS service_description, 
                           p.bio AS profile_bio, p.awards AS profile_awards
                    FROM Administrators a
                    LEFT JOIN Services s ON a.service_id = s.id
                    LEFT JOIN DoctorProfiles p ON a.profile_id = p.id
                """)
                rows = cur.fetchall()

                # Создаем таблицу PrettyTable с новыми полями
                table = PrettyTable()
                table.field_names = ["ID", "Имя", "Фамилия", "Контактная информация",
                                     "Название услуги", "Описание услуги",
                                     "Инфо о враче", "Награды"]

                # Добавляем строки в таблицу
                for row in rows:
                    table.add_row(row)

                print(table)
        except Exception as e:
            print(f"Ошибка: {e}")

    def display_services(self):
        """Вывод таблицы медицинских услуг"""
        print("\n=== Список медицинских услуг ===")
        try:
            with self.conn.cursor() as cur:
                cur.execute("SELECT id, name, cost, category_id FROM Services")
                rows = cur.fetchall()

                table = PrettyTable()
                table.field_names = ["ID", "Название", "Стоимость", "ID Категории"]
                for row in rows:
                    table.add_row(row)

                print(table)
        except Exception as e:
            print(f"Ошибка: {e}")

    def delete_service(self):
        with self.conn.cursor() as cur:
            print("\n=== Удаление услуги ===")

            service_id = int(input("Введите ID услуги для удаления: "))

            try:
                query = """
                    SELECT * FROM delete_service(%s)
                """
                cur.execute(query, (service_id,))
                result = cur.fetchone()

                if result:
                    print(result[0])  # Выводим сообщение о результате
            except Exception as e:
                print(f"Ошибка при удалении услуги: {e}")

