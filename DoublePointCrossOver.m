function [y1,y2]=DoublePointCrossOver(x1,x2)

    nVar=numel(x1); % تعداد المان ها
    
    cc=randsample(nVar-1,2); % محل قطع
    
    c1=min(cc);         %      محل قطع اول
    c2=max(cc);          %      محل قطع دوم
    
    y1=[x1(1:c1) x2(c1+1:c2) x1(c2+1:end)];   % فرزند اول
    
    y2=[x2(1:c1) x1(c1+1:c2) x1(c2+1:end)];   % فرزند دوم


end