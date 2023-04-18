library(raster)
library(tidyr)
library(sf)
library(showtext)
library(ggpubr)
library(scico)
library(terra)
library(viridis)
library(RColorBrewer)



jpeg("D:/my_plot.jpg", width = 14, height = 10, units = "cm", res = 400)

seus_ext <- extent(-95, -75, 20, 40)
par(mfrow=c(2,3),mar=c(0,0,0,0), oma=c(6,0,0,0))

plot(p)
plot(ag11, col = myCol, ext = seus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)

plot(p)
plot(ag11, col = myCol, ext = seus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)

plot(p)
plot(ag11, col = myCol, ext = seus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)

plot(p)
plot(ag11, col = myCol, ext = seus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)

plot(p)
plot(ag11, col = myCol, ext = seus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)

plot(p)
plot(ag11, col = myCol, ext = seus_ext,
     axes=FALSE, box = TRUE, cex = 0.5,
     legend=FALSE, add=TRUE)
plot(p, add=TRUE)

# plotlegend
par(mfrow=c(1,1), new=FALSE, oma=c(0,0,0,0), mar=c(0,0,0,0))
plot(ag11,legend.only=TRUE ,legend.shrink=0.75, legend.width=0.3,
     horizontal = TRUE, )


#dev.copy(png,"D:/my_plot.jpg")
dev.off()

#ggsave("D:/test.png", width = 14, height = 9, units = "cm")
