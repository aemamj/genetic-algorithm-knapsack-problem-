function [y1,y2]=UniformPointCrossOver(x1,x2)

    alpha=randi([0 1],size(x1));
    
    y1=alpha.*x1+(1-alpha).*x2;            % فرزند اول
    
    y2=alpha.*x2+(1-alpha).*x1;            % فرزند دوم

end