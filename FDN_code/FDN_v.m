FDN_v is the command-line function:

function fdn_out = FDN_v (in)
  ## FDN_v FDN-based reverberation algorithm (Length: 4). 
  ## Author: Miguel Amado
  
  ## This code is part of my undergraduate degree project (a research),
  ## B.A. in Music (with emphasis in sound engineering),
  ## Advisor: Ricardo Quintana (raqsound@gmail.com).
  
  ## There is no filtering applied in this implemetation. For future 
  ## implementations, filtering processes will be applied.
  ## Although there is no specific RIR (Room Impulse Response) matching 
  ## done, some weird-shape room IRs can be generated through this 
  ## algorithm. 
  
  ## Some cool stuff, like random-generation of prime numbers for delay
  ## times (with some own-made modifications), using a Hadamard matrix for
  ## feedback coefficients and this way of testing the algorithm 
  ## (audioplayer object usage), were suggested processing and programming
  ## enhancements from Juan David Sierra (juandsierral@gmail.com).
  
  ## Every time this code is executed, a different color in reverb is
  ## generated, due to the way the delay times and the i/o coefficients
  ## are generated.
  
  ## Dry signal damping coefficient
  d = 1;
  ## Feedback coefficients matrix (Hadamard)
  A = hadamard (4) / sqrt (7.5);
  ## Prime numbers
  smallPrimes = primes (15);
  prims1 = primes (2 ^ randi ([smallPrimes(5), smallPrimes(end)]));
  prims2 = primes (2 ^ randi ([smallPrimes(1), smallPrimes(3)]));
  ## Primes between the given range
  prm = prims1 (length (prims2):end);
  ## Random set of 4 primes for delay values
  ind = randperm (length (prm), 4);
  ## High delay numbers (# of samples)
  m = prm (ind);
  ## Feedback vectors initialization
  ## Feedback vectors length.       
  j = 10000;
  ## First feedback vector 
  z1 = zeros (1, j);
  ## Second feedback vector
  z2 = zeros (1, j);
  ## Third feedback vector
  z3 = zeros (1, j);
  ## Fourth feedback vector
  z4 = zeros (1, j);
  ## Random input-wise attenuation coefficients
  b = rand (4, 1) .^ (1 / 100) / 0.8;
  ## Random output-wise attenuation coefficients
  c = rand (4, 1) .^ (1 / 100) / 3;
  ## Output vector initialization
  fdn_out = zeros (1, j);
  ## Feedback signals
  k = j : length(in);
  z1(k) = b(1)*in .+ A(1,:).*[z1(k-m(1)) z2(k-m(2)) z3(k-m(3)) z4(k-m(4))];
  z2(k) = b(2)*in .+ A(2,:).*[z1(k-m(1)) z2(k-m(2)) z3(k-m(3)) z4(k-m(4))];
  z3(k) = b(3)*in .+ A(3,:).*[z1(k-m(1)) z2(k-m(2)) z3(k-m(3)) z4(k-m(4))];
  z4(k) = b(4)*in .+ A(4,:).*[z1(k-m(1)) z2(k-m(2)) z3(k-m(3)) z4(k-m(4))];
  ## Output signal
  fdn_out(k) = d*in + c.*[z1(k-m(1)) z2(k-m(2)) z3(k-m(3)) z4(k-m(4))];
endfunction

