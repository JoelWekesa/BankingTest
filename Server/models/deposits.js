const { Sequelize } = require("sequelize");
const db = require("../database/db")

const Deposits = db.define('Deposits', {
    amount: Sequelize.BIGINT,
})

module.exports = Deposits