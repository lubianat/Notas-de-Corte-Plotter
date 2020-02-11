#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)

library(tidyr)

library(data.table)
notas_de_corte <- as.data.frame(fread('../csv/sumario_das_notas_de_corte.csv'))

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Notas de corte da FUVEST"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectizeInput(inputId = "course",
                           label = "course",
                            choices = notas_de_corte$`Nome do curso`)
        ),

        # Show a plot of the generated distribution
        mainPanel(textOutput('course'),
                  tableOutput("mini_tabela"))
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    
    dados_do_curso <- eventReactive({
        input$course
    }, {
        mini_table <-
            notas_de_corte %>% filter(
                `Nome do curso` ==      input$course     )
        return(mini_table)
    })
    output$course <- renderText("Dados para a nota de corte do curso selecionado:")
    output$mini_tabela <- renderTable({dados_do_curso()})
}

# Run the application 
shinyApp(ui = ui, server = server)
