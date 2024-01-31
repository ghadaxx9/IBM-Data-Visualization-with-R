library(shiny)
library(tidyverse)

# Read in data
adult <- read_csv("adult.csv")
# Convert column names to lowercase for convenience
names(adult) <- tolower(names(adult))

# Define server logic
shinyServer(function(input, output) {
  
  df_country <- reactive({
    adult %>% filter(native_country == input$country)
  })
  
  # TASK 5: Create logic to plot histogram or boxplot
  # TASK 5: Create logic to plot histogram or boxplot
  output$p1 <- renderPlot({
    if (input$graph_type == "histogram") {
      # Histogram
      ggplot(df_country(), aes_string(x = input$continuous_variable)) +  # Use input$continuous_variable here
        geom_histogram() +
        labs(title = paste("Trend of", input$continuous_variable),
             y = "Number of People") +
        facet_wrap(~prediction)
    } else {
      # Boxplot
      ggplot(df_country(), aes_string(y = input$continuous_variable)) +  # Use input$continuous_variable here
        geom_boxplot() +
        coord_flip() +
        labs(x = input$continuous_variable, y = "Number of People", title = paste("Trend of", input$continuous_variable)) +
        facet_wrap(~prediction)
    }
  })
  
  # TASK 6: Create logic to plot faceted bar chart or stacked bar chart
  output$p2 <- renderPlot({
    # Bar chart
    p <- ggplot(df_country(), aes_string(x = input$categorical_variable)) +
      labs(y = "Number of People", title = paste("Trend of", input$categorical_variable)) +
      theme(axis.text.x = element_text(angle = 45), legend.position = "bottom")
    
    if (input$is_stacked) {
      p + geom_bar(aes(fill = prediction), position = "stack")  # add bar geom and use prediction as fill
    } else {
      p + geom_bar(aes(fill = !!input$categorical_variable), position = "dodge") +  # add bar geom and use input$categorical_variable as fill
        facet_wrap(~prediction)  # facet by prediction
    }
  })
})
