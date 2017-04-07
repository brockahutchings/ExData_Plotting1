#Get the data from UCI website

##create temp file
temp <- tempfile()

##download data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)

##unzip
unzipped <- unzip(temp)  

unlink(temp)                                                                                                  


#create dataframe from txt
powerDF <- read.table(unzipped,
                        header = T,
                        sep=";",
                        quote = "",
                        na.strings = "?",
                        colClasses = c("character", "character",
                                       "numeric","numeric","numeric","numeric",
                                       "numeric","numeric","numeric"),
                        strip.white = TRUE,
                        comment.char="",
                        stringsAsFactors = FALSE
)

#do some date formating
powerDF$Date <- as.Date(powerDF$Date, format="%d/%m/%Y")

#limit date range of subset
powerDFsubset <- subset(powerDF, powerDF$Date == "2007-02-01" |
                          powerDF$Date == "2007-02-02")

#modify datetime for plotting and add datetime column 
powerDFsubset <- transform(powerDFsubset, datetime=as.POSIXct(paste(Date, Time)),
                           "%d/%m/%Y %H:%M:%S")

par(mfrow= c(2,2))

#create first plot row 1
plot(powerDFsubset$datetime,powerDFsubset$Global_active_power,
     type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")

#create second plot row 1
plot(powerDFsubset$datetime,powerDFsubset$Voltage,type = "l",
     xlab = "datetime", ylab = "Voltage")

#create first plot row 2
plot(powerDFsubset$datetime,powerDFsubset$Sub_metering_1,type = "l",
     xlab = "", ylab = "Energy sub metering")

##modify line
lines(powerDFsubset$datetime,powerDFsubset$Sub_metering_2, col = "red")

##modify line
lines(powerDFsubset$datetime,powerDFsubset$Sub_metering_3, col = "blue")

##modify legend
legend("topright", col=c("black","red","blue"),
       c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),
       lty=c(1,1), lwd=c(1,1))

#create second plot row 2
plot(powerDFsubset$datetime,powerDFsubset$Global_reactive_power,
     type = "l", xlab = "datetime", ylab = "Global_reactive_power")

#save plot
dev.copy(png, file="plot4.png", width=480, height=480)

dev.off()

cat("plot4.png has been saved in", getwd())