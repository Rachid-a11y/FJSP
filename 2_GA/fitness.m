function [Z,machine_weight,pvals] = fitness(chroms,num_machine,e,num_job,num_op)
sizepop=size(chroms,1);
pvals=cell(1,sizepop);
Z1=zeros(1,sizepop);
Z2=Z1;
total_op_num=sum(num_op);  % �ܹ�����
for k=1:sizepop
    chrom=chroms(k,:);
    machine=zeros(1,num_machine);  % ��¼�������仯ʱ��
    job=zeros(1,num_job);  % ��¼�������仯ʱ��
    machine_time=zeros(1,num_machine);  % �����������ʵ�ʼӹ�ʱ��
    pval=zeros(2,total_op_num);  % ��¼������ʼ�ͽ���ʱ��
    for i=1:total_op_num
        % ����ʱ����ڹ���ʱ��
        if machine(chrom(total_op_num+i))>=job(chrom(i))
            pval(1,i)=machine(chrom(total_op_num+i));  % ��¼������ʼʱ��
            machine(chrom(total_op_num+i))=machine(chrom(total_op_num+i))+chrom(total_op_num*2+i);
            job(chrom(i))=machine(chrom(total_op_num+i));
            pval(2,i)=machine(chrom(total_op_num+i));  % ��¼��������ʱ��
            % ����ʱ��С�ڹ���ʱ��
        else
            pval(1,i)=job(chrom(i));
            job(chrom(i))=job(chrom(i))+chrom(total_op_num*2+i);
            machine(chrom(total_op_num+i))=job(chrom(i));
            pval(2,i)=job(chrom(i));
        end
        machine_time(chrom(total_op_num+i))=machine_time(chrom(total_op_num+i))+chrom(total_op_num*2+i);
    end
    Z1(k)=max(machine);  % ������ʱ��ֵ����Ӧmakespan
    % machine_weight=machine_time/sum(machine_time);  % ����������ĸ���
    machine_weight=machine_time;
    Z2(k)=max(machine_weight)-min(machine_weight);
    pvals{k}=pval;
end
% min_makespan=min(Z1);%����Ⱦɫ���makespan����ֵ
% max_makespan=max(Z1);
% min_weight=min(Z2);%��������ֵ
% max_weight=max(Z2);
% Z=e*((Z1-min_makespan)./(max_makespan-min_makespan))+(1-e)*((Z2-min_weight)./(max_weight-min_weight));%������Ӧ��
Z=e*Z1+(1-e)*Z2;

