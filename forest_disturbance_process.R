library(terra)

hdist_path <- "E:/006_SEUS_data/2nadf/v2_5min_null/"
hremo_path <- "E:/006_SEUS_data/2nadf/v2_5min_final/"

for(yr in 1985:2010){
  nafd_first <- rast(paste0(hdist_path, "nafd_first_", as.character(yr), ".tif"))
  nafd_last <- rast(paste0(hdist_path, "nafd_last_", as.character(yr), ".tif"))
  
  nafd_fire_first <- rast(paste0(hdist_path, "nafd_fire_first_", as.character(yr), ".tif"))
  nafd_fire_last <- rast(paste0(hdist_path, "nafd_fire_last_", as.character(yr), ".tif"))
  
  nafd_non_fire <- nafd_first + nafd_last - nafd_fire_first - nafd_fire_last
  
  out_name <- paste0(hremo_path, "hremo_", as.character(yr), ".tif")
  
  writeRaster(nafd_non_fire, out_name, overwrite = TRUE)
  
}


hdist_path <- "E:/006_SEUS_data/2nadf/v2_5min_null/"
hremo_path <- "E:/006_SEUS_data/2nadf/v2_5min_final/"

for(yr in 2011:2020){
  hansen_loss <- rast(paste0(hdist_path, "hansen_loss_", as.character(yr), ".tif"))
  hansen_fire <- rast(paste0(hdist_path, "hansen_fire_", as.character(yr), ".tif"))
  
  hansen_non_fire <- hansen_loss - hansen_fire
  
  out_name <- paste0(hremo_path, "hremo_", as.character(yr), ".tif")
  
  writeRaster(hansen_non_fire, out_name, overwrite = TRUE)
  
}

for(yr in 2001:2010){
  hansen_loss <- rast(paste0(hdist_path, "hansen_loss_", as.character(yr), ".tif"))
  hansen_fire <- rast(paste0(hdist_path, "hansen_fire_", as.character(yr), ".tif"))
  
  hansen_non_fire <- hansen_loss - hansen_fire
  
  out_name <- paste0(hremo_path, "hansen_hremo_", as.character(yr), ".tif")
  
  writeRaster(hansen_non_fire, out_name, overwrite = TRUE)
  
}
