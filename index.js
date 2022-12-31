const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const app = express();
const uuid = require("uuid");

// Mongo DB
const mongoose = require("mongoose");
async function main() {
    mongoose.set("strictQuery", false);
    mongoose.connect("mongodb://localhost:27017/extremerider", {
        useNewUrlParser: true,
        useUnifiedTopology: true,
    });
    console.log("Connected to MongoDB");
}
main();

const mongoDB = mongoose.connection;
mongoDB.on("error", console.error.bind(console, "connection error:"));

// Mongoose Schema for two car chatting
const chatSchema = new mongoose.Schema({
    _id: { type: String, default: uuid.v4 },
    person: String,
    message: String,
    time: { type: Date, default: Date.now },
});

const Chat = mongoose.model("Chat", chatSchema);

// MySQL
const mysql = require("mysql");
const db = mysql.createPool({
    host: "localhost",
    user: "root",
    password: "",
    database: "extreme_racer",
});

app.use(cors());
app.use(express.json());
app.use(bodyParser.urlencoded({ extender: true }));

app.get("/api/get_car_1/", (req, res) => {
    const sqlSelect =
        "SELECT x_axis, y_axis from cars_position where car_name='car_1'";
    db.query(sqlSelect, (err, result) => {
        //console.log(result)
        res.send(result);
    });
});

app.get("/api/get_car_2/", (req, res) => {
    const sqlSelect =
        "SELECT x_axis, y_axis from cars_position where car_name='car_2'";
    db.query(sqlSelect, (err, result) => {
        //console.log(result)
        res.send(result);
    });
});

app.post("/api/update_car_1", (req, res) => {
    const x_axis = req.body.x_axis;
    const y_axis = req.body.y_axis;
    const sqlUpdate =
        "UPDATE cars_position SET x_axis = ?,y_axis =? WHERE car_name = 'car_1'";
    db.query(sqlUpdate, [x_axis, y_axis], (err, result) => {
        //console.log(err)
        if (err) {
            res.send(result);
        } else {
            res.send(result);
        }
    });
});

app.post("/api/update_car_2", (req, res) => {
    const x_axis = req.body.x_axis;
    const y_axis = req.body.y_axis;
    const sqlUpdate =
        "UPDATE cars_position SET x_axis = ?,y_axis =? WHERE car_name = 'car_2'";
    db.query(sqlUpdate, [x_axis, y_axis], (err, result) => {
        //console.log(err)
        if (err) {
            res.send(result);
        } else {
            res.send(result);
        }
    });
});

app.get("/api/get_coins_earned/", (req, res) => {
    const sqlSelect = "SELECT player1_coins, player2_coins from coins_earned";
    db.query(sqlSelect, (err, result) => {
        //console.log(result)
        res.send(result);
    });
});

app.get("/api/get_total_wins/", (req, res) => {
    const sqlSelect = "SELECT player1_win, player2_win from total_win";
    db.query(sqlSelect, (err, result) => {
        //console.log(result)
        res.send(result);
    });
});

app.post("/api/update_total_coin", (req, res) => {
    //temporary coin table
    const player1_coin = req.body.player1_coin;
    const player2_coin = req.body.player2_coin;
    const sqlUpdate =
        "UPDATE coins_earned SET player1_coins = ?,player2_coins =?";
    db.query(sqlUpdate, [player1_coin, player2_coin], (err, result) => {
        if (err) {
            res.send(result);
            console.log(err);
        } else {
            res.send(result);
        }
    });
});

app.get("/api/get_chat/", (req, res) => {
    // chat time sort in ascending order
    Chat.find({}, (err, result) => {
        if (err) {
            res.send;
        } else {
            res.send(result);
        }
    }).sort({ time: 1 });
});

app.post("/api/insert_chat", (req, res) => {
    const person = req.body.person;
    const message = req.body.message;
    const chat = new Chat({
        person: person,
        message: message,
    });
    chat.save((err, result) => {
        if (err) {
            res.send(result);
        } else {
            res.send(result);
        }
    });
});

app.listen(3001, () => {
    console.log("running");
});
