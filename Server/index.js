const express = require("express");
const cors = require("cors");
const { json, urlencoded } = require("express");
const db = require("./database/db");
const deposit = require("./routes/deposit");
const withdraw = require("./routes/withdrawals");
const balance = require("./routes/balance");

const app = express();

app.use(cors());
app.use(json());
app.use(urlencoded({ extended: false }));
app.use("/api/deposit", deposit);
app.use("/api/withdraw", withdraw);
app.use("/api/balance", balance);

const PORT = process.env.PORT || 5000;

try {
	db.authenticate();
	console.log("database successfully connected");
} catch (err) {
	console.log("unable to connect to db", err);
}

app.listen(PORT, (err) => {
	if (err) throw err;
	console.log("Server running");
});
