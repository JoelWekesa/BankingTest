const { Sequelize } = require("sequelize");
const db = require("../database/db");

const Withdrawals = db.define("Withdrawals", {
	amount: Sequelize.BIGINT,
});

module.exports = Withdrawals;
