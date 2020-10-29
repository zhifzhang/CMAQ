appendwrf
========

该Fortran程序将多个WRF输入或输出文件中的变量沿“时间”（无限制）维连接到单个文件中。可以使用户将生成的较短时间段内的WRF输入或输出文件合并为更长（例如每月）持续时间的文件。

## 使用的运行环境变量

```
 INFILE_1      input file number 1, (max of 15).
 INFILE_2      input file number 2, (max of 15).
 OUTFILE       output file name
```

## 编译appendwrf源代码

执行构建脚本来编译appendwrf：

```
cd $CMAQ_HOME/POST/appendwrf/scripts
./bldit_appendwrf.csh [compiler] [version] |& tee build_appendwrf.log
```

## 运行appendwrf
编辑运行脚本示例（run.appenwrf），然后运行：
```
 ./run.appendwrf |& tee appendwrf.log
```

检查日志文件以确保完整、正确的执行且没有错误。