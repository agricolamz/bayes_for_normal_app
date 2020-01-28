library(shiny)
library(tidyverse)

shinyServer(function(input, output) {

    output$pdf <- renderPlot({
        x <- seq(-60, 60, by = 0.1)
        prior_precision <- 1/input$prior_sd^2
        data_precision <- 1/input$data_sd^2
        post_precision <- prior_precision + data_precision
        post_sd <- 1/sqrt(post_precision)
        post_mu <- weighted.mean(c(input$prior_mu, input$data_mu), c(prior_precision, data_precision))
        density <- c(dnorm(x, mean = input$data_mu, sd = input$data_sd),
                     dnorm(x, mean = input$prior_mu, sd = input$prior_sd),
                     dnorm(x, mean = post_mu, sd = post_sd))
        params <- rep(paste(c("data ", "prior ", "posterior "),
                            "μ =", round(c(input$data_mu, input$prior_mu, post_mu), 3), 
                            "σ² =", round(c(input$data_sd^2, input$prior_sd^2, post_sd^2), 3)),
                      each = length(x))
        densities <- tibble(density, params, id = rep(x, 3))
        densities %>% 
            ggplot(aes(id, density, fill = params))+
            geom_polygon(alpha = 0.8)+
            theme_bw()
    })
})

