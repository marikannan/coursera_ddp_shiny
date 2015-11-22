library(shiny)
library(dplyr)
library(ggplot2)
library(reshape)

month_list <- c("JUN","JUL","AUG","SEP")
rainData <- read.csv("india_rainfall.csv",header=TRUE)

# Define a server for the Shiny app
shinyServer(function(input, output) {
    # data table to display
    output$table <- DT::renderDataTable(DT::datatable({
    data <- rainData
    if (input$YEAR != "All") {
      data <- data[data$YEAR == input$YEAR,]
    }
    # always display total monsoon rain fall ie JUNE to SEPTEMBER
    data <- data[,c("YEAR",input$show_months,"JUN.SEP"), drop = FALSE] 
    data

  }))
    
  # plot
  output$myTotalPlot <- renderPlot({
    p <- ggplot(rainData, aes(YEAR, JUN.SEP))+geom_line(color="darkorange")
    p + geom_smooth(fill="purple",color="darkorange",size=2) + labs(x="Year",y="Rainfall",title="Annual Monsoon Rainfall ")
    })
  
  # plot for individual months
  output$myPlot <- renderPlot({
    rainDataLong <- melt(rainData[1:5], id="YEAR")  
    ggplot(data=rainDataLong,aes(x=YEAR, y=value, colour=variable)) +geom_line() + labs(x="Year",y="Rainfall",title="Month-wise Rainfall ")
  })
})
