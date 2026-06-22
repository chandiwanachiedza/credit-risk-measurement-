%% =========================
% Lufthansa O-Score 
% =========================

clear; clc;

%% ----------- 2017 DATA -----------
% Replace with actual values

TA_2017 = 38000;
TL_2017 = 26000;
WC_2017 = 3000;
CL_2017 = 15000;
CA_2017 = 10500;
NI_2017 = 2200;
NI_2016 = 1800;
FFO_2017 = 3000;

%% ----------- 2019 DATA -----------

TA_2019 = 40000;
TL_2019 = 30000;
WC_2019 = 2000;
CL_2019 = 18000;
CA_2019 = 11000;
NI_2019 = 1200;
NI_2018 = 2200;
FFO_2019 = 2500;

GNP = 1; % Normalized Gross National Product 

%% ----------- FUNCTION TO COMPUTE O-SCORE -----------
compute_O = @(TA,TL,WC,CL,CA,NI,NI_prev,FFO) ...
    (-1.32 ...
    - 0.407*log(TA/GNP) ...
    + 6.03*(TL/TA) ...
    - 1.43*(WC/TA) ...
    + 0.076*(CL/CA) ...
    - 1.72*(TL>TA) ...
    - 2.37*(NI/TA) ...
    - 1.83*(FFO/TL) ...
    + 0.285*(NI<0) ...
    - 0.521*((NI-NI_prev)/(abs(NI)+abs(NI_prev))) );

%% ----------- CALCULATE O-SCORES -----------

O_2017 = compute_O(TA_2017,TL_2017,WC_2017,CL_2017,CA_2017,NI_2017,NI_2016,FFO_2017);
O_2019 = compute_O(TA_2019,TL_2019,WC_2019,CL_2019,CA_2019,NI_2019,NI_2018,FFO_2019);

%% ----------- PROBABILITY OF DEFAULT -----------

PD_2017 = 1 / (1 + exp(-O_2017));
PD_2019 = 1 / (1 + exp(-O_2019));

fprintf('2017 O-score: %.2f | PD: %.2f\n', O_2017, PD_2017);
fprintf('2019 O-score: %.2f | PD: %.2f\n', O_2019, PD_2019);

