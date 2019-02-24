%% spatVerb (spatialized reverb) algorithm

% In this algorithm (which is based on ISM_script.m), reverb and
% spatialization are combined. Spatialization is added by considering a 
% stereo listener (two listener points instead of just one). So, two IRs
% are calculated, one for each "ear" (IID and ITD). Therefore, two 
% convolved signals are obtained. Each one of them is located on its 
% corresponding final output array side called y_out.
%%
clc, clear, close all
x = audioinfo('Drums.mp3'); 
% x = audioinfo('ElecGtr.wav');
switch x.NumChannels
    case 1 
        audio = audioread(x.Filename); 
    case 2
        audio = audioread(x.Filename); audio = mean(audio,2);
end
% IR calculation for both "ears" ("Head" diameter: 20cm)
IR_l = ISM_dis(-40,25,-2,-0.10,0,0,50,40,20,x.SampleRate);
IR_r = ISM_dis(-40,25,-2,0.10,0,0,50,40,20,x.SampleRate);
% Process the signal
y_l = fftfilt(IR_l,audio);
y_r = fftfilt(IR_r,audio);
% Output array (clipping avoided)
y_out = [y_l*0.9 y_r*0.9];
% Listen to original signal
figure
subplot(3,1,1), plot(audio), title("Dry signal")
player = audioplayer(audio,x.SampleRate);
play(player);
pause(10);
stop(player);
% Listen processed signal
subplot(3,1,2), plot(y_out(:,1),'r'), title("Processed signal (l)")
subplot(3,1,3), plot(y_out(:,2),'r'), title("Processed signal (r)")
player = audioplayer(y_out,x.SampleRate);
% IRs visualization
figure
% Visualize right "ear" IR
subplot(2,1,2), plot(IR_r), title('Right "ear" IR')
% Visualize left "ear" IR
subplot(2,1,1), plot(IR_l), title('Left "ear" IR')
play(player);
pause(12);
stop(player);