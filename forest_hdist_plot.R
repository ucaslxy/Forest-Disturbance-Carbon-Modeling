# Load packages
library(raster)
library(tidyr)
library(sf)
library(ggpubr)
library(scico)
library(terra)
library(viridis)
library(RColorBrewer)
library(pals)



#https://cran.r-project.org/web/packages/pals/vignettes/pals_examples.html
# colormap from pals

# https://stackoverflow.com/questions/71511089/horizontal-legend-in-terra-r-package
#col = brewer.pal(7, "BrBG"), range = c(150, 500),
#plg = list(ext = l_ext, loc = "bottom", title = "myvar",
#           at = c(150, 200, 250, 350, 450, 500)))

# https://bedatablog.netlify.app/post/download-and-illustrate-current-and-projected-climate-in-r/

par(mfrow=c(1,2), mar=c(1,1,1,1))
p <- vect("E:/006_SEUS_data/1basedata/conus_state_84.shp")
ag1 <- rast("E:/006_SEUS_data/4age/PBinary_5min_SEUS/ag1.tif")
ag1[ag1 == 0] <- NA
seus_ext <- ext(-95, -75, 24, 40)
col_bar = magma(n = 10, direction = -1)
plot(ag1, ext=seus_ext, col=col_bar, axes=F,plg=list(loc = "bottom", mar=c(1,1,1,4)))
lines(p)
legend(x = 1, y = 10, legend = c(0.1, 0.3))

dev.off()



# Fig.S2
#https://stackoverflow.com/questions/48576941/how-to-set-up-a-raster-legend-for-four-plots-in-a-panel

land_ras <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/land_area/us_land_mask_5min.tif")
land_ras[land_ras < 0] <- 0

#par(mfrow=c(1,2), mar=c(1,0,0.1,0))
myCol = rev(parula(100))
myCol = brewer.gnbu(100)

hdist1 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_hdist_1986_1990.tif")
hdist1 <- hdist1 * 100 * land_ras
hdist1[land_ras <= 0] <- NA
hdist1[hdist1 > 4] <- 4

hdist2 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_hdist_1991_1995.tif")
hdist2 <- hdist2 * 100 * land_ras
hdist2[land_ras <= 0] <- NA
hdist2[hdist2 > 4] <- 4

hdist3 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_hdist_1996_2000.tif")
hdist3 <- hdist3 * 100 * land_ras
hdist3[land_ras <= 0] <- NA
hdist3[hdist3 > 4] <- 4

hdist4 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_hdist_2001_2005.tif")
hdist4 <- hdist4 * 100 * land_ras
hdist4[land_ras <= 0] <- NA
hdist4[hdist4 > 4] <- 4

hdist5 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_hdist_2006_2010.tif")
hdist5 <- hdist5 * 100 * land_ras
hdist5[land_ras <= 0] <- NA
hdist5[hdist5 > 4] <- 4

hdist6 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_hdist_1986_2010.tif")
hdist6 <- hdist6 * 100 * land_ras
hdist6[land_ras <= 0] <- NA
hdist6[hdist6 > 4] <- 4

p <- shapefile("E:/006_SEUS_data/1basedata/conus_state_84.shp")
#plot(hdist6)

jpeg("D:/hdist_nafd_att.jpg", width = 14, height = 8, units = "cm", res = 400)

conus_ext <- extent(-125, -67, 25, 50)
#par(mfrow=c(2,3),mar=c(0,0,0,0), oma=c(8,0,0,0))
par(mfrow=c(2,3),mar=c(0,0,0,0), oma=c(6,0,0,0))

plot(p)
plot(hdist1, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(a) 1986-1990", cex=1)


plot(p)
plot(hdist2, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(b) 1991-1995", cex=1)

plot(p)
plot(hdist3, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(c) 1996-2000", cex=1)

plot(p)
plot(hdist4, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(d) 2001-2005", cex=1)

plot(p)
plot(hdist5, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(e) 2006-2010", cex=1)


plot(p)
plot(hdist6, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(f) 1986-2010", cex=1)

# plotlegend

par(mfrow=c(1,1), new=FALSE, oma=c(0,0,0,0), mar=c(0,0,0,0))
plot(hdist6,legend.only=TRUE, col = myCol,legend.shrink=0.8, legend.width=0.3,
     horizontal = TRUE, axis.args=list(cex.axis=0.6, tck=1, padj = -2.5),
     legend.args=list(text='Forest disturbance fraction (%)', side=3, font=1, cex=0.6, padj = 6))

dev.off()



# Fig.S2
#https://stackoverflow.com/questions/48576941/how-to-set-up-a-raster-legend-for-four-plots-in-a-panel

land_ras <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/land_area/us_land_mask_5min.tif")
land_ras[land_ras < 0] <- 0

#par(mfrow=c(1,2), mar=c(1,0,0.1,0))
myCol = rev(parula(100))
myCol = brewer.ylgn(100)

hdist1 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_harv_1986_1990.tif")
hdist1 <- hdist1 * 100 * land_ras
hdist1[land_ras <= 0] <- NA
hdist1[hdist1 > 3.5] <- 3.5

hdist2 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_harv_1991_1995.tif")
hdist2 <- hdist2 * 100 * land_ras
hdist2[land_ras <= 0] <- NA
hdist2[hdist2 > 3.5] <- 3.5

hdist3 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_harv_1996_2000.tif")
hdist3 <- hdist3 * 100 * land_ras
hdist3[land_ras <= 0] <- NA
hdist3[hdist3 > 3.5] <- 3.5

hdist4 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_harv_2001_2005.tif")
hdist4 <- hdist4 * 100 * land_ras
hdist4[land_ras <= 0] <- NA
hdist4[hdist4 > 3.5] <- 3.5

hdist5 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_harv_2006_2010.tif")
hdist5 <- hdist5 * 100 * land_ras
hdist5[land_ras <= 0] <- NA
hdist5[hdist5 > 3.5] <- 3.5

hdist6 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_harv_1986_2010.tif")
hdist6 <- hdist6 * 100 * land_ras
hdist6[land_ras <= 0] <- NA
hdist6[hdist6 > 3.5] <- 3.5

p <- shapefile("E:/006_SEUS_data/1basedata/conus_state_84.shp")
#plot(hdist6)

jpeg("D:/hdist_nafd_harv.jpg", width = 14, height = 8, units = "cm", res = 400)

conus_ext <- extent(-125, -67, 25, 50)
#par(mfrow=c(2,3),mar=c(0,0,0,0), oma=c(8,0,0,0))
par(mfrow=c(2,3),mar=c(0,0,0,0), oma=c(6,0,0,0))

plot(p)
plot(hdist1, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(a) 1986-1990", cex=1)


plot(p)
plot(hdist2, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(b) 1991-1995", cex=1)

plot(p)
plot(hdist3, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(c) 1996-2000", cex=1)

plot(p)
plot(hdist4, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(d) 2001-2005", cex=1)

plot(p)
plot(hdist5, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(e) 2006-2010", cex=1)


plot(p)
plot(hdist6, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(f) 1986-2010", cex=1)

# plotlegend

par(mfrow=c(1,1), new=FALSE, oma=c(0,0,0,0), mar=c(0,0,0,0))
plot(hdist6,legend.only=TRUE, col = myCol,legend.shrink=0.8, legend.width=0.3,
     horizontal = TRUE, axis.args=list(cex.axis=0.6, tck=1, padj = -2.5),
     legend.args=list(text='Forest harvest fraction (%)', side=3, font=1, cex=0.6, padj = 6))

dev.off()




# Fig.S2
#https://stackoverflow.com/questions/48576941/how-to-set-up-a-raster-legend-for-four-plots-in-a-panel

land_ras <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/land_area/us_land_mask_5min.tif")
land_ras[land_ras < 0] <- 0

#par(mfrow=c(1,2), mar=c(1,0,0.1,0))
myCol = rev(parula(100))
myCol = brewer.orrd(100)

hdist1 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_fire_1986_1990.tif")
hdist1 <- hdist1 * 100 * land_ras
hdist1[land_ras <= 0] <- NA
hdist1[hdist1 > 4.0] <- 4.0

hdist2 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_fire_1991_1995.tif")
hdist2 <- hdist2 * 100 * land_ras
hdist2[land_ras <= 0] <- NA
hdist2[hdist2 > 4.0] <- 4.0

hdist3 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_fire_1996_2000.tif")
hdist3 <- hdist3 * 100 * land_ras
hdist3[land_ras <= 0] <- NA
hdist3[hdist3 > 4.0] <- 4.0

hdist4 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_fire_2001_2005.tif")
hdist4 <- hdist4 * 100 * land_ras
hdist4[land_ras <= 0] <- NA
hdist4[hdist4 > 4.0] <- 4.0

hdist5 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_fire_2006_2010.tif")
hdist5 <- hdist5 * 100 * land_ras
hdist5[land_ras <= 0] <- NA
hdist5[hdist5 > 4.0] <- 4.0

hdist6 <- raster("E:/006_SEUS_data/2forest_dt/5_hdist_conus/map/nafd_att_fire_1986_2010.tif")
hdist6 <- hdist6 * 100 * land_ras
hdist6[land_ras <= 0] <- NA
hdist6[hdist6 > 4.0] <- 4.0

p <- shapefile("E:/006_SEUS_data/1basedata/conus_state_84.shp")
#plot(hdist6)

jpeg("D:/hdist_nafd_fire.jpg", width = 14, height = 8, units = "cm", res = 400)

conus_ext <- extent(-125, -67, 25, 50)
#par(mfrow=c(2,3),mar=c(0,0,0,0), oma=c(8,0,0,0))
par(mfrow=c(2,3),mar=c(0,0,0,0), oma=c(6,0,0,0))

plot(p)
plot(hdist1, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(a) 1986-1990", cex=1)


plot(p)
plot(hdist2, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(b) 1991-1995", cex=1)

plot(p)
plot(hdist3, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(c) 1996-2000", cex=1)

plot(p)
plot(hdist4, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(d) 2001-2005", cex=1)

plot(p)
plot(hdist5, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(e) 2006-2010", cex=1)


plot(p)
plot(hdist6, col = myCol, ext = conus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)
text(-115, 27, "(f) 1986-2010", cex=1)

# plotlegend

par(mfrow=c(1,1), new=FALSE, oma=c(0,0,0,0), mar=c(0,0,0,0))
plot(hdist6,legend.only=TRUE, col = myCol,legend.shrink=0.8, legend.width=0.3,
     horizontal = TRUE, axis.args=list(cex.axis=0.6, tck=1, padj = -2.5),
     legend.args=list(text='Forest harvest fraction (%)', side=3, font=1, cex=0.6, padj = 6))

dev.off()


