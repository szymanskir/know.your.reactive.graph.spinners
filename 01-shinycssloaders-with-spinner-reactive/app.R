library(shiny)
library(shinycssloaders)

create_histogram <- function() {
  rnorm(100) |> 
    hist()
}

run_slowly <- function(expr = NULL, time = 1) {
  Sys.sleep(time = time)
  expr
}

ui <- fluidPage(
  actionButton(inputId = "run", label = "Run"),
  plotOutput(outputId = "histogram") |> withSpinner()
)

server <- function(input, output, session) {
  output$histogram <- renderPlot({
    req(input$run)
    
    histogram <- create_histogram() |> 
      run_slowly()
    
    plot(histogram)
  })
}

shinyApp(ui, server)