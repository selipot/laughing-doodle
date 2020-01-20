function [h1,h2] = shadyerror(x,y,ye,varargin)
% shadyerror draws a curve y as a function of x with plus or minus error bar
% ye with optional color
% ye can be a 2-column vector for lower and upper error bar values

if ~isempty(varargin)
    cc = varargin{1};
else
    cc = lines(1);
end

x = x(:);
y = y(:);

x(isnan(y)) = NaN;

% ye better be a column vector
if size(ye,1) ~= size(x,1)
    error('wrong size of input for error');
end

n = size(ye,2);

% divide up time series in segments when separated by NaN
x = cellprune(col2cell([x ; NaN]),2);
y = cellprune(col2cell([y ; NaN]),2);
ye = cellprune(col2cell([ye ; NaN*ones(1,size(ye,2))]),2);

if n == 1;
    
    hold on
    for k = 1:size(x,1)
        h2(k) = patch([x{k} ; flipud(x{k})],[y{k}-ye{k} ; flipud(y{k}+ye{k})],cc+(1-cc)*0.5,'edgecolor','none');
        h1(k) = plot(x{k},y{k},'color',cc);
    end
    
elseif n == 2;
    
    hold on
    for k = 1:size(x,1)
        h2 = patch([x{k} ; flipud(x{k})],[y{k}-ye{k}(:,1) ; flipud(y{k}+ye{k}(:,2))],cc+(1-cc)*0.5,'edgecolor','none');
        h1 = plot(x{k},y{k},'color',cc);
    end
else
    
    error('wrong dimensions for ye');

end
