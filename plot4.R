# Plot4.R

## Turn off warnings for fread()
options(warn = -1) # Data file contains '?' for missing values in numeric field

## Required packages
require(data.table)

## Read-in data  
hpc <- fread('household_power_consumption.txt')

## Replace '?' with NA
replace_char = function(dat) {
  for (i in names(dat)) {
    dat[(get(i) == "\\?"), i := NA, with = FALSE]
  }
}
replace_char(hpc)

## Filter days
hpc[, Date := as.Date(Date, '%d/%m/%Y')]
hpc <- hpc[(Date >= as.Date('2007-02-01')) & (Date <= as.Date('2007-02-02')), ]

## Create date_time field
hpc[, Date_Time := as.POSIXct(paste(Date, " ", Time, sep = ""), "%Y-%m-%d %H:%M:%S", tz = "UTC")]

## Convert to numeric
hpc[, Global_active_power := as.numeric(Global_active_power)]
hpc[, Voltage := as.numeric(Voltage)]
hpc[, Sub_metering_1 := as.numeric(Sub_metering_1)]
hpc[, Sub_metering_2 := as.numeric(Sub_metering_2)]
hpc[, Sub_metering_3 := as.numeric(Sub_metering_3)]
hpc[, Global_reactive_power := as.numeric(Global_reactive_power)]


## Print plot to png
png(file = "plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2))
plot(hpc$Date_Time, hpc$Global_active_power, type = c("l"), ylab = "Global Active Power", xlab = "")
plot(hpc$Date_Time, hpc$Voltage, type = c("l"), ylab = "Voltage", xlab = "datetime")
plot(hpc$Date_Time, hpc$Sub_metering_1, type = c("l"), col = "black", xlab = "", ylab = "Energy sub metering")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lty = 1, bty = "n", cex = 0.9)
lines(hpc$Date_Time, hpc$Sub_metering_2, type = c("l"), col = "red", xlab = "", ylab = "Energy sub metering")
lines(hpc$Date_Time, hpc$Sub_metering_3, type = c("l"), col = "blue", xlab = "", ylab = "Energy sub metering")
plot(hpc$Date_Time, hpc$Global_reactive_power, type = c("l"), ylab = "Global_reactive_power", xlab = "datetime")
dev.off()

## Turn on warnings
options(warn = 0)