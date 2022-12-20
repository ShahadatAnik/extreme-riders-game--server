const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')
const app = express()
const mysql = require('mysql')

const db = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'extreme_racer'
});

app.use(cors())
app.use(express.json())
app.use(bodyParser.urlencoded({extender: true}));

app.get('/api/get_car_1/', (req,res)=>{
    const sqlSelect = "SELECT x_axis, y_axis from cars_position where car_name='car_1'";
    db.query(sqlSelect, (err, result)=>{
        //console.log(result)
        res.send(result);
    });
});

app.get('/api/get_car_2/', (req,res)=>{
    const sqlSelect = "SELECT x_axis, y_axis from cars_position where car_name='car_2'";
    db.query(sqlSelect, (err, result)=>{
        //console.log(result)
        res.send(result);

    });
});

app.post('/api/update_car_1', (req, res)=>{
    const x_axis = req.body.x_axis
    const y_axis = req.body.y_axis
    const sqlUpdate = "UPDATE cars_position SET x_axis = ?,y_axis =? WHERE car_name = 'car_1'"
    db.query(sqlUpdate, [x_axis, y_axis], (err, result)=>{
        //console.log(err)
        if(err){
            res.send(result)
        }
        else{
            res.send(result)
        }
    });
    
})

app.post('/api/update_car_2', (req, res)=>{
    const x_axis = req.body.x_axis
    const y_axis = req.body.y_axis
    const sqlUpdate = "UPDATE cars_position SET x_axis = ?,y_axis =? WHERE car_name = 'car_2'"
    db.query(sqlUpdate, [x_axis, y_axis], (err, result)=>{
        //console.log(err)
        if(err){
            res.send(result)
        }
        else{
            res.send(result)
        }
    });
    
})

app.get('/api/get_coins_earned/', (req,res)=>{
    const sqlSelect = "SELECT player1_coins, player2_coins from coins_earned";
    db.query(sqlSelect, (err, result)=>{
        //console.log(result)
        res.send(result);
    });
});

app.get('/api/get_total_wins/', (req,res)=>{
    const sqlSelect = "SELECT player1_win, player2_win from total_win";
    db.query(sqlSelect, (err, result)=>{
        //console.log(result)
        res.send(result);
    });
});

app.post('/api/update_total_wins', (req, res)=>{
    const player1_win = req.body.player1_win
    const player2_win = req.body.player2_win
    const sqlUpdate = "UPDATE total_win SET player1_win = ?,player2_win =?"
    db.query(sqlUpdate, [player1_win, player2_win], (err, result)=>{
        if(err){
            //res.send(result)
            console.log(err)
        }
        else{
            res.send(result)
        }
    });
    
})

app.listen(3001, ()=> {
    console.log("running")
})
