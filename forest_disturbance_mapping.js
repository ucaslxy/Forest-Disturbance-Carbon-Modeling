
var MTBS_severity = ee.ImageCollection("USFS/GTAC/MTBS/annual_burn_severity_mosaics/v1");
var nafd_first = ee.Image("projects/sat-io/open-datasets/NAFD/VCT_30m_first");
var nafd_last = ee.Image("projects/sat-io/open-datasets/NAFD/VCT_30m_last");
var nafd_prj = nafd_first.projection();
print(nafd_prj);

var dataset = ee.ImageCollection('MODIS/006/MCD12Q1');
var modlc = dataset.select('LC_Type1').filter(ee.Filter.date('2010-01-01', '2010-12-31')).first();
var modlc_prj = modlc.reproject(nafd_prj, null, 500);
var modlc_projection = modlc_prj.projection();

var lcpri_col = ee.ImageCollection("projects/sat-io/open-datasets/LCMAP/LCPRI");

var lcpri_1985 = lcpri_col.filterDate("1985-01-01","1985-12-31").first();
var lcpri_2010 = lcpri_col.filterDate("2010-01-01","2010-12-31").first();

var lc_forest_1985 = lcpri_1985.eq(4);
var lc_nforest_20001 = lcpri_1985.lt(4);
var lc_nforest_20002 = lcpri_1985.gt(4);
var lc_forest_loss1 = lc_forest_1985.multiply(lc_nforest_20001);
var lc_forest_loss2 = lc_forest_1985.multiply(lc_nforest_20002);
var lc_forest_loss = lc_forest_loss1.add(lc_forest_loss2);
var lc_forest_stable = lc_forest_loss.eq(0);
var lc_forest_stable_m = lc_forest_stable.reproject(nafd_prj, null, 30);


var ini_yr = 1970;

for(var yid=15; yid <= 40; yid++){
  var yr = ini_yr + yid;
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
  var mtbs_data_m = mtbs_data.reproject(nafd_prj, null, 30);
  // nafd yr
  // step 1
  var nafd_yr = nafd_first.eq(yid);
  // step 2
  // var nafd_yr = nafd_last.eq(yid);
  
  var nafd_mtbs = nafd_yr.add(mtbs_data_m);
  var nafd_fire = nafd_mtbs.eq(2);
  
  // Out fire
  var nafd_fire_500 = nafd_fire
    .reduceResolution({
      reducer: ee.Reducer.mean(),
      maxPixels: 65536
    })
    .reproject({
      crs: modlc_projection
    });
    
  Export.image.toDrive({
    image: nafd_fire_500,
    description: 'nafd_fire_first_' + yr,
    scale: 500,
    maxPixels: 1e13,
    crs: 'EPSG:4326',
    folder: '0NAFD',
    region: seus
  });
  
  
  // Out fire
  var nafd_500 = nafd_yr
    .reduceResolution({
      reducer: ee.Reducer.mean(),
      maxPixels: 65536
    })
    .reproject({
      crs: modlc_projection
    });
    
  Export.image.toDrive({
    image: nafd_500,
    // description: 'nafd_first_' + yr,
    description: 'nafd_first_' + yr,
    scale: 500,
    maxPixels: 1e13,
    crs: 'EPSG:4326',
    folder: '0NAFD',
    region: seus
  });
}
