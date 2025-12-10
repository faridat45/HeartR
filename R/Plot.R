
plot_heart <- function(data,var){
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
      xintercept = mu,
      color = "yellow",
      linetype = "dashed",
      linewidth = 1
    ) +
    ggplot2::geom_vline(
      xintercept = median1,
      color = "pink",
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



