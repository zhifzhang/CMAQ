bldoverlay
========

该Fortran程序创建一个观测覆盖文件，可以将其导入PAVE或VERDI。它需要一个包含特定格式的观测数据作为输入文件，然后创建一个PAVE/VERDI兼容的覆盖文件。

## 使用的运行环境变量

```
 IOAPI_ISPH    投影球类型（使用类型#20以匹配WRF/CMAQ）
               （此程序的默认值为20，覆盖了ioapi的默认值8）
 SDATE         开始日期，格式为：YYYYDDD
 EDATE         结束日期，格式为：YYYYDDD
 FILETYPE      要使用的输入文件的类型（请参阅下面的信息），选项包括：OBS、SITES（默认为OBS）
 OLAYTYPE      输出的覆盖文件的数据类型。如果输入数据是每日的，则应将其设置为“DAILY”。
               如果输入数据是每小时的，则可以选择：HOURLY、1HRMAX、8HRMAX
 SPECIES       输入文件中的物种名称列表（例如，setenv SPECIES 'O3,NO,CO'）
 UNITS         输入文件中的物种单位列表（例如，setenv UNITS 'ppb,ppb,ppb'）
 INFILE        包含观测数据的输入文件
 TZFILE        时区数据文件tz.csv的位置（这是必需的输入文件）
 HOURS_8HRMAX  计算每日最大8小时臭氧量时要使用的时间数。
               允许值为24（使用所有本地时间从0-23小时开始的8小时平均值）和17（仅使用17个本地时间从7-23小时开始的8小时平均值）（默认值为24）
 MISS_CHECK    在计算日最大8小时平均值时，是否将数据覆盖范围不完整的日期设置为丢失（TRUE/FALSE）
 OUTFILE       要创建的覆盖文件的名称
```

## 输入文件类型和格式

Bldoverlay接受“OBS”和“SITES”格式的输入文件。对于每小时的输出数据（OLAYTYPE HOURLY），程序假定观测时间为当地标准时间（LST），并使用每15度经度的时区进行简单的时区偏移为GMT。对于每日的输出数据（OLAYTYPE DAILY、1HRMAX或8HRMAX），不进行任何时间偏移，因此输出数据也采用LST。在这种情况下，用户可以使用[HR2DAY实用程序]( ../hr2day )进行时间偏移，并将每小时的模型数据进行平均以创建每日的模型字段值（采用LST）。

```
 OBS format:     OBS格式由逗号分隔的值组成，格式为YYYDDD、HH、Site_ID、经度、纬度、Value1[，Value2，Value3，...]。
				 请注意，如果输入文件是每日数据，则输入文件中仍需要一个小时列（HH）。在这种情况下，HH被忽略，因此用户可以将所有记录的此值设置为0。
 SITES format:   使用VALUE设置的值进行设置以创建静态站点文件（默认值为1）。
                 该文件采用制表符（tab）分隔的格式，其结构为Site_ID 经度 纬度。
```
## 编译bldoverlay源代码

运行构建脚本以编译bldoverlay：

```
cd $CMAQ_HOME/POST/bldoverlay/scripts
./bldit_bldoverlay.csh [compiler] [version] |& tee build_bldoverlay.log
```


## 运行bldoverlay：
```
 ./run.bldoverlay |& tee bldoverlay.log
```

检查日志文件以确保完整、正确的执行而没有错误。

*关于VERDI中的叠加层的注意事项：
VERDI具有直接读取.csv或制表符（tab）分隔的观测数据的功能。每小时的观测数据必须使用UTC。有关更多详细信息，请参见[VERDI文档]( https://github.com/CEMPD/VERDI/releases )。*

