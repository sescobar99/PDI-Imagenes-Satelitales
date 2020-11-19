path 9 row 54: Norte
path 9 row 55: Sur
$ ls | grep -E -v ".*QB\.tif|.*TIR\.tif" | xargs cp -t ../ls45


$ ls | grep -E -v "009054|009055"
LT05_L1GS_115189_19910913_20170214_01_T2.tif
LT05_L1GS_115190_19910913_20170214_01_T2.tif
LT05_L1TP_008055_19911204_20170213_01_T1.tif


Landsat scenes are processed to a Level-1 precision and terrain corrected product (L1TP) if possible. In the case of insufficient reference data, a systematic and terrain corrected L1GT or a systematic L1GS product will be created instead.

L1GT products are created when the systematic product has consistent and sufficient locational accuracy to permit the application of a terrain model.

L1GS products are created when the locational accuracy is not sufficient to apply terrain correction, such as:  

Insufficient number of ground control points, such as small islands or Antarctic
Opaque clouds that obscure the ground
Locational errors greater than the search distance for ground control


Natural color
TIR- termal infrared
QB- quality band? Quality


*Landsat Product Identifier*
*Field Definition:  The naming convention of each L7 ETM+ Collection 1 Level-1 image is based on acquisition and processing parameters.
Format:
	LXSS_LLLL_PPPRRR_YYYYMMDD_yyyymmdd_CC_TX

	L = Landsat
	X = Sensor (E = Enhanced Thematic Mapper Plus)
	SS = Satellite (07 = Landsat 7)
	LLLL = Processing Correction Level (L1TP = precision and terrain, L1GT = systematic terrain, L1GS = systematic)
	PPP = WRS Path
	RRR = WRS Row
	YYYYMMDD = Acquisition Date expressed in Year, Month, Day
	yyyymmdd = Processing Date expressed in Year, Month, Day
	CC = Collection Number (01)
	TX = Collection Category (RT = Real Time, T1 = Tier 1, T2 = Tier 2)

	Example: LE07_L1TP_029030_20140715_20140805_02_T1

*Collection Category*
*Field Definition:  Landsat Collection 1 is organized by a tiered inventory structure to indicate the quality and level of processing of the data.

Values:
	T1 = Tier 1 is the highest available quality and processing level. This category is suitable for time-series analysis across the different Landsat sensors.

	T2 = Tier 2 scenes contain significant cloud cover and have insufficient ground control to generate precision and terrain corrected products.

	RT = Real-Time indicates initial processing with additional processing required to achieve Tier 1 or Tier 2.


