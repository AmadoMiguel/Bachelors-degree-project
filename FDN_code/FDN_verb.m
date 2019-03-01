clear, clc, close all

% This is a FDN-based reverb test script.

% Input signal
 au = audioinfo('Drums.wav'); 
##au = audioinfo('ElecGtr.wav');
switch au.NumChannels
    case 1 
        [audio,Fs] = audioread(au.Filename); 
    case 2
        [audio,Fs] = audioread(au.Filename); audio = mean(audio,2);
end
% First, generate impulse response
% Impulse generation
x = zeros(30000,1);
x(1) = 1;
% Generate impulse response
h = FDN_v(x);
% Process the signal
audio_verb = fftfilt(h, audio);
% Listen to the original Guitar
player = audioplayer(audio,Fs);
% Visualize original signal
subplot(2,1,1), plot(audio),title('Dry signal')
play(player);
pause(11);
% Listen to the processed guitar
player = audioplayer(audio_verb,Fs);
% Visualize processed signal
subplot(2,1,2), plot(audio_verb), ylim([-1 1]),title('Wet signal')
figure
% Visualize IR
plot(h), ylim([-1 1]), title('Impulse Response')
play(player);
pause(12);
stop(player);


