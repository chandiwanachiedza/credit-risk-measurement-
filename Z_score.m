%% =========================
% Lufthansa Z-Score Calculation
% ==========================

%% ----------- 2017 DATA -----------

WC_2017 = -1609;          % Working Capital
RE_2017 = 6064;          % Retained Earnings
EBIT_2017 = 2263;        % EBIT
TA_2017 = 35778;         % Total Assets
MVE_2017 = 8895.7;        % Market Value of Equity
TD_2017 = 6814;         % Total Debt
Sales_2017 = 23317;      % Revenue

% Ratios
X1_2017 = WC_2017 / TA_2017;
X2_2017 = RE_2017 / TA_2017;
X3_2017 = EBIT_2017 / TA_2017;
X4_2017 = MVE_2017 / TD_2017;
X5_2017 = Sales_2017 / TA_2017;

% Z-score
Z_2017 = 1.2*X1_2017 + 1.4*X2_2017 + 3.3*X3_2017 + 0.6*X4_2017 + 0.999*X5_2017;

%% ----------- 2019 DATA -----------
WC_2019 = -4701;
RE_2019 = 6830;
EBIT_2019 = 1609;
TA_2019 = 42659;
MVE_2019 = 8335.9;
TD_2019 = 10030;
Sales_2019 = 28136;

% Ratios
X1_2019 = WC_2019 / TA_2019;
X2_2019 = RE_2019 / TA_2019;
X3_2019 = EBIT_2019 / TA_2019;
X4_2019 = MVE_2019 / TD_2019;
X5_2019 = Sales_2019 / TA_2019;

% Z-score
Z_2019 = 1.2*X1_2019 + 1.4*X2_2019 + 3.3*X3_2019 + 0.6*X4_2019 + 0.999*X5_2019;

%% ----------- OUTPUT -----------
fprintf('Z-score 2017: %.2f\n', Z_2017);
fprintf('Z-score 2019: %.2f\n', Z_2019);

%% ----------- INTERPRETATION -----------
if Z_2019 < 1.81
    disp('2019: Distress Zone');
elseif Z_2019 > 2.67
    disp('2019: Safe Zone');
else
    disp('2019: Grey Zone');
end
