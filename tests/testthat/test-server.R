testServer(server, {
  session$setInputs(currencyInput = "USD")
  expect_equal(moneyIconReac(), "dollar-sign")
})
