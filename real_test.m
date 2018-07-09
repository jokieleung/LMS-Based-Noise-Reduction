%************* 信息处理课群课程综合设计********************
% 课题：基于LMS-算法的多麦克风降噪技术
% Designer:JokieLeung 通信1503-梁祖杰
% Date:2018-7-1
close all %关闭所有窗口

%STEP1:构建输入无噪声的输入信号的时域和频域的图像
input_signal = audioread('input.wav');   %读入目标输入语音信号（设为期望信号）
n=length(input_signal) ; 
P=fft(input_signal,n);                      %快速傅里叶变换
figure;
subplot(2,1,1);
plot(input_signal);
axis([0 250000 -2 2]);
ylabel('幅值');
xlabel('时间');
title('期望（原始无噪声）的语音信号','fontweight','bold');
grid;
subplot(2,1,2);
plot(abs(P));
axis([0 1000 0 2000]);
title('期望（原始无噪声）语音信号频谱','fontweight','bold');
grid;

%STEP2:生成高斯噪声并加入到原信号，input_with_noise和noise分别模拟为主麦克风和副麦克风
noise = audioread('real_noise.wav');%0.95*max(input_signal(:,1))*randn(length(input_signal),1);  %生成高斯噪声并限幅
input_with_noise = audioread('real_main_with_noise.wav');%input_signal + noise; %添加噪声后的信号
audiowrite('test2_LMSrefns.wav',noise,44100) ;   %输出模拟噪声文件
audiowrite('test2_LMSprimsp.wav',input_with_noise,44100);  %输出模拟主语音信号

%STEP3:主麦克风（含噪声）的语音信号的读取并构建时域和频域图像
[primary,fs]=audioread('test2_LMSprimsp.wav');
n=length(primary) ; 
P=fft(primary,n);                              %快速傅里叶变换
figure;
subplot(2,1,1);
plot(primary);
axis([0 250000 -2 2]);
ylabel('幅值');
xlabel('时间');
title('主麦克风（含噪声）的语音信号','fontweight','bold');
grid;
subplot(2,1,2);
plot(abs(P));
axis([0 1000 0 2000]);
title('主麦克风（含噪声）语音信号频谱','fontweight','bold');
grid;

%STEP4:参考麦克风(单噪声)录制的噪声信号并构建时域和频域图像
[fref,fs]=audioread('test2_LMSrefns.wav');
fref = fref(1:374784,:);
n=length(fref) ; 
F=fft(fref,n);  
figure;
subplot(2,1,1);
plot(fref);grid;
ylabel('幅值');
xlabel('时间');
title('参考麦克风(单噪声)的噪声信号','fontweight','bold');
subplot(2,1,2);
plot(abs(F));
title('参考麦克风(单噪声)噪声信号频谱','fontweight','bold');
grid;

%STEP5:计算预期目标信号以及构建LMS滤波器需要的参数rho_max和mu
xs=primary -fref;
xn =primary ;                  % 输入信号序列
dn = xs ;                      % 预期结果序列
M  = 20   ;                   % 滤波器阶数
rho_max = max(eig(xn.'*xn));     %输入信号相关矩阵的最大特征值
mu =0.001*(1/rho_max)   ;     %收敛因子 0 < mu < 1/rho

%STEP6:实现LMS滤波算法并将滤波后的信号输出为yn
lms1 = dsp.LMSFilter(12,'StepSize',mu);
[en,yn,W] = lms1(xn(:,1),dn(:,1)); 

%STEP7:构建经LMS滤波后输出信号的时域和频域图像
figure;
subplot(2,1,1);
plot(yn);grid;
axis([0 250000 -2 2]);
ylabel('幅值');
xlabel('时间');
title('LMS滤波器后输出信号');
%绘制自适应滤波器输出信号频谱
n=length(yn) ; 
Yy=fft(yn,n); 
subplot(2,1,2);
plot(abs(Yy));grid;
axis([0 1000 0 2000]);
title('LMS滤波器后输出信号频谱');

%STEP8:输出经LMS滤波后的语音信号，并保存为文件LMS_filted.wav
sound(yn,fs);      %语音输出降噪后的语音
audiowrite('test2_LMS_filted.wav',yn,44100);  %生成语音文件LMS_filted.wav格式
