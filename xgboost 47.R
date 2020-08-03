install.packages("xgboost")
library(xgboost)
install.packages("methods")
library(methods)
install.packages("caret")
library(caret)
flight_xgb1<-read.csv(file.choose())
flight_xgb1$X<-NULL
View(flight_xgb1)
xg1<-flight_xgb1


View(xg1)
memory.limit(1000000)
## lets make paritition our data
inTraining<-createDataPartition(xg1$DEPARTURE_DELAY,p=0.80,list =FALSE )
train<-xg1[inTraining,]
test<-xg1[-inTraining,]
labeltraining<-train$DEPARTURE_DELAY
datatraining<-as.matrix(train[c(1:8)])
labeltesting<-test$DEPARTURE_DELAY
datatesting<-as.matrix(test[c(1:8)])
##lets try with xgb matrix
xgtraining<-xgb.DMatrix(data = datatraining,label=labeltraining)
xgtesting<-xgb.DMatrix(data = datatesting,label=labeltesting)
parm<-list("objective"="multi:softmax","bst:eta"=0.005,"bst:max_depth"=7,"num_class=4","nthread"=80,"gamma"=0.5,"min_child_weight"=15)
model1<-xgboost(parms=parm,data=xgtraining,nrounds = 300)
ypred<-predict(model1,xgtesting)
postResample(ypred,test$DEPARTURE_DELAY)     ###### RMSE 0.89, Rsquared 0.98, MAE 0.64 ######
saveRDS(model1,file="C:/Users/PRIYA/Desktop/DATASCIENCE/CASE STUDY/Aviation delay analysis/final 1/final1/model47.rds")
save(model1,file = "C:/Users/PRIYA/Desktop/DATASCIENCE/CASE STUDY/Aviation delay analysis/final 1/final1/model47.rds")

colnames(xg1)
