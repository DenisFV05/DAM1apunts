
CREATE DATABASE IF NOT EXISTS MovieEngagement_Fernandez_Denis;
USE MovieEngagement_Fernandez_Denis;


CREATE TABLE theater (
	id int auto_increment primary key not null,
    name VARCHAR(50)
	);


CREATE TABLE movie (
	id INT auto_increment primary key not null,
	name VARCHAR(50) NULL,
	minutes INT
	);

CREATE TABLE screen (
	id INT auto_increment primary key not null,
	theater_id INT,
	name VARCHAR(50) NULL,
	seats INT
	);

CREATE TABLE engagement (
	theater_id INT auto_increment primary key not null,
	screen_id INT,
	movie_id INT,
	start_date DATE NOT NULL,
	end_date DATE,
	FOREIGN KEY (theater_id) REFERENCES theater(id),
    FOREIGN KEY (screen_id) REFERENCES screen(id),
    FOREIGN KEY (movie_id) REFERENCES movie(id)
	);

ALTER TABLE screen ADD FOREIGN KEY (theater_id) REFERENCES engagement (theater_id);
