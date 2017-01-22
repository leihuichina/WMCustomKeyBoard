# WMCustomKeyBoard
自定义表情键盘
  最近公司开发中有一个需求,需要自定义表情键盘并且支持gif大图表情,花费了几天时间发现iOS自定义键盘很有意思,于是写下这个demo分享给大家
  自定义表情最注意的两个地方:
  
  *设置UITextView或者UITextField的InputView(InputView就是我们需要自定义的键盘视图);
  
  *继承NSTextAttachment这个类;(我们需要把自定义的表情生成这个对象, 插入NSMutableAttributedString里面)
