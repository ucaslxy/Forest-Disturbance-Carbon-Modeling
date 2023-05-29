// base projection
var forest_col = ee.ImageCollection("USFS/GTAC/LCMS/v2022-8");
var lcms = forest_col
    .filter(ee.Filter.and(
      ee.Filter.eq('year', 2000),
      ee.Filter.eq('study_area', 'CONUS')
    ))
    .first();
var lc_prj = lcms.projection();

var dataset = ee.ImageCollection('MODIS/006/MCD12Q1');
var modlc = dataset.select('LC_Type1').filter(ee.Filter.date('2010-01-01', '2010-12-31')).first();
var modlc_prj = modlc.reproject(lc_prj, null, 500);
var modlc_projection = modlc_prj.projection();

// step 1 download hansen forest loss 
var dataset = ee.Image("UMD/hansen/global_forest_change_2021_v1_9");
var forest_2000 = dataset.select('treecover2000');
var forest_loss = dataset.select('lossyear');

for(var yid=1; yid <= 20; yid++){
  var yr = yid + 2000;
  var sdate = yr + '-01-01';
  var edate = yr + '-12-31';
  
  var forest_loss_tmp = forest_loss.eq(yid);
  var forest_loss_unmask = forest_loss_tmp.unmask(0);
  var hansen_forest_m = forest_loss_unmask.reproject(lc_prj, null, 30);
  
  var hansen_500 = hansen_forest_m
    .reduceResolution({
      reducer: ee.Reducer.mean(),
      maxPixels: 65536
    })
    .reproject({
      crs: modlc_projection
    });
    
  Export.image.toDrive({
    image: hansen_500,
    description: 'hansen_' + yr,
    scale: 500,
    maxPixels: 1e13,
    crs: 'EPSG:4326',
    folder: '0USFS',
    region: conus
  });
  
}

// step 2 download NAFD annual disturbance
var att_type = ee.Image("users/lixy16s/NAFD_Attribution_type");
var att_year = ee.Image("users/lixy16s/NAFD_Attribution_year");

var att_type_p = att_type.reproject(lc_prj, null, 30);
var att_year_p = att_year.reproject(lc_prj, null, 30);

for(var yid = 16; yid <= 40; yid++){
  var att_year_tmp = att_year_p.eq(yid);
  var yr = 1970 + yid;
  var att_for_500 = att_year_tmp
    .reduceResolution({
      reducer: ee.Reducer.mean(),
      maxPixels: 65536
    })
    .reproject({
      crs: modlc_projection
    });
    
  Export.image.toDrive({
    image: att_for_500,
    description: 'nafd_forcov_' + yr,
    scale: 500,
    maxPixels: 1e13,
    crs: 'EPSG:4326',
    folder: '0USFS',
    region: conus
  });
}

// step 3 download USFS bark beetle and wind

for(var yr=2002; yr<=2021; yr++){
  var lc_tmp = forest_col
    .filter(ee.Filter.and(
      ee.Filter.eq('year', yr),
      ee.Filter.eq('study_area', 'CONUS')
    ))
    .first();
  
  var lc_type = lc_tmp.select('Land_Use');
  var lc_forest = lc_type.eq(3);
  var lc_change = lc_tmp.select('Change');
  var lc_dist = lc_change.eq(3);
  var lc_forest_change = lc_forest.multiply(lc_dist);
  
  var sdate = yr + '-01-01';
  var edate = yr + '-12-31';
  var mtbs_yr = MTBS_severity.filterDate(sdate, edate).select('Severity').toList(2);
  var mtbs_yr_sub = mtbs_yr.get(1);
  var mtbs_yr_conus = ee.Image(mtbs_yr_sub).unmask(0);
  var mtbs_data = mtbs_yr_conus.expression(
    "(b('Severity') == 1) ? 1" +
      ": (b('Severity') == 2) ? 1" +
        ": (b('Severity') == 3) ? 1" +
          ": (b('Severity') == 4) ? 1" +
          ": 0");
  var mtbs_data_m = mtbs_data.reproject(lc_prj, null, 30);
  var non_fire = mtbs_data_m.eq(0);
  // bark beetles
  var ads_yr = ads_col.filter(ee.Filter.eq('SURVEY_YEA', yr));
  var ads_bark1 = ads_yr.filter(ee.Filter.gte('DCA_CODE', 11000));
  var ads_bark = ads_bark1.filter(ee.Filter.lte('DCA_CODE', 11900));
  
  var bark_ras = ads_bark.reduceToImage({
    properties: ['DCA_CODE'],
    reducer: ee.Reducer.first()
  });
  
  var bark_ras_prj = bark_ras.reproject(lc_prj, null, 30);
  var bark_ras_unmask = bark_ras_prj.unmask(0);
  var bark_hdist = bark_ras_unmask.gt(0);
  var bark_hdist_nofire = bark_hdist.multiply(non_fire);
  var lc_forest_bark = lc_forest_change.multiply(bark_hdist_nofire);
  
  //wind
  
  var ads_yr = ads_col.filter(ee.Filter.eq('SURVEY_YEA', yr));
  var ads_wind = ads_yr.filter(ee.Filter.lt('DCA_CODE', 50013));
  
  var wind_ras = ads_wind.reduceToImage({
    properties: ['DCA_CODE'],
    reducer: ee.Reducer.first()
  });
  
  var wind_ras_prj = wind_ras.reproject(lc_prj, null, 30);
  var wind_ras_unmask = wind_ras_prj.unmask(0);
  var wind_hdist = wind_ras_unmask.gt(0);
  var wind_hdist_nofire = wind_hdist.multiply(non_fire);
  var lc_forest_wind = lc_forest_change.multiply(wind_hdist_nofire);
  
  var lc_forest_bark_500 = lc_forest_bark
    .reduceResolution({
      reducer: ee.Reducer.mean(),
      maxPixels: 65536
    })
    .reproject({
      crs: modlc_projection
    });
  
  Export.image.toDrive({
    image: lc_forest_bark_500,
    description: 'usfs_forest_bark_' + yr,
    scale: 500,
    maxPixels: 1e13,
    crs: 'EPSG:4326',
    folder: '0NAFD',
    region: conus
  });
  
  var lc_forest_wind_500 = lc_forest_wind
    .reduceResolution({
      reducer: ee.Reducer.mean(),
      maxPixels: 65536
    })
    .reproject({
      crs: modlc_projection
    });
  
  Export.image.toDrive({
    image: lc_forest_wind_500,
    description: 'usfs_forest_wind_' + yr,
    scale: 500,
    maxPixels: 1e13,
    crs: 'EPSG:4326',
    folder: '0NAFD',
    region: conus
  });
}

// step 4 download USFS forest fast loss

for(var yr=2002; yr<=2021; yr++){
  var lc_tmp = forest_col
    .filter(ee.Filter.and(
      ee.Filter.eq('year', yr),
      ee.Filter.eq('study_area', 'CONUS')
    ))
    .first();
  
  var lc_type = lc_tmp.select('Land_Use');
  var lc_forest = lc_type.eq(3);
  var lc_change = lc_tmp.select('Change');
  var lc_dist = lc_change.eq(3);
  var lc_forest_change = lc_forest.multiply(lc_dist);
  
  var lc_forest_change_500 = lc_forest_change
    .reduceResolution({
      reducer: ee.Reducer.mean(),
      maxPixels: 65536
    })
    .reproject({
      crs: modlc_projection
    });
  
  Export.image.toDrive({
    image: lc_forest_change_500,
    description: 'usfs_fast_loss_' + yr,
    scale: 500,
    maxPixels: 1e13,
    crs: 'EPSG:4326',
    folder: '0USFS',
    region: conus
  });  
}

// step 6 download fire severity data
var MTBS_severity = ee.ImageCollection("USFS/GTAC/MTBS/annual_burn_severity_mosaics/v1");

for(var yr = 1984; yr <= 2022; yr++){
  
  var sdate = yr + '-01-01';
  var edate = yr + '-12-31';
  var mtbs_yr = MTBS_severity.filterDate(sdate, edate).select('Severity').toList(2);
  var mtbs_yr_sub = mtbs_yr.get(1);
  var mtbs_yr_conuso = ee.Image(mtbs_yr_sub).unmask(0);
  var mtbs_yr_conus = mtbs_yr_conuso.reproject(lc_prj, null, 30);
  
  var mtbs_uburn_low = mtbs_yr_conus.eq(1);
  var mtbs_low = mtbs_yr_conus.eq(2);
  var mtbs_mod = mtbs_yr_conus.eq(3);
  var mtbs_high = mtbs_yr_conus.eq(4);
  
  var mtbs_uburn_low_500 = mtbs_uburn_low
    .reduceResolution({
      reducer: ee.Reducer.mean(),
      maxPixels: 65536
    })
    .reproject({
      crs: modlc_projection
    });
  
  Export.image.toDrive({
    image: mtbs_uburn_low_500,
    description: 'mtbs_fire_ulow_' + yr,
    scale: 500,
    maxPixels: 1e13,
    crs: 'EPSG:4326',
    folder: '0USFS',
    region: conus
  });
  
  var mtbs_low_500 = mtbs_low
    .reduceResolution({
      reducer: ee.Reducer.mean(),
      maxPixels: 65536
    })
    .reproject({
      crs: modlc_projection
    });
  
  Export.image.toDrive({
    image: mtbs_low_500,
    description: 'mtbs_fire_low_' + yr,
    scale: 500,
    maxPixels: 1e13,
    crs: 'EPSG:4326',
    folder: '0USFS',
    region: conus
  });
  
  var mtbs_mod_500 = mtbs_mod
    .reduceResolution({
      reducer: ee.Reducer.mean(),
      maxPixels: 65536
    })
    .reproject({
      crs: modlc_projection
    });
  
  Export.image.toDrive({
    image: mtbs_mod_500,
    description: 'mtbs_fire_mod_' + yr,
    scale: 500,
    maxPixels: 1e13,
    crs: 'EPSG:4326',
    folder: '0USFS',
    region: conus
  });
  
  var mtbs_high_500 = mtbs_high
    .reduceResolution({
      reducer: ee.Reducer.mean(),
      maxPixels: 65536
    })
    .reproject({
      crs: modlc_projection
    });
  
  Export.image.toDrive({
    image: mtbs_high_500,
    description: 'mtbs_fire_high_' + yr,
    scale: 500,
    maxPixels: 1e13,
    crs: 'EPSG:4326',
    folder: '0USFS',
    region: conus
  });
}


var mtbs_burn = ee.FeatureCollection("users/lixy16s/mtbs_bound_gee");

for(var yr=1984;yr <= 2021; yr++){
  var mon = 12;
  var mtbs_yr = mtbs_burn.filter(ee.Filter.eq('year', yr));
  var mtbs_mon = mtbs_burn.filter(ee.Filter.eq('mon', mon));
  var mtbs_mon_ras = mtbs_mon.reduceToImage({
    properties: ['mon'],
    reducer: ee.Reducer.first()
  });
  var mtbs_mon_rasp = mtbs_mon_ras.reproject(lc_prj, null, 30);
  var mtbs_mon_rasp_unmask = mtbs_mon_rasp.unmask(0);
  var mtbs_fire_mon = mtbs_mon_rasp_unmask.gt(0);
  
  var mtbs_fire_mon_500 = mtbs_fire_mon
    .reduceResolution({
      reducer: ee.Reducer.mean(),
      maxPixels: 65536
    })
    .reproject({
      crs: modlc_projection
    });
  
  Export.image.toDrive({
    image: mtbs_fire_mon_500,
    description: 'mtbs_fire_' + yr + "_" + mon,
    scale: 500,
    maxPixels: 1e13,
    crs: 'EPSG:4326',
    folder: '0USFS',
    region: conus
  });
  
}



var att_type = ee.Image("users/lixy16s/NAFD_Attribution_type");
var att_year = ee.Image("users/lixy16s/NAFD_Attribution_year");

var att_type_p = att_type.reproject(lc_prj, null, 30);
var att_year_p = att_year.reproject(lc_prj, null, 30);

var ini_yr = 1970;
for(var yid = 16; yid <= 40; yid++){
  var yr = ini_yr + yid; 
  var sdate = yr + '-01-01';
  var edate = yr + '-12-31';
  var yr_dist = att_year_p.eq(yid);
  
  var type_dist_stress = att_type_p.eq(104).multiply(yr_dist);  // 104 fire
  var type_dist_wind = att_type_p.eq(105).multiply(yr_dist);  // 105 wind
  var type_dist_conv = att_type_p.eq(107).multiply(yr_dist);  // 107 conversion
  
  
  var type_dist_stress_500 = type_dist_stress
    .reduceResolution({
      reducer: ee.Reducer.mean(),
      maxPixels: 65536
    })
    .reproject({
      crs: modlc_projection
    });
  
  Export.image.toDrive({
    image: type_dist_stress_500,
    description: 'nafd_att_stress_' + yr,
    scale: 500,
    maxPixels: 1e13,
    crs: 'EPSG:4326',
    folder: '0USFS',
    region: conus
  });
  
  var type_dist_wind_500 = type_dist_wind
    .reduceResolution({
      reducer: ee.Reducer.mean(),
      maxPixels: 65536
    })
    .reproject({
      crs: modlc_projection
    });
    
  Export.image.toDrive({
    image: type_dist_wind_500,
    description: 'nafd_att_wind_' + yr,
    scale: 500,
    maxPixels: 1e13,
    crs: 'EPSG:4326',
    folder: 'OUSFS',
    region: conus
  });
  
  var type_dist_conv_500 = type_dist_conv
    .reduceResolution({
      reducer: ee.Reducer.mean(),
      maxPixels: 65536
    })
    .reproject({
      crs: modlc_projection
    });
  
  Export.image.toDrive({
    image: type_dist_conv_500,
    description: 'nafd_att_conv_' + yr,
    scale: 500,
    maxPixels: 1e13,
    crs: 'EPSG:4326',
    folder: 'OUSFS',
    region: conus
  });
}
