const { Sequelize } = require("sequelize");
const db = require("../database/db");

const Balances = db.define("Balances", {
	amount: Sequelize.BIGINT,
});

module.exports = Balances;
