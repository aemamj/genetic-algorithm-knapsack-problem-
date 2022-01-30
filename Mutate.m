function y=Mutate(x,mu)

    nVar = numel(x);      % تعداد متغییر ها
    
    nmu=ceil(mu*nVar);   % اندازه میو گرد شده به سمت بالا
    
    %j=randi([1 nVar]);   % انتخاب یک عضو
    
    j=randsample(nVar,nmu);
    
    y=x;
    
    y(j)=1-x(j);
    
end
