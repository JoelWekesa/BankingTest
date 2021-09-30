const { Router } = require("express");
const { Op } = require("sequelize");
const Withdrawals = require("../models/Withdrawals");
const Balances = require("../models/balances");
const router = Router();

router.post("/new", async (req, res) => {
	try {
		let { amount } = req.body;

		amount = parseInt(amount);
		if (!amount) {
			return res
				.status(400)
				.json({ message: "Please input amount to withdraw" });
		}

		if (amount > 40000) {
			return res
				.status(400)
				.json({ message: "Amount exceeds allowed withdraw amount" });
		}

		const tomorrow = new Date();
		const today = new Date();
		const offset = new Date().getTimezoneOffset() / 60;

		today.setHours(0 - offset, 0, 0, 0);
		tomorrow.setHours(24 - offset, 0, 0, 0);

		const makeWithdrawal = (amount) => {
			Withdrawals.create({ amount })
				.then(() => {
					Balances.findAll()
						.then((results) => {
							let totalBalance = 0;
							results.forEach((balance) => {
								totalBalance += parseInt(balance["amount"]);
							});

							if (amount > totalBalance) {
								return res
									.status(400)
									.json({ message: "Overdraft is currently unavailable" });
							} else if (results.length == 0) {
								return res.status(400).json({
									message:
										"You do not have any funds in your account. Please deposit some.",
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
											{ amount: parseInt(balance.amount) - amount },
											{
												where: {
													id: balance.id,
												},
											}
										)
											.then(() => {
												return res
													.status(200)
													.json({ message: "Withdrawal successfully made" });
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

		await Withdrawals.findAll({
			where: {
				createdAt: {
					[Op.lt]: tomorrow,
					[Op.gt]: today,
				},
			},
		})
			.then((results) => {
				let todayWithdrawals = 0;
				results.forEach((result) => {
					todayWithdrawals += parseInt(result["amount"]);
				});

				if (results.length === 0) {
					makeWithdrawal(amount);
				} else if (results.length >= 3) {
					return res
						.status(400)
						.json({ message: "Maximum withdraw frequency reached" });
				} else if (todayWithdrawals >= 50000) {
					return res
						.status(400)
						.json({ message: "Maximum withdraw amount reached" });
				} else if (todayWithdrawals + amount > 50000) {
					return res.status(400).json({
						message:
							"Maximum withdraw amount will be exceeded after making this withdraw",
					});
				} else if (amount > 20000) {
					return res.status(400).json({
						message: "Cannot exceed maximum withdrawal per transaction",
					});
				} else {
					makeWithdrawal(amount);
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
