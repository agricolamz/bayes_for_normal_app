library(shiny)
library(tidyverse)

shinyServer(function(input, output) {

    output$pdf <- renderPlot({
        x <- seq(-35, 35, by = 0.1)
        post_sd <- (1/input$prior_sd+1/input$data_sd)^(-1)
        post_mu <- post_sd*(input$prior_mu/input$prior_sd+input$data_n*input$data_mu/input$data_sd)
        post_mu <- weighted.mean(c(input$prior_mu, input$data_mu), c(1/input$prior_sd, 1/input$data_sd))
        density <- c(dnorm(x, mean = input$data_mu, sd = input$data_sd),
                     dnorm(x, mean = input$prior_mu, sd = input$prior_sd),
                     dnorm(x, mean = post_mu, sd = post_sd))
        params <- rep(paste(c("data ", "prior ", "posterior "),
                            "μ =", c(input$data_mu, input$prior_mu, post_mu), 
                            "σ² =", c(input$data_sd, input$prior_sd, post_sd)),
                      each = length(x))
        densities <- data_frame(density, params, id = rep(x, 3))
        
        densities %>% 
            ggplot(aes(id, density, fill = params))+
            geom_polygon(alpha = 0.8)+
            theme_bw()
    })
})

