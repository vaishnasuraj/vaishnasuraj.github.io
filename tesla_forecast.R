#Tesla Stock Price Forecasting using R 
#Project by Vaishna Suraj

#Step 1: Install and Load Packages
install.packages(c("quantmod", "prophet", "dplyr", "ggplot2", "lubridate"))
library(quantmod)
library(prophet)
library(dplyr)
library(ggplot2)
library(lubridate)

#Step 2: Download Tesla Stock Data from Yahoo Finance
# "TSLA" is Tesla's stock ticker
getSymbols("TSLA", src = "yahoo", from = "2020-01-01", to = "2024-12-31")
# Convert to data frame for easy handling
tesla_data <- data.frame(date = index(TSLA), coredata(TSLA))
head(tesla_data)

# Step 3: Prepare Data for Prophet
# Prophet needs: 'ds' = date, 'y' = target variable (Closing Price)
prophet_data <- tesla_data %>%
  select(date, TSLA.Close) %>%
  rename(ds = date, y = TSLA.Close)
head(prophet_data)

# Step 4: Build and Train the Forecasting Model
model <- prophet(prophet_data)
# Create future dates (next 90 days)
future <- make_future_dataframe(model, periods = 90)
# Generate forecast
forecast <- predict(model, future)

# Step 5: Visualize the Forecast
# Main forecast plot
plot(model, forecast)
# Breakdown of trend, weekly, and yearly patterns
prophet_plot_components(model, forecast)

ggsave("forecast_plot_tesla.png")
ggsave("components_plot_tesla.png")

#Project Summary:
  # - Company: Tesla Inc. (TSLA)
  # - Time Frame: Jan 2020 – Dec 2024
  # - Tools: R, quantmod, prophet
  # - Goal: Forecast Tesla’s next 90-day stock trend
  # - Result: Trend visualization + seasonal breakdown

# Summary of Forecast Components 
# The decomposition of the Tesla stock forecast reveals key patterns driving its price trends:
# - The overall trend shows strong upward growth from 2020 through 2022, followed by a dip around 2023, and a steady recovery towards 2025. This aligns with Tesla's real-world market volatility and recovery patterns.
# - The weekly seasonality indicates that stock activity is generally higher on weekends, especially on Saturdays and Sundays, and drops during the weekdays — particularly on Tuesdays through Fridays. This is likely due to lower trading volume on non-market days, which may be artifacts in the data or reflect investor sentiment near weekends.
# - The yearly seasonality shows recurring patterns where Tesla’s stock tends to peak around the start and end of the year (January and December), and dips slightly mid-year (around July). This cyclical pattern may reflect investor optimism during Q1 and Q4 earnings seasons and holiday-related market behavior.
# These insights help validate the Prophet model’s ability to capture not just long-term trends, but also meaningful seasonal fluctuations that may influence investment timing or portfolio risk assessment.
