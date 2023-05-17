
state_con <- read.csv("D:/FIA/obs/AL_COND.csv")
state_plot <- read.csv("D:/FIA/obs//AL_PLOT.csv")
state_tree <- read.csv("D:/FIA/obs//AL_TREE.csv")

plt_df <- as.data.frame(cbind(state_plot$CN, state_plot$INVYR, state_plot$LAT, state_plot$LON, state_plot$ELEV))
colnames(plt_df) <- c('cn', 'invyr', 'lat', 'lon', 'elev')

trow <- dim(plt_df)[1]
fortyp <- rep(0, trow)
stdage <- rep(0, trow)

plt_df <- as.data.frame(cbind(plt_df, fortyp, stdage))

for(i in 1:trow){
  ind <- which(plt_df$plt_id[i] == state_plot$CN)  
  plt_df$long[i] <- state_plot$LON[ind]
  plt_df$lat[i] <- state_plot$LAT[ind]
  plt_df$elev[i] <- state_plot$ELEV[ind]
}

ht <- rep(0, trow)
aht <- rep(0, trow)
plt_df <- as.data.frame(cbind(plt_df, ht, aht))

for(i in 7:8){
  ind <- which(plt_df$plt_id[i] == state_tree$PLT_CN) 
  print(ind)
  print(plt_df$stdage[i])
  print(mean(state_tree$ACTUALHT[ind], na.rm=TRUE))
  #plt_df$ht[i] <- state_tree$HT[ind]
  #plt_df$aht[i] <- state_tree$ACTUALHT[ind]
}


write.csv(plt_df, 'd:/al_stdage.csv')
