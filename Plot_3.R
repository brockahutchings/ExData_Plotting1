#Get the data from UCI website

##create temp file
temp <- tempfile()

##Download data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)

##unzip data
unzipped <- unzip(temp)

unlink(temp)                                                                                                  


#create dataframe from txt file
powerDF <- read.table(unzipped,
                        header = T,
                        sep=";",
                        quote = "",
                        na.strings = "?",
                        colClasses = c("character", "character", "numeric","numeric","numeric","numeric","numeric","numeric","numeric"),
                        strip.white = TRUE,
                        comment.char="",
                        stringsAsFactors = FALSE
)

#convert Date column characters to Date format

powerDF$Date <- as.Date(powerDF$Date, format="%d/%m/%Y")

#subset for Feb 1 to Feb 2 2007

powerDFsubset <- subset(powerDF, powerDF$Date == "2007-02-01" |
                            powerDF$Date == "2007-02-02")

#fix data and time for plotting, put in new datetime column added to dataframe 
powerDFsubset <- transform(powerDFsubset, datetime=as.POSIXct(paste(Date, Time)),
                           "%d/%m/%Y %H:%M:%S")

#create plot
plot(powerDFsubset$datetime,powerDFsubset$Sub_metering_1,type = "l",
     xlab = "", ylab = "Energy sub metering")

##set line atributes
lines(powerDFsubset$datetime,powerDFsubset$Sub_metering_2, col = "red")

lines(powerDFsubset$datetime,powerDFsubset$Sub_metering_3, col = "blue")

##set legend attributes
legend("topright", col=c("black","red","blue"),
       c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),
       lty=c(1,1), lwd=c(1,1))

#save plot
dev.copy(png, file="plot3.png", width=480, height=480)

dev.off()

cat("plot3.png has been saved in", getwd())
