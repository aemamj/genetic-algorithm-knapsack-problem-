clc;
clear;
close all;
%% PD تعریف مسئله

global NFE;
    NFE=0;
global TYPECROSOVER;
    TYPECROSOVER='';
    
knapstack=createknapstack();    % ساخت مدل كوله پشتي
    
CostFounction=@(x) Knapsackcost(x,knapstack); %هزینه

nVar  = knapstack.n; % تعداد متغییر های تصمیم

VarSize=[1 nVar]; %  سایز ماتریکسی که شکل کرومزن را نشان میدهد


 %% پارامت های الگوریتم ژنتیک

MaxIt=200;  % بیشترین تعداد  نسل ها

nPop=50;    % تعداد اعضای جمعیت اصلی

pc=0.8;     %درصد کراس اور

nc=2*round(pc*nPop/2);      % جمعیت فرزندان

pm=0.3;     %درصد موتیشن

nm=round(pm*nPop) ;      % جمعیت جهش یافتگان

mu=0.012;  % نرخ میوتیشن 

answer=questdlg('انتخاب متود : ' , 'الگوریتم ژنتیک' , 'Roulet' , 'Tornoment' , 'Random' ,'Roulet');

UseRolet=strcmp(answer,'Roulet');
UseTornoment=strcmp(answer,'Tornoment');
UseRandom=strcmp(answer,'Random');

if UseRolet
    beta= 8;                % پارامتر فشار انتخاب
end

if UseTornoment
    TournamentSize = 3;  % ساز تورنمنت
end


pause(0.1);





%% اماده سازی

empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.sol=[];
pop=repmat(empty_individual,nPop,1); % اعضای جمعیت

for i=1:nPop
   
    % ایجاد کرومزون
    
    pop(i).Position = createrandomsolution(knapstack);
    
    % ارزیابی
    
    [pop(i).Cost pop(i).sol]=CostFounction(pop(i).Position);
    
end

% مرتب سازی جمعیت

Costs=[pop.Cost];
[Costs , SortOrder]=sort(Costs);
pop=pop(SortOrder)  ;

 
% ذخیره بهترین انتخاب

BestSol = pop(1);

% آرایه ای برای نگهداری بهترین اتخاب ها

BestCost = zeros(MaxIt ,1 ); 

% ذخیره بدترین اتخاب
WorstCost=pop(end).Cost;

% آرایه از تعداد دفعات هر نسل

nfe=zeros(MaxIt,1);


%% حلقه اصلی

for it=1:MaxIt
    
    % احتمال های انتخاب
    P=exp(-beta*Costs/WorstCost);
    P=P/sum(P);
    
    
    
    
    %کراس اور
    popc =  repmat(empty_individual,nc/2,2);  %   جمعیت کراس اور
    for k=1:nc/2
        
        
        
            %   انتخاب اولین والد
        

        if UseRolet
            i1=RouletteWheelSelection(P);
        end
        if UseTornoment
            i1=TournamentSelection(pop,TournamentSize);
        end
        if UseRandom
            i1=randi([1 nPop]);
        end
        
        p1=pop(i1);
        
            %   انتخاب دومین والد

        if UseRolet
            i2=RouletteWheelSelection(P);
        end
        if UseTornoment
            i2=TournamentSelection(pop,TournamentSize);
        end
        if UseRandom
            i2=randi([1 nPop]);
        end
        
        
        p2=pop(i2);
        
        
        % اعمال کراس اور
        
       % [popc(k,1).Position  , popc(k,2).Position] = SinglePointCrossOver(p1.Position , p2.Position);
        
                
       % [popc(k,1).Position  , popc(k,2).Position] = DoublePointCrossOver(p1.Position , p2.Position);
        
       % [popc(k,1).Position  , popc(k,2).Position] = UniformPointCrossOver(p1.Position , p2.Position);
       
       [popc(k,1).Position  , popc(k,2).Position] = Crossover(p1.Position , p2.Position);
       
       
        % ارزیابی فرزندان
        
        [popc(k,1).Cost popc(k,1).sol]=CostFounction(popc(k,1).Position);
        [popc(k,2).Cost popc(k,2).sol]=CostFounction(popc(k,2).Position);
        
        
    
    end
    
    popc = popc(:) ;  % reshape(popc,[],1);
    
    %میوتیشن
    
    popm = repmat(empty_individual,nm,1);
    
    for k=1:nm
       
        %انتخاب والد
        i=randi([1 nPop]);
        p=pop(i);
        
        %اعمال میوتیشن
        popm(k).Position =  Mutate(p.Position,mu);
        
        %ارزیابی میوتیت
        [popm(k).Cost popm(k).sol]=CostFounction(popm(k).Position);
    end
    

   W=[pop
       popc
       popm];



    % مرتب سازی جمعیت

    Costs=[W.Cost];
    [Costs , SortOrder]=sort(Costs , 'descend');
    W=W(SortOrder)  ;
    
    % بروز رسانی بدترین انتخاب
    WorstCost=max(WorstCost,pop(end).Cost);

    %حذف کردن اضافه ها
    
    pop=W(1:nPop); %      pop(nPop+1:end=[];
    Costs=Costs(1:nPop);
    
    % ذخیره خروجی بهترین انتخاب
    BestSol=pop(1);
    
    % ذخیره بهترین
    
    BestCost(it)=BestSol.Cost;
    
    % ذخیره تعداد دفعات ارزیابی
    
    nfe(it)=NFE;
    
    
    % نمایش اطلاعات  نسل
    
    disp(['نسل ' num2str(it) ' بهترین نتیجه ' num2str(BestCost(it)) ' تعداد ارزیابی ' num2str(nfe(it)) ' نوع کراس اور ' TYPECROSOVER]);
    
end

%% خروجی

figure;
plot(nfe,BestCost,'LineWidth' ,2 );
xlabel(' تعداد نسل');  %   xlabel('نسل');
ylabel('نتیجه');






