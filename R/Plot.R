pl <- ggplot2::ggplot(data, ggplot2::aes(x = .data[[var]])) +
  ggplot2::geom_histogram(
    bins = 30,
    fill = "skyblue",
    color = "white",
    alpha = 0.7
  ) +
  ggplot2::geom_vline(
    xintercept = mean_val,
    color = "red",
    linetype = "dashed",
    linewidth = 1
  ) +
  ggplot2::geom_vline(
    xintercept = median_val,
    color = "black",
    linetype = "dotted",
    linewidth = 1
  ) +
  ggplot2::labs(
    title = paste("Distribution of", var),
    x = "var",
    y = "Count"
  ) +
  ggplot2::theme_minimal()

# Convert to a Plotly plot
plotly::ggplotly(pl)
