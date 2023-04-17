# based on forest age to make an prescribed forest disturbance map during 1860 or 1900 to 1985

import arcpy
from arcpy import sa
from arcpy.sa import *
arcpy.CheckOutExtension("Spatial")


ag1_frac = arcpy.Raster("PBinary5min/ag1.tif")
ag2_frac = arcpy.Raster("PBinary5min/ag2.tif")
ag3_frac = arcpy.Raster("PBinary5min/ag3.tif")
ag4_frac = arcpy.Raster("PBinary5min/ag4.tif")
ag5_frac = arcpy.Raster("PBinary5min/ag5.tif")
ag6_frac = arcpy.Raster("PBinary5min/ag6.tif")

tot_ag_frac = ag1_frac + ag2_frac + ag3_frac + ag4_frac + ag5_frac + ag6_frac
ag1_frac_r = Con(tot_age_frac > 0, ag1_frac/ tot_ag_frac, 0)
ag2_frac_r = Con(tot_age_frac > 0, ag2_frac/ tot_ag_frac, 0)
ag3_frac_r = Con(tot_age_frac > 0, ag3_frac/ tot_ag_frac, 0)
ag4_frac_r = Con(tot_age_frac > 0, ag4_frac/ tot_ag_frac, 0)
ag5_frac_r = Con(tot_age_frac > 0, ag5_frac/ tot_ag_frac, 0)
ag6_frac_r = Con(tot_age_frac > 0, ag6_frac/ tot_ag_frac, 0)

ag1_age = arcpy.Raster("PClass_5min_int/ag1.tif")
ag2_age = arcpy.Raster("PClass_5min_int/ag2.tif")
ag3_age = arcpy.Raster("PClass_5min_int/ag3.tif")
ag4_age = arcpy.Raster("PClass_5min_int/ag4.tif")
ag5_age = arcpy.Raster("PClass_5min_int/ag5.tif")
ag6_age = arcpy.Raster("PClass_5min_int/ag6.tif")

# ag1 1983-1985

for yr in range(1983, 1986):
  yid = 1986 - yr
  tmp = Con(ag1_age == yid, ag1_frac_r, 0)
  tmp_null = Con(IsNull(tmp), 0, tmp)
  tmp_null.save("Disturbance/hdist_" + str(yr) + ".tif")
 
for yr in range(1977, 1983):
  yid = 1986 - yr
  tmp = Con(ag2_age == yid, ag2_frac_r, 0)
  tmp_null = Con(IsNull(tmp), 0, tmp)
  tmp_null.save("Disturbance/hdist_" + str(yr) + ".tif")

for yr in range(1971, 1977):
  yid = 1986 - yr
  tmp = Con(ag3_age == yid, ag3_frac_r, 0)
  tmp_null = Con(IsNull(tmp), 0, tmp)
  tmp_null.save("Disturbance/hdist_" + str(yr) + ".tif")
  
for yr in range(1956, 1971):
  yid = 1986 - yr
  tmp = Con(ag4_age == yid, ag4_frac_r, 0)
  tmp_null = Con(IsNull(tmp), 0, tmp)
  tmp_null.save("Disturbance/hdist_" + str(yr) + ".tif")
  
for yr in range(1936, 1956):
  yid = 1986 - yr
  tmp = Con(ag5_age == yid, ag5_frac_r, 0)
  tmp_null = Con(IsNull(tmp), 0, tmp)
  tmp_null.save("Disturbance/hdist_" + str(yr) + ".tif")
  
 for yr in range(1901, 1936):
  yid = 1986 - yr
  tmp = Con(ag6_age == yid, ag6_frac_r, 0)
  tmp_null = Con(IsNull(tmp), 0, tmp)
  tmp_null.save("Disturbance/hdist_" + str(yr) + ".tif")



  
  
  
  
  

