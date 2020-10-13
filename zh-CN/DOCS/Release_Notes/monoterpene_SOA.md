# *AERO7* monoterpene SOA from photoxodiation

[Havala O. T. Pye](mailto:pye.havala@epa.gov), U.S. Environmental Protection Agency

## Brief Description
Monoterpene oxidation accounts for half the organic aerosol in the 
southeastern U.S. in summer, yet it is significantly underestimated in CMAQv5.2 
with *aero6* (Zhang et al. 2018). This update replaces the Odum 2-product
monoterpene SOA in *aero6* with updated yields based on more recent 
experiments by Saha and Greishop (2016). The new yields are represented 
using a volatility basis set (VBS) fit and applied to both OH and ozone oxidation 
of monoterpenes. The fit allows for prompt formation of low-volatility 
material, which is more consistent with recent observations. No additional 
chemistry, such as oligomerization, is applied to the prompt yields. 
This update was implemented in Xu et al. (2018) and additional information is available
in their supporting information. Note that 7 VBS bins were used in the implementation of Xu et al. 
The highest volatility bin was not included in the CMAQ v5.3 implementation as it had very minor 
contributions to the SOA even under cold conditions with high loadings. 
                       
New Species: AMT1-6J, SVMT1-6  
Deprecated species: ATRP1-2J, SV_TRP1-2

## Significance and Impact
Significantly increases organic aerosol and dry PM<sub>2.5</sub> mass, particularly 
in summer in the southeast U.S.
Minor increases in mass occur at other times of year, including winter.                       

## Affected Files
CCTM/src/aero/aero7 (linked to *aero6*)  
deposition files  
*aero7* and *aero7i* mechanisms                       

## References
Griffin, R. J., Cocker, D. R., Flagan, R. C., and Seinfeld, J.
H.: Organic aerosol formation from the oxidation of biogenic
hydrocarbons, *Journal of Geophysical Research-Atmospheres*, **104**, 3555-3567,
https://doi.org/10.1029/1998jd100049, 1999.

Saha, P. K. and Grieshop, A. P.: Exploring Divergent Volatility
Properties from Yield and Thermodenuder Measurements
of Secondary Organic Aerosol from α-Pinene
Ozonolysis, *Environmental Science & Technology*, **50**, 5740-5749,
https://doi.org/10.1021/acs.est.6b00303, 2016.
                       
Xu, L., Pye, H. O. T., He, J., Chen, Y., Murphy, B. N., and Ng, N. L.: Experimental and model estimates of the contributions from biogenic monoterpenes and sesquiterpenes to secondary organic aerosol in the southeastern United States, *Atmospheric Chemistry and Physics*, **18**, 12613-12637, https://doi.org/10.5194/acp-18-12613-2018, 2018.

Zhang, H, et al.: Monoterpenes are the
largest source of summertime organic aerosol in the southeastern
United States, *Proceedings of the National Academy of Sciences*, **115**, 2038-2043,
https://doi.org/10.1073/pnas.1717513115, 2018

-----
## Internal Records
#### Relevant Pull Requests:
See [aero7 overview](aero7_overview.md)



-----

