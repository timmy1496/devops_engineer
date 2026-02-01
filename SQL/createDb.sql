DROP DATABASE IF EXISTS SchoolDB;
CREATE DATABASE SchoolDB
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE SchoolDB;

CREATE TABLE Institutions (
                              institution_id INT AUTO_INCREMENT PRIMARY KEY,
                              institution_name VARCHAR(255) NOT NULL,
                              institution_type ENUM('School', 'Kindergarten') NOT NULL,
                              address VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Classes (
                         class_id INT AUTO_INCREMENT PRIMARY KEY,
                         class_name VARCHAR(100) NOT NULL,
                         institution_id INT NOT NULL,
                         institution_direction ENUM('Mathematics', 'Biology and Chemistry', 'Language Studies') NOT NULL,
                         CONSTRAINT fk_classes_institution
                             FOREIGN KEY (institution_id) REFERENCES Institutions(institution_id)
                                 ON DELETE CASCADE
                                 ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Children (
                          child_id INT AUTO_INCREMENT PRIMARY KEY,
                          first_name VARCHAR(100) NOT NULL,
                          last_name  VARCHAR(100) NOT NULL,
                          birth_date DATE NOT NULL,
                          year_of_entry YEAR NOT NULL,
                          age INT NOT NULL,
                          institution_id INT NOT NULL,
                          class_id INT NOT NULL,
                          CONSTRAINT fk_children_institution
                              FOREIGN KEY (institution_id) REFERENCES Institutions(institution_id)
                                  ON DELETE RESTRICT
                                  ON UPDATE CASCADE,
                          CONSTRAINT fk_children_class
                              FOREIGN KEY (class_id) REFERENCES Classes(class_id)
                                  ON DELETE RESTRICT
                                  ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Parents (
                         parent_id INT AUTO_INCREMENT PRIMARY KEY,
                         first_name VARCHAR(100) NOT NULL,
                         last_name  VARCHAR(100) NOT NULL,
                         child_id INT NOT NULL,
                         tuition_fee DECIMAL(10,2) NOT NULL,
                         CONSTRAINT fk_parents_child
                             FOREIGN KEY (child_id) REFERENCES Children(child_id)
                                 ON DELETE CASCADE
                                 ON UPDATE CASCADE
) ENGINE=InnoDB;
