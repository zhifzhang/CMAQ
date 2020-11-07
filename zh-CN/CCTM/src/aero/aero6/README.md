CMAQv5.2气溶胶处理模块(Aero6)
==========================================

CMAQ aero6气溶胶计算模块考虑了几个相关的微物理过程：排放、凝结（condensation）、蒸发（evaporation）、凝并（coagulation）、新颗粒形成和化学过程。在此模块中，粒子的大小分布被概念化为三个对数正态模式的总和：艾肯太（Aitken）、积聚太（Accumulation）和粗模态（Coarse）。这些模态的大小和形状通过跟踪三个时刻的大小来及时预测：0th（等于数）、2nd（与表面积成比例）和3rd（与体积或质量成比例）。

无机化学简介

有机化学简介

海盐排放简介

扬尘排放简介

凝并（coagulation）简介

新粒子形成简介

-----
# CMAQv5.2气溶胶模块发布说明

CMAQv5.2中的气溶胶处理模块包括对CMAQv5.1的多个重要修订，其中最显着的是粉尘和有机气溶胶（OA）的表示形式。

  * [气溶胶传输因子](../../docs/Release_Notes/Aerosol_Transmission_Factors.md)
  * [气相沉积速率的更新](../../docs/Release_Notes/Gas-Phase_Dep_H2O2_HACET_OrgNtr_s07tic_Species.md)

