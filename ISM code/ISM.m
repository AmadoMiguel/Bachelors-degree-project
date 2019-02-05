function IR = ISM(sourc_x,sourc_y,sourc_z,mic_x,mic_y,mic_z,width,large,...
    height,Fs)
%ISM Calculates a rectangular room IR with certain acoustic and geometric
%parameters using the Image Source Method. 
% Author: Miguel Amado
    % This code is part of my undergraduate degree project (a research),
    % B.A. in Music (with emphasis in sound engineering),
    % Advisor: Ricardo Quintana (raqsound@gmail.com).    
    
    % Some improvements (absorption coefficients generation, absorption 
    % function calculation) were suggested by Juan Sierra 
    % (www.juansaudio.com).

% IR vector initialization
IR = [];

% Sound velocity
cSound = 340;
% Air damping coefficient
airDamp = 0.007;
% Number of reflections per axis
N = 90;
n = -N:N;
[l,m,n] = meshgrid(n,n,n);
% Absorption coefficients
coefabsor_x1 = rand().^(1/20); coefabsor_x2 = rand().^(1/20);
coefabsor_y1 = rand().^(1/20); coefabsor_y2 = rand().^(1/20);
coefabsor_z1 = rand().^(1/20); coefabsor_z2 = rand().^(1/20);
coefAbsor = [coefabsor_x1,coefabsor_x2,coefabsor_y1,coefabsor_y2,...
             coefabsor_z1,coefabsor_z2];

% IR obtention procedures

% Image cell coordinates 
dx = ((width*l)+(((-1).^l)*sourc_x))-mic_x;
dy = ((large*m)+(((-1).^m)*sourc_y))-mic_y;
dz = ((height*n)+(((-1).^n)*sourc_z))-mic_z;
% Distances from image cell to listener
Dlmn = sqrt((dx.^2)+(dy.^2)+(dz.^2));
% Room absorption function per axis
coefAbsor = -abs(coefAbsor);
absorFunc_x = coefAbsor(1).^(abs(0.5.*l - 0.25 + 0.25.*(-1).^l)).*...
              coefAbsor(2).^(abs(0.5.*l + 0.25 - 0.25.*(-1).^l));
absorFunc_y = coefAbsor(3).^(abs(0.5.*m - 0.25 + 0.25.*(-1).^m)).*...
              coefAbsor(4).^(abs(0.5.*m + 0.25 - 0.25.*(-1).^m));
absorFunc_z = coefAbsor(5).^(abs(0.5.*n - 0.25 + 0.25.*(-1).^n)).*...
              coefAbsor(6).^(abs(0.5.*n + 0.25 - 0.25.*(-1).^n));    
absorFunc = absorFunc_x.*absorFunc_y.*absorFunc_z;        
% Air damping function
airDampFunc = exp(-airDamp*Dlmn);
% Damping coefficient
P = (1./(4*pi*(Dlmn.^2))).*absorFunc.*airDampFunc;
% Delays due to distance
realTime = Dlmn/cSound;
nSample = round(realTime*Fs,0);
% IR obtention
IR(nSample) = P;
% IR normalization
IR = IR/max(abs(IR)); 
end

