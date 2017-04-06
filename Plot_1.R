#Get data from UCI website

##create temp file
temp <- tempfile()

## download the data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp) 

##unzip the data 
unzipped <- unzip(temp)  

unlink(temp)                                                                                                  

## Use text file to create dataframe 
powerDF <- read.table(unzipped,
                        header = T,
                        sep=";",
                        quote = "",
                        na.strings = "?",
                        colClasses = c("character", "character", "numeric",
                                       "numeric","numeric","numeric","numeric",
                                       "numeric","numeric"),
                        strip.white = TRUE,
                        comment.char="",
                        stringsAsFactors = FALSE)

#convert Date columns cahracterMask
powerDF$Date <- as.Date(powerDF$Date, format="%d/%m/%Y")

#subset for Feb 1 to Feb 2 2007
powerDFsubset <- subset(powerDF, powerDF$Date == "2007-02-01" |
                          powerDF$Date == "2007-02-02")

#change the time for plotting and add in new datetime column 
powerDFsubset <- transform(powerDFsubset,
                 datetime=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")

#generate plot 1
hist(powerDFsubset$Global_active_power, main = paste("Global Active Power"),
     col="red", xlab="Global Active Power (kilowatts)")

#save as plot1.png
dev.copy(png, file="plot1.png", width=480, height=480)
dev.off()
cat("plot1.png has been saved in", getwd())