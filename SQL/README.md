# SchoolDB — MySQL

---

## Структура бази даних

### 1. База даних
- **Назва:** `SchoolDB`

### 2. Таблиці

**Institutions**
- `institution_id` (PK, AUTO_INCREMENT)
- `institution_name`
- `institution_type` (`School`, `Kindergarten`)
- `address`

**Classes**
- `class_id` (PK, AUTO_INCREMENT)
- `class_name`
- `institution_id` (FK → Institutions)
- `institution_direction` (`Mathematics`, `Biology and Chemistry`, `Language Studies`)

**Children**
- `child_id` (PK, AUTO_INCREMENT)
- `first_name`
- `last_name`
- `birth_date`
- `year_of_entry`
- `age`
- `institution_id` (FK → Institutions)
- `class_id` (FK → Classes)

**Parents**
- `parent_id` (PK, AUTO_INCREMENT)
- `first_name`
- `last_name`
- `child_id` (FK → Children)
- `tuition_fee`

---

## Виконані запити

- Отримання списку всіх дітей разом із закладом та напрямом навчання
- Отримання інформації про батьків, їхніх дітей та вартість навчання
- Отримання списку закладів з адресами та кількістю дітей у кожному

---

## Backup та відновлення

- Виконано резервне копіювання бази `SchoolDB` за допомогою `mysqldump`
- Відновлено дані у новій базі
- Перевірено збереження таблиць та зв’язків **FOREIGN KEY**

---

## Додаткове завдання: Анонімізація даних

### Виконані дії
- **Children:** імена та прізвища замінено на `Child` / `Anonymous`
- **Parents:** імена замінено на `Parent1`, `Parent2`, …; прізвища — `Anon`
- **Institutions:** назви замінено на `Institution1`, `Institution2`, …
- **tuition_fee:** змінено на випадкові значення у безпечному діапазоні

---

## Результат
- Створена повноцінна MySQL база даних з кількома пов’язаними таблицями
- Реалізовані та перевірені зв’язки FOREIGN KEY
- Виконані необхідні SQL-запити
- Дані успішно анонімізовані без порушення цілісності
- Процес реалізований та задокументований для навчальних цілей
