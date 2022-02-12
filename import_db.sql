PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id TEXT NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Robert', 'Neal'),
  ('Bert', 'Neal'),
  ('Rob', 'Neal'),
  ('Bob', 'Neal');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('Is Bert the best nickname for Robert?','The only correct answer is yes. Prove me wrong bitches.', 2),
  ('Can we kick Bert out of this group?', 'His obsession about his name is pretentious', 1),
  ('Can''t we all just get along?', 'We''re all here to learn, let''s just be nice.', 4),
  ('Is my internet working?', 'Testing 123', 4);

INSERT INTO
  question_follows (question_id, user_id)
VALUES
  (1, 2),
  (1, 1),
  (2, 1),
  (2, 2),
  (2, 3),
  (2, 4),
  (3, 4);

INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  (1, NULL, 4, 'I think everyone''s name is equally great.'),
  (1, 1, 2, 'Lol, fuck off Bob, your name is clearly the worst so you have no say.'),
  (1, 2, 4, 'I like my name.'),
  (1, NULL, 3, 'No.'),
  (1, 4, 2, 'Yes.'),
  (2, NULL, 3, 'Yes please.'),
  (2, NULL, 4, 'I think he could be more nice, but we shouldn''t kick him out.'),
  (2, 7, 2, 'STFU Bob, no one cares what you think.'),
  (3, NULL, 4, 'Why is no one replying? Maybe my internet isn''t working.'),
  (1, NULL, 1, 'It''s only half as good as mine.'),
  (1, 10, 2, 'Keeping dreaming, idiot.');

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  (1, 2),
  (2, 1),
  (2, 3),
  (2, 4);