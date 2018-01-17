CREATE TABLE yogis (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  instructor_id INTEGER,

  FOREIGN KEY(instructor_id) REFERENCES teacher(id)
);

CREATE TABLE teachers (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  studio_id INTEGER,

  FOREIGN KEY(studio_id) REFERENCES teacher(id)
);

CREATE TABLE studios (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  studios (id, address)
VALUES
  (1, "26th and Guerrero"), (2, "Dolores and Market");

INSERT INTO
  teachers (id, fname, lname, studio_id)
VALUES
  (1, "Avana", "Watts", 1),
  (2, "Peace", "Rubens", 1),
  (3, "Helios", "Ruggeri", 2),
  (4, "Kate", "Jones", NULL);

INSERT INTO
  yogis (id, name, instructor_id)
VALUES
  (1, "Alana", 1),
  (2, "Jerry", 2),
  (3, "Nancy", 3),
  (4, "Elliot", 3),
  (5, "Bruce", NULL);
