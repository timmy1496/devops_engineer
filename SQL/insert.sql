USE SchoolDB;

INSERT INTO Institutions (institution_name, institution_type, address) VALUES
                                                                           ('Kyiv Lyceum #21', 'School', 'Kyiv, Shevchenka St. 10'),
                                                                           ('Lviv Gymnasium "Harmony"', 'School', 'Lviv, Hnatyuka St. 5'),
                                                                           ('Kindergarten "Sunflower"', 'Kindergarten', 'Kyiv, Peremohy Ave. 120');

INSERT INTO Classes (class_name, institution_id, direction) VALUES
                                                                ('5-A', 1, 'Mathematics'),
                                                                ('7-B', 2, 'Language Studies'),
                                                                ('Senior Group', 3, 'Biology and Chemistry');

INSERT INTO Children (first_name, last_name, birth_date, year_of_entry, age, institution_id, class_id) VALUES
                                                                                                           ('Andrii', 'Koval', '2012-04-18', 2022, 12, 1, 1),
                                                                                                           ('Sofia',  'Melnyk','2010-11-02', 2021, 14, 2, 2),
                                                                                                           ('Mykola', 'Shevchenko', '2019-06-30', 2024, 5, 3, 3);

INSERT INTO Parents (first_name, last_name, child_id, tuition_fee) VALUES
                                                                       ('Olena', 'Koval', 1, 12000.00),
                                                                       ('Ihor',  'Melnyk', 2, 15000.00),
                                                                       ('Natalia','Shevchenko', 3,  8000.00);
