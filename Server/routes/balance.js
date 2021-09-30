const { Router } = require("express");
const { Op } = require("sequelize");
const Balances = require("../models/balances");

const router = Router();

router.get("/", async (req, res) => {
	try {
		const tomorrow = new Date();
		const offset = new Date().getTimezoneOffset() / 60;

		tomorrow.setHours(24 - offset, 0, 0, 0);
		Balances.findAll()
			.then((balances) => {
				let totalBalance = 0;
				balances.forEach((balance) => {
					totalBalance += parseInt(balance["amount"]);
				});
				if (balances.length === 0) {
					return res.status(200).json({ amount: 0 });
				} else {
					return res.status(200).json({ amount: totalBalance });
				}
			})
			.catch((err) => {
				return res.status(400).json({ message: err.message });
			});
	} catch (err) {
		return res.status(500).json({ message: err.message });
	}
});

module.exports = router;
