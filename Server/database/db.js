const { Sequelize } = require("sequelize");
require("dotenv").config();

const { dbname, dbuser, dbpassword } = process.env;

const db = new Sequelize(dbname, dbuser, dbpassword, {
	host: "localhost",
	dialect: "postgres",
});

module.exports = db;
