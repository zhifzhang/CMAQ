<!-- BEGIN COMMENT -->

[<< 附录B](CMAQ_UG_appendixB_emissions_control.md) - [返回](../README.md) - [附录D >>](CMAQ_UG_appendixD_parallel_implementation.md)

<!-- END COMMENT -->

# 附录C 处理用于输入CMAQ的空间数据

## C.1 地理空间数据

空气质量模型需要大量的空间数据才能生成人为源、生物源、火灾源、海盐源、粉尘源和NH<sub>3</sub>排放源。此外，在模拟地面与大气之间的热量、水分和动量交换以及模拟物种（如O<sub>3</sub>和NH<sub>3</sub>）的干沉降时，还需要地表特征，例如具有植被叶面积指数（LAI）和分数、反照率和土壤类型的土地利用类型。在排放源、气象和空气质量模型中使用的所有地理空间数据，必须采用一致的坐标系。SMOKE/WRF/CMAQ模型所需的大多数地理空间数据都可以使用空间分配器（Spatial Allocator，SA）生成，其中包括为特定应用开发的三个组件：矢量（Vector）、栅格（Raster）、和代理工具（Surrogate Tool）。

在使用空间数据时，重要的是要了解基准面（即代表地球表面的球形（球面或椭圆形）表面）和投影（即将基准面上的位置转换为数字的数学转换）在平面上的位置。以下各节简要介绍了与CMAQ系统一起使用的合适的基准面和投影，以及以正确形式生成所需空间数据的方法。

## C.2 大地基准

大地基准用于定义地球上某个位置的坐标系。空间数据集中使用了许多大地基准，具体取决于它们是什么地理区域以及如何将地球表面近似为球体。美国大部分地理空间数据是在1983年北美基准面（North American Datum of 1983，NAD83）中定义的，而全球数据集通常是在1984年世界大地测量系统（World Geodetic System
1984，WGS84）中定义的。

WRF数据集使用WGS84大地基准。在CMAQ模拟中使用的所有经纬度地理数据集，例如排放源文件、土地利用或生物源数据文件以及海洋文件，都应使用WGS84，以便它们在空间上与WRF文件对齐。对于北美地区的模拟，NAD83与WGS84基准仅稍有不同。因此，NAD83可以用于北美地区而不会在模型数据集中造成空间未对准问题。

## C.3 空间数据投影

CCTM可以使用为WRF定义的[四个地图投影]( http://www2.mmm.ucar.edu/wrf/users/docs/user_guide_V3/users_guide_chap3.htm )中的任何一个。这四个地图投影坐标系是常规经纬度地理投影、兰伯特正形圆锥投影、墨卡托投影和极地立体投影。但是，用户应注意，CMAQ系统中的一些前处理和后处理工具目前不支持墨卡托投影。其中包括ICON、BCON、sitecmp、sitecmp_dailyo3、bldoverlay、hr2day和writesite。

重要的是要知道，在将WGS84中的空间数据投影到CMAQ投影或将CMAQ数据投影到另一个地图投影时，用户不应进行任何基准转换。这与WRF预处理系统（WRF preprocessing system，WPS）一致。因为基准转换将导致地理位置移动。

[PROJ]( https://proj.org )坐标转换软件库使用地球半径为6370000m的球形表面，来定义CMAQ区域投影，以匹配WRF区域投影定义。采用WGS84的输入数据集可以使用以下示例定义与WRF数据匹配所需的投影变换：

兰伯特正形圆锥投影："+proj=lcc +a=6370000.0 +b=6370000.0 +lat_1=33 +lat_2=45 +lat_0=40 +lon_0=-97"

极地立体投影："+proj=stere +a=6370000.0 +b=6370000.0 +lat_ts=33 +lat_0=90 +lon_0=-97 +k_0=1.0"

墨卡托投影："+proj=merc +a=6370000.0 +b=6370000.0 +lat_ts=33 +lon_0=0"

常规经纬度地理投影："+proj=latlong +a=6370000.0 +b=6370000.0"

## C.4 空间数据生成

SMOKE生成人为排放源时需要排放空间分配替代物，以在空间上分配基于县的排放清单以建模网格单元。排放替代物可以基于人口、道路、机场、铁路和土地利用空间数据集。SA矢量和替代工具可用于生成SMOKE所需的所有排放替代物。

- [SA矢量和替代工具（Vector and Surrogate Tools）](https://www.cmascenter.org/sa-tools/) 

**生物源排放**要求包括不同树种的土地利用输入数据。有两种方法可以计算涵盖美国本土区域所需的输入数据。

1. 原始方法-使用SA 矢量（Vector）分配工具重新网格化生物源排放土地利用数据库第3版（BELD3）。BELD3数据是根据1990年代初的AVHRR土地利用数据和县一级的FIA树种生成的。
2. 第二种方法-使用SA Raster BELD4土地利用生成工具来生成具有树种的模型区域的土地利用数据。然后，使用提供的实用程序将生成的土地利用数据转换为用于CMAQ输入的I/O API格式数据。此工具的局限性在于，1990年代初的县级FIA树种表仍用于分配FIA树种（第一种方法也是如此）。

- [SA矢量和替代工具（Vector and Surrogate Tools）](https://www.cmascenter.org/sa-tools/) 
- [SA Raster BELD4土地利用生成工具](https://www.cmascenter.org/sa-tools/documentation/4.2/Raster_Users_Guide_4_2.pdf) 

**火灾排放**要求火灾地点、燃烧区域和详细的燃料负荷信息。可以通过危险地图系统（Hazard Mapping System，HMS）的卫星检测或国家消防和航空管理Web应用程序的地面报告来确定火灾地点。可以从基于GIS的来源（例如地理空间多机构协调（Geospatial Multi-Agency Coordination，GeoMac）网站或美国国家历史火警周界数据盆地数据集）获得燃烧面积的估计值。使用地理空间数据集（例如美国森林服务燃料特征分类系统（Fuel Characteristic Classification System，FCCS））估计燃料负荷。所有这些信息源都可用于估计火灾排放。BlueSky建模框架是可用于产生火灾排放的工具的一个示例。BlueSky模块化地链接了各种独立的火灾信息、燃料负荷、火灾消耗、火灾排放和烟雾扩散模型。使用这些工具来估算火灾排放可能非常复杂，因此我们已经为社区创建了火灾排放数据集。此类数据集的示例是美国国家大气研究中心的火灾清单（Fire INventory from
the National Center for Atmospheric Research，FINN）或全球火灾排放数据库（Global Fire Emissions Database，GFED）。

- [危险底图系统的火灾和烟雾产品（Hazard Mapping System Fire and Smoke Product）](https://www.ospo.noaa.gov/Products/land/hms.html)
- [国家消防和航空管理Web应用程序（National Fire and Aviation Management Web Application）](https://fam.nwcg.gov/fam-web/)
- [地理空间多机构协调网站（Geospatial Multi-Agency Coordination website）](https://www.geomac.gov/)
- [美国国家历史火警周界数据盆地数据集（U.S. National Historical Fire Perimeters Data Basin Dataset）](https://www.arcgis.com/home/item.html?id=6b68271ebee147d99525e0b914823155) 
- [美国森林服务燃料特征分类系统（US Forest Service Fuel Characteristic Classification System，FCCS）](https://www.fs.fed.us/pnw/fera/fft/fccsmodule.shtml)
- [美国森林服务局BlueSky建模框架（US Forest Service BlueSky Modeling Framework）](https://sites.google.com/firenet.gov/wfaqrp-airfire-info/playground)  
- [美国国家大气研究中心的火灾清单（Fire INventory from
the National Center for Atmospheric Research，FINN）](https://www2.acom.ucar.edu/modeling/finn-fire-inventory-ncar)
- [全球火灾排放数据库（Global Fire Emissions Database，GFED）](http://www.globalfiredata.org/)

**海浪排放**需要一个I/O API文件，该文件中为开阔海洋和碎浪区（50m）缓冲区生成在模型网格单元中的占比分数。对于大多数北美地区，可以使用SA Vector分配工具从SA数据目录中具有陆地、碎浪区缓冲区和开阔海洋的多边形shapefile文件生成碎浪区和开阔海洋文件。对于美国以外的地区，用户必须生成一个碎浪区多边形shapefile文件，其属性与SA中的文件具有相同的属性才能使用该工具。有关创建此CMAQ输入文件的逐步说明，请参见[CMAQ创建海洋文件的教程](../Tutorials/CMAQ_UG_tutorial_oceanfile.md)。[用户指南第6章](../CMAQ_UG_ch06_model_configuration_options.md#Sea_Spray)中也包含了有关CMAQ中海浪模块的其他信息。

**农田NH3排放**可以使用CMAQ双向NH3模型估算。CMAQ双向NH<sub>3</sub>模型的输入是由CMAQ的肥料排放情景工具（Fertilizer Emission Scenario Tool for
CMAQ，FEST-C）系统生成的。FEST-C包含三个主要组件：Java接口、环境政策集成（Environmental Policy
Integrated Climate，EPIC）模型和SA栅格工具。该Java接口指导用户生成所需的土地利用和作物数据以及EPIC输入文件，并模拟EPIC，并提取EPIC的输出用于CMAQ。FEST-C生成的BELD4土地利用数据需要使用FEST-C中的实用程序转换为CMAQ的I/O API格式。注意，用于FEST-C的BELD4数据是通过上述在生物源产生方法中描述的第二种方法产生的。

- [CMAQ的肥料排放情景工具（Fertilizer Emission Scenario Tool for
CMAQ，FEST-C）](https://www.cmascenter.org/fest-c/) 
- FEST-C参考文献: Ran, L., Yuan, Y., Cooter, E., Benson, V., Yang, D., Pleim, J., Wang, R. and Williams, J. (2019). An integrated agriculture, atmosphere, and hydrology modeling system for ecosystem assessments. Journal of Advances in Modeling Earth Systems, 11(12), 4645-4668. DOI: [https://doi.org/10.1029/2019MS001708](https://doi.org/10.1029/2019MS00170)


**气象和空气质量模型中用于地表通量建模的土地利用和土地覆盖数据**可以使用WPS或SA栅格工具生成。在气象和空气质量建模中使用一致的土地利用数据非常重要。对于美国，WPS包含了重新网格化的9-arc
second（约250m分辨率）的2011年NLCD土地利用数据，而2011年的MODIS土地利用数据用于美国以外的地区。此外，用户可以使用土地利用SA Raster Tools系统中的重新网格化工具，可以直接使用NLCD（分辨率为30m）或/和MODIS土地利用数据（分辨率为1km或500m）直接生成任何区域的土地利用数据。用户可以使用SA中提供的R实用程序，使用通过SA生成的更准确的土地利用数据来更新其地理网格化的土地利用数据。

<!-- BEGIN COMMENT -->

[<< 附录B](CMAQ_UG_appendixB_emissions_control.md) - [返回](../README.md) - [附录D >>](CMAQ_UG_appendixD_parallel_implementation.md)<br>
CMAQ用户指南 (c) 2020<br>

<!-- END COMMENT -->
