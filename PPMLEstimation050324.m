function [theta_hat_all, beta_hat_all, sigma_hat_all, avg_Y, lambda_true] = PPMLEstimation050324(N, K, L, P, theta_true, beta_true, sigma_true)
    D = randn(N, K); % Coefficients for normal variable
    X = ((chi2rnd(3,N, L)-3)/sqrt(6)); % Coefficients for chi^2 variable
    Dummy = randi([0 1], N, P); % Coefficients for dummy variable
    R = normrnd(0,1)
    Constant = -1.75 %generates approximately 70-74% of zeroes
    lambda_true = exp(D * theta_true + X * beta_true + Dummy * sigma_true+R+Constant); % True lambda values
       
    Y = zeros(N, 1); % Initialize Y with zeros
    for j = 1:N
            Y(j) = poissrnd(lambda_true(j)); % Generate from Poisson
    end
   
    avg_Y = mean(Y);
    
  
    
%create fixed effects estimate fixed effects with some package

    % Estimate model using PPML
    PPML_hat = glmfit([D, X, Dummy], Y, 'poisson');
    
    % Extract estimated parameters
    theta_hat = PPML_hat(2:K+1); % Estimated parameters of interest
    beta_hat = PPML_hat(K+2:K+L+1); % Estimated nuisance parameters
    sigma_hat = PPML_hat(end); % Estimated coefficient for the dummy variable

      % Generate dependent variable using a mixture distribution
       %adding a random normal to lambda with some variance and play with
       %the value of variance (var=0 is poisson, positive var poisson with
       %overdispersion 
       %how does the bias change when you increase overdispersion
    
    % Store results
    theta_hat_all = theta_hat;
    beta_hat_all = beta_hat;
    sigma_hat_all = sigma_hat;
end 
