# 使用LMS算法的多麦克风降噪 #



录制一段语音信号`input.wav`（默认为无噪环境），为这段语音添加高斯噪声设定为主麦克风，得到主麦克风录制的受噪声污染的语音信号和参考麦克风录制的噪声`LMSrefns.wav`，利用LMS算法实现语音增强的目标，得到清晰的语音信号。

（1）主麦克风录制的语音信号是`LMSprimsp.wav`，参考麦克风录制的参考噪声是`LMSrefns.wav`.用matlab指令读取；

（2）利用LMS算法对`LMSprimsp.wav`进行滤波去噪；

（4）算法仿真收敛以后，得到降噪后的语音信号；

（5）用matlab指令回放增强后的语音信号；

（6）分别对增强前后的语音信号作频谱分析并plot出来。

主代码：`main_.m`

LMS实现：`LMSmyFilter.m`

**此处主程序没有调用自己实现的LMS算法函数，而是调用dsp工具箱中的LMS实现函数。**

- 期望的语音信号
![](https://i.imgur.com/6OBO2K2.jpg)
- 主麦克风的语音信号
![](https://i.imgur.com/yaIc6ms.jpg)
- 副麦克风的语音信号
![](https://i.imgur.com/mInHAqu.jpg)
- LMS降噪后的语音信号
![](https://i.imgur.com/VP98Onj.jpg)