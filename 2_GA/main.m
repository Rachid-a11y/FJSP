clc;clear
%% ��������
% �ӹ����ݰ����ӹ�ʱ�䣬�ӹ���������������������Ȩ�أ�����������������Ӧ�Ĺ�����
load data operation_time operation_machine num_machine machine_weight num_job num_op

%% ��������
MAXGEN = 200;               % ����������
Ps = 0.8;                   % ѡ����
Pc = 0.7;                   % ������
Pm = 0.3;                   % ������
sizepop = 200;              % ������Ŀ
e = 0.5;                    % Ŀ��ֵȨ��
trace = zeros(2,MAXGEN);

%% ===========================��Ⱥ��ʼ��============================
total_op_num=sum(num_op);
chroms=initialization(num_op,num_job,total_op_num,sizepop,operation_machine,operation_time);
[Z,~,~]=fitness(chroms,num_machine,e,num_job,num_op);

%% ============================��������=============================
for gen=1:MAXGEN
    fprintf('��ǰ����������'),disp(gen)
    % ���̶�ѡ��
    chroms_new=selection(chroms,Z,Ps);
    % �������
    chroms_new=crossover(chroms_new,Pc,total_op_num,num_job,num_op);
    % �������
    chroms_new=mutation(chroms_new,total_op_num,Pm,num_machine,e,num_job,num_op,operation_machine,operation_time);
    % ����ѡ�񽻲�����������Ӧ��
    [Z_new,~,~]=fitness(chroms_new,num_machine,e,num_job,num_op);
    % ������Ӧ����ԭ��Ⱥ���Ŵ����������Ⱥ��ѡ��sizepop�����Ÿ���
    [chroms,Z,chrom_best]=update_chroms(chroms,chroms_new,Z,Z_new,sizepop);
    % ��¼ÿ����������Ӧ����ƽ����Ӧ��
    trace(1, gen)=Z(1);       
    trace(2, gen)=mean(Z);  
    % ����ȫ��������Ӧ��
    if gen==1 || MinVal>trace(1,gen)
        MinVal=trace(1,gen);
    end
end

%% ============================������=============================
%% ���������Ӧ��
fprintf('������Ӧ�ȣ�'),disp(MinVal)
%% ����ı仯
figure(1)
plot(trace(1,:));
hold on;
plot(trace(2,:),'-.');grid;
legend('��ı仯','��Ⱥ��ֵ�ı仯');
%% ��ʾ���Ž�
[Z,machine_weight1,Pvals]=fitness(chrom_best,num_machine,e,num_job,num_op);
Pval1=Pvals{1,1};
figure(2);
for i=1:total_op_num
    mText=chrom_best(total_op_num+i);
    b=chrom_best(i);
    x1=Pval1(1,i);
    x2=Pval1(2,i); 
    y1=mText-0.2;
    y2=mText;
    hold on; 
    fill([x1,x2,x2,x1],[y1,y1,y2,y2],[1-1/b,1/b,b/num_job]);
    text((x1+x2)/2,mText-0.1,num2str(b));
end