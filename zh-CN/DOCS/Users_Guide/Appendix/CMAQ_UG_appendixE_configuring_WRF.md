<!-- BEGIN COMMENT -->

[<< 附录D](CMAQ_UG_appendixD_parallel_implementation.md) - [返回](../README.md)  - [附录F >>](CMAQ_UG_appendixF_importing_bugfixes.md)

<!-- END COMMENT -->

# 附录E：用于空气质量模型的WRF配置

## E.1 WRF 4+版本

* WRF4.0更新了ACM2 PBL模型，以配套新的默认混合坐标系。我们的内部模型运行表明，混合选项（hybrid_opt =2）在诸如洛矶山脉等地形变化更为极端的区域可以改进模型的结果。因此，建议（但不是必须）在WRF中使用此选项，而该选项已成为WRF4.0中的默认选项。

* WRF4.1中的Pleim-Xiu LSM进行了一些重要更新，使用分析方程式（Noilhan和Mahfouf，1996）而非查表法来计算土壤水力学。而且，用户可以选择使用WRF的wrflowinp输入文件中随时间变化的植被分数，该文件可以基于MODIS卫星数据，而不是基于查找表和土地利用分数的旧加权方法。用户可以使用物理名称列表选项“pxlsm_modis_veg = 1”激活此卫星数据选项。


## E.2 WRF 3.7版本
* **[WRF v3.7技术文档中与空气质量建模有关的部分]( http://www2.mmm.ucar.edu/wrf/users/docs/PX-ACM.pdf )：** 这8页pdf文件提供了WRF中使用Pleim-Xiu LSM、ACM2 PBL和Pleim表面层方案的说明和过程，包括最佳做法和名称列表选项。

## E.3 具有闪电同化功能的WRF
* **[具有闪电同化功能的WRF用户指南]( https://wcms.epa.gov/sites/production/files/2017-02/documents/wrf_with_ltga_userguide.pdf )：** 这3页pdf文件描述了如何运行Heath等人（2016）描述的具有闪电同化功能的WRF。同化方法使用网格化的闪电数据来触发和抑制K​​ain-Fritsch中的子网格深对流。通过auxinput8读取网格化的闪电数据（变量名称为“LNT”）。闪电数据分为30分钟的间隔，对于同化方法，将其视为简单的零（不闪电）或一个（闪电）。本文档中描述了所有必要的代码修改和数据。

* **[带有闪电同化代码的WRF]( https://wcms.epa.gov/sites/production/files/2017-02/ltgda_wrf_16feb2017.zip )：** 此.zip文件（ltgda_wrf_16feb2017.zip;220K）包含了注册和FORTRAN文件，以及通过闪电同化运行WRF所需的更新，以及将闪电数据网格化到WRF模拟区域的通用Python脚本。

## E.4 参考文献:
Heath, N. K., J. E. Pleim, R. C. Gilliam, & D. Kang (2016). A simple lightning assimilation technique for improving retrospective WRF simulations, J. Adv. Model. Earth Syst., 8, 1806 – 1824, http://dx.doi.org/10.1002/2016MS000735.

Noilhan, J., & Mahfouf, J. F. (1996). The ISBA land surface parameterization scheme. Global and planetary Change, 13(1-4), 145-159.





<!-- BEGIN COMMENT -->

[<< 附录D](CMAQ_UG_appendixD_parallel_implementation.md) - [返回](../README.md) - [附录F >>](CMAQ_UG_appendixF_importing_bugfixes.md)
CMAQ用户指南 (c) 2020<br>
<!-- END COMMENT -->
