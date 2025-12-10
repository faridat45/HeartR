
# stats :: median, quantile, sd, var
# gt :: boatload of functions
# dplyr :: everything()
#utils :: tail

summ_heartr <- function(...){
  input <- list(...)

  names1 <- sapply(substitute(list(...))[-1], deparse)
  newnames <- sapply(names1, function(y){
    splitname <- strsplit(y, "\\$")[[1]]
    utils::tail(splitname, 1)
  })

  summ <- function(x, name){
    if(!is.numeric(x)) warning("argument is not numeric")

    data.frame(
      Variable = name,
      Mean = mean(x),
      Minimum = min(x),
      Q1 = stats::quantile(x, 0.25),
      Median = stats::median(x),
      Q3 = stats::quantile(x),
      Maximum = max(x),
      SD = stats::sd(x),
      Var = stats::var(x)
    )
  }

  if(length(input) == 1) {
    finalsumm <- summ(input[[1]], newnames[1])
    class(finalsum) <- "summ_heartr"
    return(finalsumm)
  }

  if (length(input) > 1) {
    list_output <- mapply(summ, input, name = newnames, SIMPLIFY = FALSE)

    finalsumm <- do.call(rbind, list_output)
    class(finalsumm <- "summ_heartr")
    return(finalsumm)
  }
}




print.summ_heartr<- function(x) {
  if(!inherits(x, "summ_heartr")) stop("x must be of class summ_heartr")

  z <- unclass(x)
  class(z) <- "data.frame"

  gt_table <-
    gt::gt(z) |>
    gt::tab_header(title= gt::md("**Summary**")) |>
    gt::cols_label(
      Variable = gt::md("*Variable*"),
      Mean = gt::md("**Mean**"),
      Minimum = gt::md("**Maximum**"),
      Q1 = gt::md("**1st Quartile**"),
      Median = gt::md("**Median**"),
      Q3 = gt::md("**3rd Quartile**"),
      Maximum = gt::md("**Maximum**"),
      SD = gt::md("**Standard, <br>Deviation**"),
      Var = gt::md("**Variance**")) |>
    gt::tab_style(
        style = gt::cell_borders( color = "pink4"),
        locations = gt::cells_body())  |>
    gt::cols_width(
      Variable ~ gt::px(90),
      Mean ~ gt::px(90),
      Minimum ~ gt::px(90),
      Q1 ~ gt::px(90),
      Median ~ gt::px(90),
      Q3 ~ gt::px(90),
      Maximum ~ gt::px(90),
      SD ~ gt::px(90),
      Var ~ gt::px(90)) |>
    gt::tab_style(
      locations = gt::cells_body(
        columns = Variable,
        rows = dplyr::everything()),
      style = gt::cell_fill(color="#FFEDFB")) |>
    gt::opt_table_font(font = gt::google_font("Roboto Condensed"),
                       weight = 450) |>
    gt::cols_align("center")

    print(gt_table)
    invisible(x)
}




