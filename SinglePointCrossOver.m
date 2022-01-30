function [y1, y2]=SinglePointCrossOver(x1,x2)
    
    nVar=numel(x1); % تعداد المان ها
    
    c=randi([1 nVar-1]); % محل قطع
    
    y1=[x1(1:c) x2(c+1:end)];   % فرزند اول
    
    y2=[x2(1:c) x1(c+1:end)];   % فرزند دوم
    
end
