
# randomForest mapping forest age

# worldCim: bio1 Annual mean temperature; Bio2 Mean diurnal range; bio3 Isothermality; bio4 Temperature seasonality 
#           bio5 Max temperature of warmest month	bio6 Min temperature of coldest month; bio7 Temperature annual range
#           bio8 Mean temperature of wettest quarter; bio9 Mean temperature of driest quarter
#           bio10 Mean temperature of warmest quarter; bio11 Mean temperature of coldest quarter;
#           bio12 Annual precipitation; bio13 Precipitation of wettest month; bio14 Precipitation of driest month	
#           bio15 Precipitation seasonality; bio16 Precipitation of wettest quarter; bio17 Precipitation of driest quarter
#           bio18 Precipitation of warmest quarter; bio19 Precipitation of coldest quarter


#Besnard S, Koirala S, Santoro M, et al. Mapping global forest age from forest inventories, biomass and climate data[J]. 
#Earth System Science Data, 2021, 13(10): 4881-4896.


# ESSD paper variables: RandomForest Regressor: Isothermality, MaxTemperatureofWarmestMonth, MeanDiurnalRange, MeanTemperatureofWettestQuarter, 
#                       PrecipitationofWarmestQuarter, PrecipitationofWettestMonth, PrecipitationSeasonality, srad, vapr

# ESSD paper variables: RandomForest Classifier: AnnualMeanTemperature, AnnualPrecipitation, Isothermality, MeanTemperatureofColdestQuarter, 
#                       MeanTemperatureofDriestQuarter, MinTemperatureofColdestMonth, TemperatureAnnualRange, TemperatureSeasonality, vapr


# our variables: canopy height; AnnualMeanTemperature (bio1); Max temperature of warmest month (bio5); Min temperature of coldest month (bio6)
#                               AnnualPrecipitation (bio12); Precipitation of wettest month (bio13); Precipitation of driest month (bio14)


library(randomForest)

# read csv
state_data <- read.csv(paste0("C:/Users/xzl0122/Desktop/Forest_Age/test/conus_stdage_clm.csv"))
state_data$height[state_data$height == 0] <- NA
state_data <- na.omit(state_data)
state_data$fortyp[state_data$fortyp < 160] <- NA
state_data$fortyp[state_data$fortyp > 169] <- NA
state_data <- na.omit(state_data)
state_data$height[state_data$height > 50] <- NA
state_data <- na.omit(state_data)

plot(state_data$height, state_data$stdage)

rf_data <- as.data.frame(cbind(state_data$stdage, state_data$height, state_data$bio01, state_data$bio05, state_data$bio06,
                 state_data$bio12, state_data$bio13, state_data$bio14))

colnames(rf_data) <- c('stdage', 'height', 'bio01', 'bio05', 'bio06', 'bio12', 'bio13', 'bio14')

stdage_rf <- randomForest(stdage ~ ., data = rf_data, mtry = 3, importance = TRUE, na.action = na.omit)

stdage_rf$predicted

plot(rf_data$stdage, stdage_rf$predicted)
stdage_rf$importance


