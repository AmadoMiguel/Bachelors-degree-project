% spatVerb (spatialized reverb) algorithm

% In this algorithm (which is based on ISM_script.m), reverb and
% spatialization are combined. Spatialization is added by considering a 
% stereo listener (two listener points instead of just one). So, two IRs
% are calculated, one for each "ear" (IID and ITD). Therefore, two 
% convolved signals are obtained. Each one of them is located on its 
% corresponding final output array side called y_out.

clc, clear, close all
x = audioinfo('Drums.wav'); 
% x = audioinfo('ElecGtr.wav');
switch x.NumChannels
    case 1 
        audio = audioread(x.Filename); 
    case 2
        audio = audioread(x.Filename); audio = audio(:,1);
end
% IR calculation for both "ears" ("Head" diameter: 20cm)
IR_l = ISM_dis(-0.60,2,-0.05,-0.10,0,0.10,3.03,4.35,2.44,x.SampleRate);
IR_r = ISM_dis(-0.60,2,-0.05,0.10,0,0.10,3.03,4.35,2.44,x.SampleRate);
% Process the signal
y_l = fftfilt(IR_l,audio);
y_r = fftfilt(IR_r,audio);
% Output array
y_out = [y_l y_r];
% Listen to original signal
figure
subplot(2,1,1), plot(audio), title("Dry signal")
player = audioplayer(audio,x.SampleRate);
play(player);
pause(10);
stop(player);
% Listen processed signal
subplot(2,1,2), plot(y_out(:,1),'r'), hold on, ...
plot(y_out(:,2),'g'), title("Processed signal")
player = audioplayer(y_out,x.SampleRate);
% IRs visualization
figure, title("Impulse Responses"),xlim([0 100000]),
plot(IR_l,'r'), hold on, plot(IR_r,'g'), legend('IR_l','IR_r')
play(player);
pause(12);
stop(player);

% Export processed audio
##audiowrite('Batería_Abs_-0.60x_2y_-0.05z_ISM.wav',y_out,x.SampleRate);