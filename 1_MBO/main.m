clc;clear
%% ��������
% �ӹ����ݰ����ӹ�ʱ�䣬�ӹ���������������������Ȩ�أ�����������������Ӧ�Ĺ�����
load data operation_time operation_machine num_machine machine_weight num_job num_op

%% ��������
MAXGEN=200;             % ����������
sizepop=201;            % ��Ⱥ��ģ
e=0.5;                  % Ŀ��ֵȨ��
N_size=30;              % ���������
S_size=15;              % ���������
G=5;                    % Ѳ�ش���
G1=20;                  % ��������1����
G2=10;                  % ��������2����
trace=zeros(2,MAXGEN);
chrom_best=[];

%% ===========================��Ⱥ��ʼ��============================
total_op_num=sum(num_op);
chroms=initialization(num_op,num_job,total_op_num,sizepop,operation_machine,operation_time);
[Z,~,~,~,~]=fitness(chroms,num_machine,e,num_job,num_op);
% ����õĽ⻮��Ϊ�����
[Z_leader,ind]=min(Z);
leader=chroms(ind,:); 
% ��chroms���Ƴ������Ȼ�󻮷�����������������Ⱥ
chroms(ind,:)=[];
Z(ind)=[];
sp=(sizepop-1)/2;
lefts=chroms(1:sp,:);
Z_left=Z(1:sp);
rights=chroms(sp+1:end,:);
Z_right=Z(sp+1:end);

%% ============================��������=============================
for gen=1:MAXGEN
    fprintf('��ǰ����������'),disp(gen)
    %% Ѳ�ؽ׶�
    for i=1:G
        %% ��������
        [leader,Z_leader,share,Z_share]=bird_evolution(leader,Z_leader,[],[],...
            N_size,S_size,total_op_num,num_machine,e,num_job,num_op);
        %% ���������
        % ��ʼ�����Ҷ��еĹ���⼯
        share_left=share;
        Z_share_left=Z_share;
        share_right=share;
        Z_share_right=Z_share;
        for j=1:sp
            % �����
            [lefts(j,:),Z_left(j),share_left,Z_share_left]=bird_evolution(lefts(j,:),Z_left(j),share_left,Z_share_left,...
                N_size-S_size,S_size,total_op_num,num_machine,e,num_job,num_op);
            % �Ҷ���
            [rights(j,:),Z_right(j),share_right,Z_share_right]=bird_evolution(rights(j,:),Z_right(j),share_right,Z_share_right,...
                N_size-S_size,S_size,total_op_num,num_machine,e,num_job,num_op);
        end
        %% ��������2���Ӽ佻��
        % �������G2��λ����ͬ�ĸ���
        ind=randperm(sp,G2);
        [rights(ind,:),Z_right(ind),lefts(ind,:),Z_left(ind)]= crossover(lefts(ind,:),rights(ind,:),...
            Z_left(ind),Z_right(ind),total_op_num,num_machine,e,num_job,num_op);
    end
    %% ��������1�����ھ���
    ind=randperm(sp,G1);
    % �����
    [~,ind1]=sort(Z_left(ind));
    lefts(ind,:)=lefts(ind(ind1),:);
    Z_left(ind)=Z_left(ind(ind1));
    % �Ҷ���
    [~,ind2]=sort(Z_right(ind));
    rights(ind,:)=rights(ind(ind2),:);
    Z_right(ind)=Z_right(ind(ind2));
    %% ������滻
    if rand<0.5
        % ѡ���������ֻ������
        [leader,Z_leader,lefts,Z_left]=update_leader(leader,Z_leader,lefts,Z_left);
    else
        % ѡ���Ҷ�����ֻ������
        [leader,Z_leader,rights,Z_right]=update_leader(leader,Z_leader,rights,Z_right);
    end
    %% ��¼�������
    % ��¼ÿ����������Ӧ����ƽ����Ӧ��
    Z=[Z_leader,Z_left,Z_right];
    [val,ind]=min(Z);
    trace(1,gen)=val;
    trace(2,gen)=mean(Z);
    % ����ȫ��������Ӧ��
    if gen==1 || MinVal>trace(1,gen)
        MinVal=trace(1,gen);
    end
end

%% ============================������=============================
%% ���������Ӧ��
fprintf('������Ӧ�ȣ�'),disp(MinVal)
%% ����������Ӧ����ƽ����Ӧ�ȵĵ�������ͼ
figure(1)
plot(trace(1,:));
hold on;
plot(trace(2,:),'-.');grid;
legend('��ı仯','��Ⱥ��ֵ�ı仯');
%% ����ȫ�����Ž�ĸ���ͼ
[Z,~,~,machine_time,Pvals]=fitness(leader,num_machine,e,num_job,num_op);
Pval1=Pvals{1,1};
figure(2);
for i=1:total_op_num
    mText=leader(total_op_num+i);
    b=leader(i);
    x1=Pval1(1,i);
    x2=Pval1(2,i); 
    y1=mText-0.2;
    y2=mText;
    hold on; 
    fill([x1,x2,x2,x1],[y1,y1,y2,y2],[1-1/b,1/b,b/num_job]);
    text((x1+x2)/2,mText-0.1,num2str(b));
end