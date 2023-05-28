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
