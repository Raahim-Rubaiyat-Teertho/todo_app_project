const express = require("express");
const firebase = require("firebase");
const cors = require("cors");
const cron = require("node-cron");
const Users = require("./config");
const { Timestamp, FieldValue } = require("firebase-admin/firestore");
const { firestore } = require("firebase");

const app = express();
app.use(express.json());
app.use(cors());

app.get("/all", async (req, res) => {
  try {
    const usersSnapshot = await Users.get();
    const usersList = usersSnapshot.docs.map((doc) => doc.data());
    res.status(200).json(usersList);
  } catch (error) {
    console.error("Error getting users:", error);
    res.status(500).send("Error retrieving users");
  }
});

app.get("/pushDaily", async (req, res) => {
  try {
    const usersSnapshot = await Users.get();
    usersSnapshot.docs.map((doc) => {
      const data = doc.data();

      console.log("--------------------------------");
      const ls = [];
      for (let i = 0; i < data["dailys"].length; i++) {
        ls.push({
          task: data["dailys"][i].title,
          time: new Date(),
        });
      }
      const new_todo = [...data["todo"]];
      for (let i = 0; i < ls.length; i++) {
        new_todo.push(ls[i]);
      }
      Users.doc(doc.id).update({ todo: new_todo });
    });
    res.status(200).send("pushDaily task completed");
  } catch (error) {
    console.error("Error getting users:", error);
    res.status(500).json({ message: "Error getting users" });
  }
});

app.get("/removeWeeklyHistory", async (req, res) => {
  try {
    const usersSnapshot = await Users.get();

    usersSnapshot.docs.map(async (doc) => {
      console.log(doc.data()["done"]);
      const userRef = Users.doc(doc.id);

      await userRef.update({ done: [] });
      console.log(`Updated history for user ${doc.id}`);
    });
    res.status(200).send("All weekly completed histories have been cleared.");
  } catch (error) {
    console.log(error);
  }
});

cron.schedule("0 6 * * *", async () => {
  console.log("Running pushDaily task...");
  try {
    const response = await fetch("http://localhost:3000/pushDaily");
    if (response.ok) {
      console.log("pushDaily task completed.");
    } else {
      console.error("Failed to complete pushDaily task:", response.statusText);
    }
  } catch (error) {
    console.error("Error running pushDaily task:", error);
  }
});

cron.schedule("0 6 * * 0", async () => {
  console.log("Running weekly task...");
  try {
    const response = await fetch("http://localhost:3000/removeWeeklyHistory");
    if (response.ok) {
      console.log("Weekly task completed.");
    } else {
      console.error("Failed to complete weekly task:", response.statusText);
    }
  } catch (error) {
    console.error("Error running pushDaily task:", error);
  }
});

// Start the server
app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
