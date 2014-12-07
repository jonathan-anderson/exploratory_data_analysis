# Plot2.R

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

## Print plot to png
png(file = "plot2.png", width = 480, height = 480)
print(plot(hpc$Date_Time, hpc$Global_active_power, type = c("l"), xlab = "", ylab = "Global Active Power (kilowatts)"))
dev.off()

## Turn on warnings
options(warn = 0)