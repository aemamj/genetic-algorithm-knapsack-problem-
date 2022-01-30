function [y1,y2]=Crossover(x1,x2)   

    global TYPECROSOVER;
    PsinglePoint=0.1;
    PDoublePoint=0.2;
    PUniform=1-PsinglePoint-PDoublePoint;
    
    METHOD=RouletteWheelSelection([PsinglePoint PDoublePoint PUniform]);
        
    switch METHOD
        
        case 1
                [y1, y2]=SinglePointCrossOver(x1,x2);
                TYPECROSOVER = 'SinglePoint';
        case 2
                [y1, y2]=DoublePointCrossOver(x1,x2);
                TYPECROSOVER = 'DoublePoint';
            
        case 3
                [y1, y2]=UniformPointCrossOver(x1,x2);
                TYPECROSOVER = 'UniformPoint';
            
    end
    


end