library(shiny)

source("prediction.R")

shinyServer(
    function(input, output) {
        
        
        output$oid1 <- renderPrint({cleanword(input$word)})
        output$oid2 <- renderPrint({predictwords(input$word, input$n)[,1]})
        
    }

)
