
# read csv

state_con <- read.csv("C:/Users/xzl0122/Desktop/Forest_Age/test/AL_COND.csv")
state_plot <- read.csv("C:/Users/xzl0122/Desktop/Forest_Age/test/AL_PLOT.csv")


plt_df <- as.data.frame(cbind(state_con$PLT_CN, state_con$STDAGE, state_con$FORTYPCD, state_con$INVYR))
colnames(plt_df) <- c('plt_id', 'stdage', 'fortyp', 'invyr')
plt_df <- na.omit(plt_df)

trow <- dim(plt_df)[1]
long <- rep(0, trow)
lat <- rep(0, trow)

plt_df <- as.data.frame(cbind(plt_df, long, lat))

for(i in 1:trow){
  ind <- which(plt_df$plt_id[i] == state_plot$CN)  
  plt_df$long[i] <- state_plot$LON[ind]
  plt_df$lat[i] <- state_plot$LAT[ind]
}

write.csv(plt_df, 'd:/al_stdage.csv')
