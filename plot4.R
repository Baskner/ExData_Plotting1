con <- file("household_power_consumption.txt", "r", blocking = FALSE)
l <- readLines(con, n=1)

cnam <- strsplit(l[1], ";")[[1]]
d <- data.frame("Date", "Date", numeric(1), numeric(1), numeric(1), numeric(1), numeric(1), numeric(1), numeric(1), stringsAsFactors = FALSE)
colnames(d) <- cnam
n <- 0
repeat
{
  l <- readLines(con, n=1)
  if (length(l) == 0)
  {
    break # breaks repeat loop
  }
  if (grepl(pattern = "^[12]/2/2007", x = l[1]))
  {
    n <- n + 1
     d[n,] <- rbind(strsplit(l[1], ";")[[1]])
  }
}
unlink("household_power_consumption.txt")
dd <- cbind(strptime(paste(d$Date, d$Time, collapse=NULL), "%d/%m/%Y %H:%M:%S"), d[,3:9])
colnames(dd)[1] <- "Date"
dd$Global_active_power <- as.numeric(dd$Global_active_power)
dd$Sub_metering_1 <- as.numeric(dd$Sub_metering_1)
dd$Sub_metering_2 <- as.numeric(dd$Sub_metering_2)
dd$Sub_metering_3 <- as.numeric(dd$Sub_metering_3)


png(filename = "figure/plot4.png", width = 480, height = 480, units = "px")
par (mfcol = c(2,2))
plot(dd$Date, dd$Global_active_power, xlab = "", ylab="Global Active Power (kilowatts)", col="black", type="l")  

plot(dd$Date, dd$Sub_metering_1, xlab = "", ylab="Energy sub metering", col="black", type="l")
lines(dd$Date, dd$Sub_metering_2, col="red", type="l")
lines(dd$Date, dd$Sub_metering_3, col="blue", type="l")
legend("topright", bty="n", lty=1, lwd=1, col=c("black","blue","red"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

plot(dd$Date, dd$Voltage, xlab = "datetime", ylab="Voltage", col="black", type="l")  
plot(dd$Date, dd$Global_reactive_power, xlab = "datetime", ylab="Global_reactive_power", col="black", type="l")  
dev.off()
