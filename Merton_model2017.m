% Load data from Excel file
filename = '2017 Historical prices.xlsx';
data = readtable(filename, 'Sheet', 'Worksheet', 'VariableNamingRule', 'preserve');

St_price = data{8:end, 2};
St_price = St_price(~isnan(St_price));
St_price = flip(St_price);
shares_outstanding = 660.3e6;  % 660.3 million shares

% Convert to total market equity value
St = St_price * shares_outstanding;

% Parameters
T = 1;                  % Time to maturity (1 year)
r = 0.283;               % Risk-free rate
ST_debt = 672.0e6;      % Short-term debt
LT_debt = 6142.0e6;     % Long-term debt
D = ST_debt + 0.5*LT_debt;  % Debt threshold
epsilon = 0.0001;       % Convergence tolerance
max_iter = 100;         % Maximum iterations

% initial asset volatility (σV)
returns_equity = diff(log(St));
sigma_V_old = std(returns_equity);

% Iteration loop
for iter = 1:max_iter
    Vt = zeros(length(St), 1);
    
    for t = 1:length(St)
        lower_bound = St(t);
        upper_bound = St(t) + D * exp(-r*T);
        
        try
            Vt(t) = fzero(@(V) bs_call(V, D, r, T, sigma_V_old) - St(t), [lower_bound, upper_bound]);
        catch
            Vt(t) = St(t) + D * exp(-r*T);
        end
    end
    
    log_returns_asset = diff(log(Vt));
    mu_daily = mean(log_returns_asset);
    sigma_V_new = std(log_returns_asset);
    
    if abs(sigma_V_new - sigma_V_old) <= epsilon
        fprintf('Converged after %d iterations\n', iter);
        fprintf('Final daily asset volatility: %.6f\n', sigma_V_new);
        break;
    end
    
    sigma_V_old = sigma_V_new;
    fprintf('Iteration %d: sigma_V = %.6f\n', iter, sigma_V_new);
end

% ============================================
% ANNUALIZE FOR PD CALCULATION 
% ============================================
sigma_V_daily = sigma_V_new;
mu_daily = mu_daily;
sigma_V_annual = sigma_V_daily * sqrt(252);  
mu_annual = mu_daily * 252;                  

V0 = Vt(1);

% Distance to Default (using annualized values)
DD = (log(V0/D) + (mu_annual - 0.5 * sigma_V_annual^2)) / sigma_V_annual;

% Probability of Default
PD = normcdf(-DD);

% Display results
fprintf('\n========================================\n');
fprintf('MERTON MODEL CREDIT RISK MEASURES\n');
fprintf('========================================\n');
fprintf('Initial Asset Value (V0): €%.2f million\n', V0/1e6);
fprintf('Debt Threshold (D): €%.2f million\n', D/1e6);
fprintf('Daily Asset Volatility: %.4f%%\n', sigma_V_daily*100);
fprintf('Annual Asset Volatility: %.2f%%\n', sigma_V_annual*100);
fprintf('Daily Mean Return: %.4f%%\n', mu_daily*100);
fprintf('Annual Mean Return: %.2f%%\n', mu_annual*100);
fprintf('\nDistance to Default (DD): %.4f\n', DD);
fprintf('Probability of Default (PD): %.4f%%\n', PD*100);
fprintf('========================================\n');
