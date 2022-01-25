DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS lessons CASCADE;
DROP TABLE IF EXISTS lessonparticipants;
DROP TABLE IF EXISTS lessonreflections;

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

-- INSERT INTO users(username,emailaddress,age,qualification,preferredname)
-- VALUES ('MathematicsForever','ember.emma.emmer@gmail.com',25,'N/A', 'Emma');

