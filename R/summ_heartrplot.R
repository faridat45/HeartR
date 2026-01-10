# dealing with 'no visible binding' note as recommended in lecture 11
utils::globalVariables(".data")

#' An interactive histogram plot with mean and median
#'
#' This function create a histogram based on the selected variable from the data
#' frame. The vertical lines shows the mean and the median, and the plot is
#' converted to an interactive plot using \pkg{plotly}.
#'
#' @param data A data frame containing the variable to be plotted.
#' @param var A character string that gives the name of the numeric variable to
#' plot
#'
#' @return An interactive histogram produced by \code{plotly::ggplotly()}
#' @seealso \code{\link{summ_heartr}}, \code{\link{print.summ_heartr}}
#' @importFrom ggplot2 "ggplot" "aes" "geom_histogram" "geom_vline" "labs"
#' "theme_minimal"
#' @importFrom plotly "ggplotly"
#' @export
#' @examples
#' summ_heartrplot(heart_dat, "age")
#'
#'
summ_heartrplot <- function(data,var){

  mu   <- mean(data[[var]], na.rm = TRUE)
  median1 <- median(data[[var]], na.rm = TRUE)

  pl <- ggplot2::ggplot(data=data, ggplot2::aes(x = .data[[var]])) +
    ggplot2::geom_histogram(
      bins = 30,
      fill = "skyblue",
      color = "orange",
      alpha = 0.7
    ) +
    ggplot2::geom_vline(
      aes(xintercept = mu, color = "Mean"),
      linetype = "dashed",
      linewidth = 1
    ) +
    ggplot2::geom_vline(
      aes(xintercept = median1,color = "Median"),
      linetype = "dotted",
      linewidth = 1
    ) +
    ggplot2::labs(
      title = paste("Distribution of", var),
      x = "var",
      y = "Count"
    ) +
    ggplot2::theme_minimal()

  plotly::ggplotly(pl) ## convert histogram to plotly makes it interactive
}
