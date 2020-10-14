<!-- BEGIN COMMENT -->

[<< 附录E](CMAQ_UG_appendixE_configuring_WRF.md) - [返回](../README.md)

<!-- END COMMENT -->

# 附录F：从CMAQ github页面导入Bugfixes

## F.1 将Bugfixs从问题页面导入到您的本地空间

* 用户有两个方法从CMAQ github的问题页面导入Bugfixes，具体取决于用户如何在本地配置其CMAQ储存库。第一个方法涉及将更改移植到用户的github存储库或源代码存储库，而第二个方法将更改移植到用户的CMAQ项目。CMAQ团队建议使用第一个选项，因为这将允许用户使用Bugfixes多次配置和构建模型。

## F.2 方法1：将Bugfixes导入本地github存储库或源代码存储库

* 要将Bugfixes导入您的本地github存储库/源代码存储库，请在执行以下步骤之前注意以下几点：

- 此方法将要求您重新编译安装各个CMAQ项目以使效果生效。因此，如果您在CMAQ项目中已对源代码进行了更改，则在进行本次更改时，该方法将不会保留您对源代码的这些更改。

- 此方法不会保留您在本地github或源代码存储库中对源代码所做的任何更改。例如如果对化学求解器源代码（如hrsolver.F）进行了特定更改，并且您要移植包含（如hrsolver.F）中的错误修正的新代码，则您所做的特定更改将被覆盖。
  
* 将Bugfixes移植到本地github存储库或源代码目录的步骤：

- 转到[CMAQ已知问题页面]( https://github.com/USEPA/CMAQ/issues )，然后单击您的问题。
  
- 通过查看解决方案来确定哪些文件需要更新，点击指向这些文件的链接。
  
- 现在，您应该位于特定问题页面的Known_Issues文件夹下。在这里，您应该能够看到所有需要更新的文件。
  
- 将这些文件下载到您的系统中，并将它们存储在临时文件夹中，对于Unix系统上的文件，可以使用以下命令：

```
wget https://raw.githubusercontent.com/USEPA/CMAQ/master/DOCS/Known_Issues/CMAQv5.3.1-i#/your_files
```

- 获得Bugfixes文件的更新版本后，需要查找这些文件在源代码中的位置，以便可以替换它们。通常，这些文件位于CMAQ存储库中的CCTM/src文件夹之一中。 然后，您只需转到该文件所在的位置，然后简单地用已修正错误的文件替换该文件即可。对于Unix系统上的用户，可以使用以下命令：
  
```
To find where the file is located use:

  find /path_to_my_src -name foo.f 
  
Once the file is located use: 

  cp /foo.f /path_to_my_src/foo.f 
```

* 然后，可以按照[用户指南]( https://github.com/zhifzhang/CMAQ/blob/master/zh-CN/DOCS/Users_Guide/CMAQ_UG_ch05_running_a_simulation.md#56-compiling-cmaq-chemistry-transport-model-cctm )中提供的说明来重新编译CMAQ。


## F.3 方法2：将Bugfixes导入本地CMAQ项目

* 要将Bugfixes导入到本地CMAQ_Project目录，请在执行以下步骤之前注意以下几点：

- 此方法会指导您更新CMAQ储存库目录之外的CMAQ项目目录内的scripts目录下BLD目录中的文件。更改之后，您将需要重新编译模型。因为采用此方法Bugfixes程序仅更新您的本地CMAQ项目（而不是您的CMAQ储存库），所以CMAQ团队不建议使用此方法，因为其他目录中的任何后续项目都必须遵循相同的过程。

- 将Bugfixes文件移植到本地项目目录时，请注意，您对错误修正前的文件所做的任何本地更改都将被Bugfixes文件覆盖。例如如果对化学求解器源代码（如hrsolver.F）进行了特定更改，并且您要移植包含（如hrsolver.F）中的错误修正的新代码，则您所做的特定更改将被覆盖。
 
- 如果您没有构建可执行文件（例如，如果系统管理员为您构建了可执行文件），请通知您的系统管理员使用任一选项重新构建可执行文件。


* 将Bugfixes移植到本地项目目录的步骤：

-转到[CMAQ问题页面](https://github.com/USEPA/CMAQ/issues)，然后单击您的问题。
  
- 通过查看解决方案来确定哪些文件需要更新，点击指向这些文件的链接。
  
- 现在，您应该位于特定问题页面的Known_Issues文件夹下。在这里，您应该能够看到所有需要更新的文件。
  
- 将这些文件下载到您的系统中，并将它们存储在临时文件夹中，对于Unix系统上的文件，可以使用以下命令：

```
wget https://raw.githubusercontent.com/USEPA/CMAQ/master/DOCS/Known_Issues/CMAQv5.3.1-i#/your_files
```
- 获得Bugfixes文件后，转到创建BLD目录的脚本目录。
  
- 在脚本目录中，转到BLD目录。 这是本地项目的源代码所在的位置，可执行文件也位于此处。
  
- 将Bugfixes的文件复制到此文件夹，以有效替换错误修正的文件。
  
- 通过输入以下命令重新编译模型：make

* 如果您无法正确编译，请与在[CMAQ问题页面](https://github.com/USEPA/CMAQ/issues)与发布问题的作者联系。

<!-- BEGIN COMMENT -->

[<< 附录E](CMAQ_UG_appendixE_configuring_WRF.md) - [返回](../README.md)<br>
CMAQ用户指南 (c) 2020<br>
<!-- END COMMENT -->
