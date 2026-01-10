##devtools::install()

library(testthat)
library(HeartR)

test_that("summ_heartrplot returns an interactive plot", {
  p <- summ_heartrplot(heart_dat, "age")
expect_s3_class(p, "plotly")
})
