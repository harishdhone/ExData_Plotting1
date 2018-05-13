library(dplyr)
library(tidyr)
library(lubridate)


# Downloading data
if(!file.exists("data")){dir.create("data")}
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
              "./data/power_consumption.zip",method = "curl")

# Unzip data
unzip("./data/power_consumption.zip",exdir = "./data")

# Reading data into R
power_consumption <- read.table("./data/household_power_consumption.txt",sep = ";",
                                na.strings = "?",header = TRUE)
power_consumption <- tbl_df(power_consumption) #for better viewing

# Creating a new date_time variable by concatinating date and time 
power_consumption <- mutate(power_consumption,
                            date_time = dmy_hms(paste(power_consumption$Date,
                                                      power_consumption$Time,sep = " ")))

# Subsetting Feb 1, 2007 and Feb 2, 2007 data
feb_consumption <- filter(power_consumption,year(date_time)==2007&month(date_time) == 2&
                              (day(date_time)==1 | day(date_time)==2))

# Creating a tidy data set to plot multiple submeter points
feb_submeter <- feb_consumption %>% 
    select(date_time,Sub_metering_1,Sub_metering_2,Sub_metering_3) %>%
    gather(key = "sub_meter_type",value = "sub_meter_value",-date_time)

# Plot 3
png(filename = "plot3.png",width = 480,height = 480,units = "px")
with(feb_submeter,{
    plot(date_time,sub_meter_value,type = "n",xlab = "",
         ylab = "Energey sub metering")
    points(date_time[sub_meter_type == "Sub_metering_1"],
           sub_meter_value[sub_meter_type == "Sub_metering_1"],type = "l",col = "black")
    points(date_time[sub_meter_type == "Sub_metering_2"],
           sub_meter_value[sub_meter_type == "Sub_metering_2"],type = "l",col = "red")
    points(date_time[sub_meter_type == "Sub_metering_3"],
           sub_meter_value[sub_meter_type == "Sub_metering_3"],type = "l",col = "blue")
    legend("topright",legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
           col = c("black","red","blue"),lty = 1)
    
})
dev.off()