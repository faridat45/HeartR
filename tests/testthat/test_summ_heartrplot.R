##devtools::install()

library(testthat)
library(HeartR)

test_that("plot_summary returns an interactive plot", {
  p <- plot_summary(heart_dat, "Age")
expect_s3_class(p, "plotly")
})
