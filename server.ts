import { Client } from "pg";
import { config } from "dotenv";
import express from "express";
import cors from "cors";

config(); //Read .env file lines as though they were env vars.

//Call this script with the environment variable LOCAL set if you want to connect to a local db (i.e. without SSL)
//Do not set the environment variable LOCAL if you want to connect to a heroku DB.

//For the ssl property of the DB connection config, use a value of...
// false - when connecting to a local DB
// { rejectUnauthorized: false } - when connecting to a heroku DB
const herokuSSLSetting = { rejectUnauthorized: false };
const sslSetting = process.env.LOCAL ? false : herokuSSLSetting;
const dbConfig = {
  connectionString: process.env.DATABASE_URL,
  ssl: sslSetting,
};

const app = express();

app.use(express.json()); //add body parser to each following route handler
app.use(cors()); //add CORS support to each following route handler

const client = new Client(dbConfig);
client.connect();

app.get("/", async (req, res) => {
  res.json({
    Message: "Welcome to the my-maths-adventure API.",
    Documentation: "link to API documentation will be given here",
  });
});

app.get("/users", async (req, res) => {
  try {
    const dbres = await client.query(
      "select userid, username, preferredname, age, qualification from users"
    );
    res.status(200).json({ message: "success", users: dbres.rows });
  } catch (error) {
    console.error(error);
  }
});

app.post("/users", async (req, res) => {
  const { username, emailaddress, preferredname, age, qualification } =
    req.body;
  try {
    const dbres = await client.query(
      "INSERT INTO users (username, emailaddress, preferredname, age, qualification) VALUES ($1,$2,$3,$4,$5) returning *",
      [username, emailaddress, preferredname, age, qualification]
    );
    if (dbres.rows.length > 0) {
      res.status(200).json({
        status: "success",
        userAdded: dbres.rows[0],
      });
    }

    if (dbres.rows.length === 0) {
      res.status(200).json({
        status: "success",
        message: "no user added",
      });
    }
  } catch (error) {
    console.error(error);
    if (error.code === 23505 || error.code === "23505") {
      res.status(403).json({
        status: "failed",
        message:
          "user could not be added: the username or emailaddress already exists",
      });
    }
  }
});

app.get("/lessons/:userid", async (req, res) => {
  const userid = req.params.userid;
  try {
    const dbres = await client.query(
      "SELECT lessons.lessonid,time,title,description FROM lessons join lessonparticipants on lessons.lessonid=lessonparticipants.lessonid WHERE userid=$1",
      [userid]
    );
    res.status(200).json({ message: "success", lessons: dbres.rows });
  } catch (error) {
    console.error(error);
  }
});

app.get("/numberoflessonparticipants/:lessonid", async (req, res) => {
  const lessonid = req.params.lessonid;
  try {
    const dbres = await client.query(
      "SELECT count(*) FROM lessons JOIN lessonparticipants ON lessons.lessonid=lessonparticipants.lessonid WHERE lessons.lessonid=$1",
      [lessonid]
    );
    res.status(200).json({ message: "success", count: dbres.rows[0].count });
  } catch (error) {
    console.error(error);
  }
});

//Start the server on the given port
const port = process.env.PORT;
if (!port) {
  throw "Missing PORT environment variable.  Set it in .env file.";
}
app.listen(port, () => {
  console.log(`Server is up and running on port ${port}`);
});
