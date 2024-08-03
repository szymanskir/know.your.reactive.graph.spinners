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
  histogram_value <- reactiveVal(NULL)
  
  observeEvent(input$run, {
    histogram <- create_histogram() |> 
      run_slowly()
    
    histogram_value(histogram)
  })
  
  
  output$histogram <- renderPlot({
    req(histogram_value())
    
    plot(histogram_value())
  })
}

shinyApp(ui, server)