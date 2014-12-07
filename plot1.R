# Plot1.R
  
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

## Convert to numeric
hpc[, Global_active_power := as.numeric(Global_active_power)]

## Print plot to png
png(file = "plot1.png", width = 480, height = 480)
print(hist(hpc$Global_active_power, xlab = "Global Active Power (kilowatts)",
           main = "Global Active Power", col = "red"))
dev.off()

## Turn on warnings
options(warn = 0)