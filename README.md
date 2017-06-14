# LGApplications
个人demo集合 未完待续

下载后找不到PCH文件的,可以在 Build Settings里搜索prefix header, 然后 设置 Precompile Prefix Header 为YES; 再设置 Prefix Header 路径, 双击后,直接把左侧的PrefixHeader.pch拉进弹框里,回车就OK了. 不明白的参考http://blog.csdn.net/lg767201403/article/details/72910696 这篇博客

将自己自定义的一些控件,写成demo,有需要的朋友可以拿来参考

LGApplications/Util/LGViews     :   自定义View

LGApplications/Util/Category    :   里面都是项目中常用的,几乎每个项目必备

LGApplications/Util/LGUtil      :   一些常用的公有方法

LGApplications/Util/UIDefines.h :   常用的宏

注:       里面用到最常用的两个框架SDWebImage 和 Masonry

申明:     项目内容仅供参考,使用过程中带来任何bug,概不负责

1.LGActionSheet                 :   类似微信的那个底部弹窗,使用简单方便

2.LGPickerView                  :   滑动选择器,支持自定义选项,日期,地区三种样式,自定义选项只需要传进去options数组即可

3.SingleChoiceTableView         :   用tableView实现多个题目的单项选择,只提供一个思路,毕竟具体项目需要不同

4.LGTextView                    :   带placeholder的textView

5.LGGradientLabel               :   渐变文字Label

6.ScorllView嵌套                 :   底部纵向ScrollView,上面有横向的ScrollView,横向的上面还有纵向的tableView
