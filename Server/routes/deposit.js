const { Router } = require("express");
const { Op } = require("sequelize");
const Deposits = require("../models/deposits");
const Balances = require("../models/balances");
const router = Router();

router.post("/new", async (req, res) => {
	try {
		let { amount } = req.body;

		amount = parseInt(amount);
		if (!amount) {
			return res
				.status(400)
				.json({ message: "Please input amount to deposit" });
		}

		if (amount > 40000) {
			return res
				.status(400)
				.json({ message: "Amount exceeds allowed deposit amount" });
		}

		const tomorrow = new Date();
		const today = new Date();
		const offset = new Date().getTimezoneOffset() / 60;

		today.setHours(0 - offset, 0, 0, 0);
		tomorrow.setHours(24 - offset, 0, 0, 0);

		const makeDeposit = (amount) => {
			Deposits.create({ amount })
				.then(() => {
					Balances.findAll()
						.then((results) => {
							if (results.length == 0) {
								Balances.create({ amount })
									.then(() => {
										return res
											.status(200)
											.json({ message: "Deposit successfully made" });
									})
									.catch((err) => {
										return res.status(400).json({ message: err.message });
									});
							} else {
								Balances.findOne({
									where: {
										createdAt: {
											[Op.lt]: tomorrow,
										},
									},
								})
									.then((balance) => {
										Balances.update(
											{ amount: parseInt(balance.amount) + amount },
											{
												where: {
													id: balance.id,
												},
											}
										)
											.then(() => {
												return res
													.status(200)
													.json({ message: "Deposit successfully made" });
											})
											.catch((err) => {
												return res.status(400).json({ message: err.message });
											});
									})
									.catch((err) => {
										return res.status(400).json({ message: err.message });
									});
							}
						})
						.catch((err) => {
							return res.status(400).json({ message: err.message });
						});
				})
				.catch((err) => {
					return res.status(500).json({ message: err.message });
				});
		};

		await Deposits.findAll({
			where: {
				createdAt: {
					[Op.lt]: tomorrow,
					[Op.gt]: today,
				},
			},
		})
			.then((deposits) => {
				let todayDeposits = 0;
				deposits.forEach((deposit) => {
					todayDeposits += parseInt(deposit["amount"]);
				});

				if (deposits.length === 0) {
					makeDeposit(amount);
				} else if (deposits.length >= 4) {
					return res
						.status(400)
						.json({ message: "Maximum deposit frequency reached" });
				} else if (todayDeposits >= 150000) {
					return res
						.status(400)
						.json({ message: "Maximum deposit amount reached" });
				} else if (todayDeposits + amount > 150000) {
					return res.status(400).json({
						message:
							"Maximum deposit amount will be exceeded after making this deposit",
					});
				} else {
					makeDeposit(amount);
				}
			})
			.catch((err) => {
				return res.status(500).json({ message: err.message });
			});
	} catch (err) {
		return res.status(500).json({ message: err.message });
	}
});

module.exports = router;
