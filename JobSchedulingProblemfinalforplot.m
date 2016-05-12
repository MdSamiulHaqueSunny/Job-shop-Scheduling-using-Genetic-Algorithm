 clc
clear all
tableA=zeros(50,50);
%information of problem
%total job
job=8;

%operation -----------> operation(job_no)=no of ops.
operation(1)=2;
operation(2)=3;
operation(3)=3;
operation(4)=3;
operation(5)=2;
operation(6)=2;
operation(7)=2;
operation(8)=2;


%machine -------------> machine{job,ops}=[val1 val2];
machine{1,1}=[1 2 3];
machine{1,2}=[1 2 3];
machine{2,1}=[1 2 3];
machine{2,2}=[1 2];
machine{2,3}=[1 2];
machine{3,1}=[1 2];
machine{3,2}=[1 2 3];
machine{3,3}=[1 2 3];
machine{4,1}=[1 2];
machine{4,2}=[1 2];
machine{4,3}=[1 2 3];
machine{5,1}=[1 4 3];
machine{5,2}=[6 4 5 2];
machine{6,1}=[3 5];
machine{6,2}=[4 6 1 2];
machine{7,1}=[2 3];
machine{7,2}=[1 4 5 6];
machine{8,1}=[1 3];
machine{8,2}=[4 5 3 6];



%Genetic Algorithm Parameter
pop=50; %population;
Xover=0.8; %crossover rate;
M=0.3; %Mutation rate;
Selection_size=2; %Tournament selection
max_iteration=50;

solution=zeros(pop,sum(operation)); %the solution
fitness=zeros(1,pop);
selected_solution=zeros(pop,sum(operation)); %new selected pop;

%%%%%%%%%%%%%%%%%% initialization %%%%%%%%%%%%%%%%%%%%%%%%
for i=1:pop
    ind=1;
    for j=1:job
        for ops=1:operation(j)
            solution(i,ind)=j*100; %adding the job

            solution(i,ind)=solution(i,ind)+ ops*10; %adding the operation

            mach=machine{j,ops}; %get the machine details

            len_mach=length(mach); %get the total machine index;

            mach_ind=randi(len_mach); %get the machine index;

            solution(i,ind)=solution(i,ind) + mach(mach_ind);
            
            ind=ind+1;
        end
    end
end

for itrn=1:max_iteration %run the max-iteration
    
    %%%%%%%%%%%%% Fitness Calculation %%%%%%%%%%%
    cost=dlmread('time_cost.txt'); %read the cost

    for i=1:pop
        sum_=0;
        %disp(solution(i,:));
        for j=1:sum(operation)
           [jo,o,m] = break_num(solution(i,j));
           
           %disp(solution(i,j));
           
           for k=1:size(cost,1)
               if(cost(k,1)==jo & cost(k,2)==o & cost(k,3)==m)
                   sum_=sum_+cost(k,4);
                   %disp(cost(k,4));
               else
                   continue;
               end
           end
           
        end
       
       fitness(i)= sum_;
       fprintf('%d\t',fitness(i))
       %mat(:,i)=fitness
      
       %tableA(:,i)=[fitness];
       %fprintf('%d \n ',tableA)
        %disp(sum_);
        %x=input('....');
    end
       
    
    for i=1:pop
    %fprintf('soln %d -',i);
    for j=1:sum(operation)
        %fprintf('%d ',solution(i,j));
    end
    %fprintf('time= %d\n',fitness(i));
    end

    %fprintf('\n');

    %%%%%%%%%% Tournament Selection %%%%%%%%%%%
    selection_pool=randi(pop,pop,Selection_size);

    for i=1:pop
        minimum=inf;
        min_ind=0;
        for j=1:Selection_size
            if(fitness(selection_pool(i,j))<minimum)
                minimum=fitness(selection_pool(i,j));
                min_ind=selection_pool(i,j);
            end
        end
        selected_solution(i,:)=solution(min_ind,:);
    end

    solution=selected_solution; %copy selected solution

    %%%%%%%%%%%%%%% crossover %%%%%%%%%%%%%%%%%
    j=1;
    xover_pool=[];
    for i=1:pop
        r=rand();
        if(r<Xover)
            xover_pool(j)=i;
            j=j+1;
        end
    end
    j=j-1; %dec the additional;

    if(mod(j,2)==1) %keep the even no of solution;
        j=j-1;
    end
    %crossover operation
    for i=1:2:j
        cross_point=randi([2 sum(operation)-1]); %crossover point
        temp=solution(xover_pool(i),cross_point:end);
        solution(xover_pool(i),cross_point:end)=solution(xover_pool(i+1),cross_point:end);
        solution(xover_pool(i+1),cross_point:end)=temp;
    end

    %%%%%%%%%%%%%%%%% Mutation %%%%%%%%%%%%%%%%%%%
    j=1;
    mut_pool=[];
    for i=1:pop
        r=rand();
        if(r<M)
            mut_pool(j)=i;
            j=j+1;
        end
    end
    j=j-1; %dec the additional;

    if(mod(j,2)==1) %keep the even no of solution;
        j=j-1;
    end
    %Mutation operation
    for i=1:2:j
        mut_point=randi(sum(operation)); %mutation point
        temp=solution(mut_pool(i),mut_point);
        solution(mut_pool(i),mut_point)=solution(mut_pool(i+1),mut_point);
        solution(mut_pool(i+1),mut_point)=temp;
    end

   fprintf('\n');
        
end

fprintf('\n');


%get the best
[min_fitness,ind]=min(fitness);
best_solution=solution(ind,:);

fprintf('\nThe best seqeunce is - \n');
disp(best_solution);
fprintf('Minimum time %d.\n',min_fitness);



