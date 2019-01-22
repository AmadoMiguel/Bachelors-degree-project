% This is a FDN-based reverb test script.
clear, clc, close all
% Input signal
[guit,Fs] = audioread('ElecGtr.wav');
% First, generate impulse response
% Impulse generation
x = zeros(2^16,1);
x(1) = 1;
% Generate impulse response
h = FDN_v(x);
% Process the signal
guit_verb = fftfilt(h, guit);
% Listen to the original Guitar
player = audioplayer(guit,Fs);
% Visualize original signal
subplot(2,1,1), plot(guit),title('Dry signal')
play(player);
pause(11);
% Listen to the processed guitar
player = audioplayer(guit_verb,Fs);
% Visualize processed signal
subplot(2,1,2), plot(guit_verb), ylim([-1 1]),title('Wet signal')
figure
% Visualize IR
plot(h), ylim([-1 1]), title('Impulse Response')
play(player);
pause(12);
stop(player);
function fdn_out = FDN_v(in)
% FDNM FDN-based reverberation algorithm (Length: 4). 
% Author: Miguel Amado
    % This code is part of my undergraduate degree project (a research),
    % B.A. in Music (with emphasis in sound engineering),
    % Advisor: Ricardo Quintana (raqsound@gmail.com).
    % There is no filtering applied in this implemetation. For future 
    % implementations, filtering processes will be applied.
    % Although there is no specific RIR (Room Impulse Response) matching 
    % done, some weird-shape room IRs can be generated through this algorithm. 
    
    % Some cool stuff, like random-generation of prime numbers for delay
    % times (with some own-made modifications), using a Hadamard matrix for
    % feedback coefficients and this way of testing the algorithm 
    % (audioplayer object usage), were suggested processing and programming
    % enhancements from Juan David Sierra (juandsierral@gmail.com).
    
% Every time this code is executed, a different color in reverb is
% generated, due to the way the delay times and the i/o coefficients
% are generated.
d = 1; % Dry signal attenuation factor
% Feedback coefficients matrix (Hadamard)
A = hadamard(4)/sqrt(7.5);    
% Prime numbers
smallPrimes = primes(15);
prims1 = primes(2^randi([smallPrimes(5) smallPrimes(end)])); 
prims2 = primes(2^randi([smallPrimes(1) smallPrimes(4)])); 
% Primes between the given range
prm = prims1(length(prims2):end);
% Random set of 4 primes for delay values
ind = randperm(length(prm),4);
m = prm(ind);% High delay numbers (# of samples)
% Feedback vectors length.              
j = 10000;             
% Feedback vectors initialization   
z1 = zeros(1,j); % First feedback vector 
z2 = zeros(1,j); % Second feedback vector
z3 = zeros(1,j); % Third feedback vector
z4 = zeros(1,j); % Fourth feedback vector
b = rand(4,1).^(1/100) / 0.8;% Random input-wise attenuation coefficients
c = rand(4,1).^(1/100) / 3;% Random output-wise attenuation coefficients
% Output vector initialization
fdn_out = zeros(1,j);
% Feedback signals
for k=j+1:length(in)
    z1(k) = b(1)*in(k-j) + A(1,1)*z1(k-m(1)) + A(1,2)*z2(k-m(2)) + A(1,3)*z3(k-m(3)) + A(1,4)*z4(k-m(4));
    z2(k) = b(2)*in(k-j) + A(2,1)*z1(k-m(1)) + A(2,2)*z2(k-m(2)) + A(2,3)*z3(k-m(3)) + A(2,4)*z4(k-m(4));
    z3(k) = b(3)*in(k-j) + A(3,1)*z1(k-m(1)) + A(3,2)*z2(k-m(2)) + A(3,3)*z3(k-m(3)) + A(3,4)*z4(k-m(4));
    z4(k) = b(4)*in(k-j) + A(4,1)*z1(k-m(1)) + A(4,2)*z2(k-m(2)) + A(4,3)*z3(k-m(3)) + A(4,4)*z4(k-m(4));
end
% Output signal
for k=j+1:length(in)
     fdn_out(k-j) = c(1)*z1(k-m(1)) + c(2)*z2(k-m(2)) + c(3)*z3(k-m(3)) + c(4)*z4(k-m(4))+ d*in(k);
end
end

