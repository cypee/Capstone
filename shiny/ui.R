library(shiny)

shinyUI(fluidPage(theme = "bootstrap.css",#get more bootstrap themes from http://bootswatch.com/
                  # Set the page title
    titlePanel("Data Science Capstone: SwiftKey Predictor Using N-gram algorithm"),
    sidebarPanel(
        numericInput("n",h5("Number of returns"), 
                    value = 5),
        textInput("word", h5("Input the sentence"),
                    value = "The wheel is come full"),
    submitButton("SUBMIT"),
    br()
    ),
 
    mainPanel(
        tabsetPanel(type = "tabs", 
                    tabPanel("Instruction", 
                             h4("Usage"),
                             p("To evaluate the n-gram prediction algorithm, input a sentence to the left panel. Select the number of returns. Then press SUBMIT."),
                             p("You have entered:"),
                             span(h4(textOutput('oid1')),style = "color:blue"),
                             p('The next predicted word is'),
                             span(h4(textOutput('oid2')),style = "color:blue")
                    )
                    
        )
        
        
    ))
)
    
       

