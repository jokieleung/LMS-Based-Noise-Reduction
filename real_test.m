%************* ��Ϣ�����Ⱥ�γ��ۺ����********************
% ���⣺����LMS-�㷨�Ķ���˷罵�뼼��
% Designer:JokieLeung ͨ��1503-�����
% Date:2018-7-1
close all %�ر����д���

%STEP1:���������������������źŵ�ʱ���Ƶ���ͼ��
input_signal = audioread('input.wav');   %����Ŀ�����������źţ���Ϊ�����źţ�
n=length(input_signal) ; 
P=fft(input_signal,n);                      %���ٸ���Ҷ�任
figure;
subplot(2,1,1);
plot(input_signal);
axis([0 250000 -2 2]);
ylabel('��ֵ');
xlabel('ʱ��');
title('������ԭʼ���������������ź�','fontweight','bold');
grid;
subplot(2,1,2);
plot(abs(P));
axis([0 1000 0 2000]);
title('������ԭʼ�������������ź�Ƶ��','fontweight','bold');
grid;

%STEP2:���ɸ�˹���������뵽ԭ�źţ�input_with_noise��noise�ֱ�ģ��Ϊ����˷�͸���˷�
noise = audioread('real_noise.wav');%0.95*max(input_signal(:,1))*randn(length(input_signal),1);  %���ɸ�˹�������޷�
input_with_noise = audioread('real_main_with_noise.wav');%input_signal + noise; %�����������ź�
audiowrite('test2_LMSrefns.wav',noise,44100) ;   %���ģ�������ļ�
audiowrite('test2_LMSprimsp.wav',input_with_noise,44100);  %���ģ���������ź�

%STEP3:����˷磨���������������źŵĶ�ȡ������ʱ���Ƶ��ͼ��
[primary,fs]=audioread('test2_LMSprimsp.wav');
n=length(primary) ; 
P=fft(primary,n);                              %���ٸ���Ҷ�任
figure;
subplot(2,1,1);
plot(primary);
axis([0 250000 -2 2]);
ylabel('��ֵ');
xlabel('ʱ��');
title('����˷磨���������������ź�','fontweight','bold');
grid;
subplot(2,1,2);
plot(abs(P));
axis([0 1000 0 2000]);
title('����˷磨�������������ź�Ƶ��','fontweight','bold');
grid;

%STEP4:�ο���˷�(������)¼�Ƶ������źŲ�����ʱ���Ƶ��ͼ��
[fref,fs]=audioread('test2_LMSrefns.wav');
fref = fref(1:374784,:);
n=length(fref) ; 
F=fft(fref,n);  
figure;
subplot(2,1,1);
plot(fref);grid;
ylabel('��ֵ');
xlabel('ʱ��');
title('�ο���˷�(������)�������ź�','fontweight','bold');
subplot(2,1,2);
plot(abs(F));
title('�ο���˷�(������)�����ź�Ƶ��','fontweight','bold');
grid;

%STEP5:����Ԥ��Ŀ���ź��Լ�����LMS�˲�����Ҫ�Ĳ���rho_max��mu
xs=primary -fref;
xn =primary ;                  % �����ź�����
dn = xs ;                      % Ԥ�ڽ������
M  = 20   ;                   % �˲�������
rho_max = max(eig(xn.'*xn));     %�����ź���ؾ�����������ֵ
mu =0.001*(1/rho_max)   ;     %�������� 0 < mu < 1/rho

%STEP6:ʵ��LMS�˲��㷨�����˲�����ź����Ϊyn
lms1 = dsp.LMSFilter(12,'StepSize',mu);
[en,yn,W] = lms1(xn(:,1),dn(:,1)); 

%STEP7:������LMS�˲�������źŵ�ʱ���Ƶ��ͼ��
figure;
subplot(2,1,1);
plot(yn);grid;
axis([0 250000 -2 2]);
ylabel('��ֵ');
xlabel('ʱ��');
title('LMS�˲���������ź�');
%��������Ӧ�˲�������ź�Ƶ��
n=length(yn) ; 
Yy=fft(yn,n); 
subplot(2,1,2);
plot(abs(Yy));grid;
axis([0 1000 0 2000]);
title('LMS�˲���������ź�Ƶ��');

%STEP8:�����LMS�˲���������źţ�������Ϊ�ļ�LMS_filted.wav
sound(yn,fs);      %�����������������
audiowrite('test2_LMS_filted.wav',yn,44100);  %���������ļ�LMS_filted.wav��ʽ
