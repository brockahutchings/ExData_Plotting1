#Get the data from UCI website

##create temp file
temp <- tempfile()

##download content
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp) 

##unzip data 
unzipped <- unzip(temp)

unlink(temp)                                                                                                  


#use txt file to create dataframe
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

#convert Date column using formatMask
powerDF$Date <- as.Date(powerDF$Date, format="%d/%m/%Y")

#limit to specified date range
powerDFsubset <- subset(powerDF, powerDF$Date == "2007-02-01" |
                            powerDF$Date == "2007-02-02")

#fix data and time and create a datetime column
powerDFsubset <- transform(powerDFsubset, datetime=as.POSIXct(paste(Date, Time)),
                           "%d/%m/%Y %H:%M:%S")

#create plot
plot(powerDFsubset$datetime,powerDFsubset$Global_active_power,
     type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")

dev.copy(png, file="plot2.png", width=480, height=480)
dev.off()
cat("plot2.png has been saved in", getwd())