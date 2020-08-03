library(shinydashboard)
library(shiny)
library(caret)
library(xgboost)
library(methods)


options(shiny.maxRequestSize=300*1024^2)

origin47 <- read.csv("origin47.csv")
tail47<-read.csv("tailno47.csv")
fit_xgboost47<-readRDS("model47.rds")

server<-function(input,output,session){
    #for image part
    data <- eventReactive(input$file1,{rnorm(1:100000)})
    src = "https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2014/11/ds_2.png"
    output$Flight<-renderText({c('<img src="',src,'">')}) 
    
    
   #for input part
     observeEvent(input$Enter, {
        MONTH <- input$MONTH
        DAY <- input$DAY
        AIRLINE <- as.numeric(input$AIRLINE)
        FLIGHT_NUMBER <- input$FLIGHT_NUMBER
        TAIL_NUMBER <- as.numeric(input$TAIL_NUMBER)
        ORIGIN_AIRPORT <- as.numeric(input$ORIGIN_AIRPORT)
        SCHEDULED_DEPARTURE <- input$SCHEDULED_DEPARTURE
        DEPARTURE_TIME <- input$DEPARTURE_TIME
        
        test47 <- data.frame(MONTH,DAY,AIRLINE,FLIGHT_NUMBER,TAIL_NUMBER,ORIGIN_AIRPORT,
                             SCHEDULED_DEPARTURE,DEPARTURE_TIME)
        t47 <- as.data.frame(test47)
        t47 <- as.matrix(test47)
        ypred47<-predict(fit_xgboost47,t47)
        output$depdelay <- renderText({
            paste("The Flight is Delayed by=",ypred47)
        })
    })
    
    #for output part
    observeEvent(input$File, {
        req(input$data)
        ogdata <- read.csv(input$data$datapath)
        data <- ogdata
        MONTH <- data$MONTH
        DAY <- data$DAY
        AIRLINE <- as.numeric(data$AIRLINE)
        FLIGHT_NUMBER <- data$FLIGHT_NUMBER
        TAIL_NUMBER <- as.numeric(data$TAIL_NUMBER)
        TAILNUMBER <- data$TAIL_NUMBER
        ORIGIN_AIRPORT <- as.numeric(data$ORIGIN_AIRPORT)
        ORIGINAIRPORT <- data$ORIGIN_AIRPORT
        SCHEDULED_DEPARTURE <- data$SCHEDULED_DEPARTURE
        DEPARTURE_TIME <- data$DEPARTURE_TIME
        
        test_47<- data.frame(MONTH,DAY,AIRLINE,FLIGHT_NUMBER,TAIL_NUMBER,ORIGIN_AIRPORT,
                             SCHEDULED_DEPARTURE,DEPARTURE_TIME)
        
        t_47 <- as.data.frame(test_47)
        t_47 <- as.matrix(test_47)
        
        ypred_47<-predict(fit_xgboost47,t_47)
        table_ypred47 <- data.frame(ogdata,ypred_47)
        
        output$text<-renderText(paste("THE PREDICTION IS DONE , YOU CAN DOWNLOAD THE DATA"))
        
        output$downloadData <- downloadHandler(
            filename = function() { 
                paste("DelayPrediction", Sys.Date(), ".csv", sep="")
            },
            content = function(file) {
                write.csv(table_ypred47, file,row.names = FALSE)
            })
        
    })
}
