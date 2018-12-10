library(shiny)

shinyUI(fluidPage(
    
    titlePanel('Play around with Normal Bayesian inference with known σ²'),
    
    sidebarLayout(
        sidebarPanel(
                    sliderInput('data_mu', "data x̄", min=-5, max=15, value=8, step=0.1),
                    sliderInput('data_sd', "known σ²:",  min=0.1, max=10, value=6, step=0.1),
                    sliderInput('data_n', "number of observation",  min=1, max=50, value=1, step=1),
                    sliderInput('prior_mu', 'prior μ:', min=-10, max=5, value=-8, step=0.1),
                    sliderInput('prior_sd', "prior σ²:",  min=0.1, max=10, value=3, step=0.1)
            ),
        mainPanel(
            textOutput('header'),
            plotOutput('pdf', width='500px', height='400px')
        )
    )
    
))

