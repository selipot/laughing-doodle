% this script require jLab https://github.com/jonathanlilly/jLab

% sampling interval
dt = 1;
% number of points in time series
N = 1000;
% fourier frequencies
% ff = fourier(dt,N); % calculated below as f with the multitaper spectral
% estimate

% parameters of the Matern model
% I want var(zr) = 0.1^2 so have sigma = sqrt(2)*0.1 
sigma = sqrt(2)*0.1;
alpha = 2;
lambda = 1;
z = maternoise(dt,N,sigma,alpha,lambda);
% take the real part of the Matern complex process
zr = real(z);

% multitaper spectral estimate
NW = 3;K = 2*NW-1;
psi = sleptap(length(zr),NW,K);
[f,szz] = mspec(dt,zr,psi);

% compute confidence intervals at the (1-a)*100 % level
a = 0.05;
ci = [2*K/chi2inv(1-a/2,2*K) 2*K/chi2inv(a/2,2*K)];

% theroretical matern spectrum
[~,sm] = maternspec(dt,N,sigma,alpha,lambda);

%% time series plot
figure,
plot(1:N,zr);
xlabel('[time unit]')
ylabel('[variable unit]')

%% linear-linear plot
figure
[h1,h2] = shadyerror(f(2:end)/2/pi,szz(2:end),[szz(2:end)-ci(1)*szz(2:end)...
    ci(2)*szz(2:end)-szz(2:end)]);
hold on,h3 = plot(f/2/pi,sm);box on
set(h3,'linewidth',1.5);
xlabel('Frequency $f$ (1/[time unit])')
ylabel('$S$ [variable unit]$^2$ $\times$ (1/[time unit])$^{-1}$')
legend([h1 h2 h3],{'$\widehat{S}$: multitaper estimate','95\% CI','Matern model'},'location','best')
hl = line([0 0.3 0 0],[0 0 0.08 0]);
set(hl,'linewidth',2,'color','k','linestyle','--');
legend([h1 h2 h3],{'$\widehat{S}$: multitaper estimate','95\% Confidence Interval','Matern model'},'location','best')

%% log log plot

delete(hl);
ylog,xlog,xlim([f(2)/2/pi 0.51]);
ylim(10.^[-4 log10(0.5)])
legend([h1 h2 h3],{'$\widehat{S}$: multitaper estimate','95\% Confidence Interval','Matern model'},'location','best')

%% variance-preserving plot (don't do it)

figure,%plot(f/2/pi,szz);
[h1,h2] = shadyerror((f(2:end)/2/pi),szz(2:end).*f(2:end)/2/pi,...
    [(1-ci(1)).*szz(2:end).*f(2:end)/2/pi ...
    (ci(2)-1).*szz(2:end).*f(2:end)/2/pi]);
hold on,h3 = plot((f/2/pi),sm.*(f/2/pi));
set(h3,'linewidth',1.5);
xlabel('Frequency $f$ $\log_{10}$ (1/[time unit])')
xlog,xlim([f(2)/2/pi 0.51]), box on
ylabel('$S \times f$ [variable unit]$^2$')
legend([h1 h3],{'$\widehat{S}$: multitaper estimate','Matern model'},'location','best')

