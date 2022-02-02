DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS lessons CASCADE;
DROP TABLE IF EXISTS lessonparticipants;
DROP TABLE IF EXISTS lessonreflections;
DROP TABLE IF EXISTS lessoncounts;

CREATE TABLE users (
  userid SERIAL PRIMARY KEY,
  username VARCHAR(25) NOT NULL,
  emailaddress VARCHAR(100) NOT NULL,
  preferredname VARCHAR(100) NOT NULL,
  age INT NOT NULL,
  qualification VARCHAR(100) NOT NULL
  );

CREATE TABLE lessons (
  lessonid SERIAL PRIMARY KEY,
  time	TIMESTAMPTZ NOT NULL,
  title VARCHAR(50) NOT NULL,
  description VARCHAR(1000)
  );

CREATE TABLE lessonparticipants (
  lessonid INT NOT NULL,
  userid INT NOT NULL,
  CONSTRAINT fk_lesson
  	FOREIGN KEY (lessonid)
  		REFERENCES lessons(lessonid),
  CONSTRAINT fk_user
  	FOREIGN KEY (userid)
  		REFERENCES users(userid)
  );
  
  CREATE TABLE lessonreflections (
    lessonid INT NOT NULL,
    userid INT NOT NULL,
    reflection VARCHAR NOT NULL,
    postedat TIMESTAMPTZ DEFAULT NOW()
    
   );

INSERT INTO users(username,emailaddress,age,qualification,preferredname)
VALUES ('MathematicsForever','ember.emma.emmer@gmail.com',25,'N/A', 'Emma');

INSERT INTO users(username,emailaddress,age,qualification,preferredname)
VALUES ('MathMagician','megan@gmail.com',17,'N/A', 'Megan');

INSERT INTO users(username,emailaddress,age,qualification,preferredname)
VALUES ('Louis','louis@gmail.com',17,'N/A', 'Louis');

INSERT INTO lessons(time,title,description)
VALUES ('2022-01-26 18:00','First Lesson', 'We will complete a past paper together');

INSERT INTO lessonparticipants (lessonid,userid)
VALUES (1,2);

INSERT INTO lessonparticipants (lessonid,userid)
VALUES (1,1);

INSERT INTO lessonparticipants (lessonid,userid)
VALUES (1,3);


-- SELECT count(*) FROM lessons JOIN lessonparticipants ON lessons.lessonid=lessonparticipants.lessonid WHERE lessons.lessonid=1 ;



CREATE TABLE lessoncounts AS
SELECT lessons.lessonid, title, description, time, COUNT(lessonparticipants.lessonid)::int AS participants 
FROM lessons JOIN lessonparticipants
ON lessons.lessonid=lessonparticipants.lessonid
GROUP BY lessons.lessonid;



select lessoncounts.lessonid,title,description,time,participants from lessoncounts join lessonparticipants on lessoncounts.lessonid=lessonparticipants.lessonid where userid=1;

