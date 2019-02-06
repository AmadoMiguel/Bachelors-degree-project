clc, clear, close all
% Read audio file and its properties (any audio file can be loaded). Two
% are suggested here.
% x = audioinfo('Drums.wav'); 
x = audioinfo('ElecGtr.wav');
switch x.NumChannels
    case 1 % Mono file
        audio = audioread(x.Filename); 
    case 2 % Stereo file (hopefully both l & r sides in phase)
        audio = audioread(x.Filename); audio = mean(audio,2);
end
% Visualize dry signal
subplot(2,1,1), plot(audio), title('Dry signal')
% Calculate IR
%        src_x src_y src_z mic_x mic_y mic_z wdth lrge hght
IR = ISM(-19,   15,    17,    10,   -9,   -10,  25,  20,  20, ...
    x.SampleRate);
% Process the signal
y = fftfilt(IR,audio);
% Prevent clipping
y = (y / max(abs(y)))*0.85;
% Listen to original signal
player = audioplayer(audio,x.SampleRate);
play(player);
pause(10);
stop(player);
% Visualize processed signal
subplot(2,1,2), plot(y), title('Processed signal')
% Visualize IR
figure, plot(IR),title('Impulse Response')
% Listen processed signal
player = audioplayer(y,x.SampleRate);
play(player);
pause(12);
stop(player);
