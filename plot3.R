# Plot3.R

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
hpc[, Sub_metering_1 := as.numeric(Sub_metering_1)]
hpc[, Sub_metering_2 := as.numeric(Sub_metering_2)]
hpc[, Sub_metering_3 := as.numeric(Sub_metering_3)]

## Print plot to png
plot(hpc$Date_Time, hpc$Sub_metering_1, type = c("l"), col = "black", xlab = "", ylab = "Global Active Power (kilowatts)")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1)  
lines(hpc$Date_Time, hpc$Sub_metering_2, type = c("l"), col = "red", xlab = "", ylab = "Global Active Power (kilowatts)")
lines(hpc$Date_Time, hpc$Sub_metering_3, type = c("l"), col = "blue", xlab = "", ylab = "Global Active Power (kilowatts)")
dev.copy(png, file = "plot3.png", width = 480, height = 480)
dev.off()

## Turn on warnings
options(warn = 0)