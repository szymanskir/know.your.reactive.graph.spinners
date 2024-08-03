library(shiny)
library(waiter)

create_histogram <- function() {
  rnorm(100) |> 
    hist()
}

run_slowly <- function(expr = NULL, time = 1) {
  Sys.sleep(time = time)
  expr
}

ui <- fluidPage(
  useWaiter(),
  actionButton(inputId = "run", label = "Run") |>
    triggerWaiter(id = "histogram"),
  
  plotOutput(outputId = "histogram")
)

server <- function(input, output, session) {
  histogram_value <- reactiveVal(NULL)
  
  observeEvent(input$run, {
    run_slowly(time = 2)
  }, priority = 1)
  
  observeEvent(input$run, {
    histogram <- create_histogram() |> 
      run_slowly()
    
    histogram_value(histogram)
  }, priority = 0)
  
  
  output$histogram <- renderPlot({
    req(histogram_value())
    
    plot(histogram_value())
  })
}

shinyApp(ui, server)