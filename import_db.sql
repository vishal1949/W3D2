PRAGMA foreign_keys = ON;
DROP TABLE if exists question_likes;
DROP TABLE if exists replies;
DROP TABLE if exists question_follows;
DROP TABLE if exists questions;
DROP TABLE if exists users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname varchar(255) NOT NULL,
  lname varchar(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  reply_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (reply_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO 
  users(fname, lname)
VALUES
  ('Vishal', 'Sandhu'),
  ('Dannnnny', 'Yan'),
  ('Louis', 'Leon');
INSERT INTO
  questions(title, body, author_id)
VALUES
  ('sup?', 'im new to the singles scene', 1 ),
  ('sup?', '2 im new to the singles scene', 2 ),
  ('what is ruby?', 'how do i mine it?', 3);

INSERT INTO
  replies(question_id, reply_id, user_id, body)
VALUES
  (1, NULL, 1, "PLS RSPOND my talk not answer"),
  (1, 1, 2, "im single n rdy 2 mngl");

INSERT INTO
  question_follows(user_id, question_id)
VALUES  
  (1,1),
  (2,1),
  (2,2),
  (3,3);


INSERT INTO 
  question_likes(user_id, question_id)
VALUES 
  (1,2),
  (2,2),
  (3,2),
  (2,1);