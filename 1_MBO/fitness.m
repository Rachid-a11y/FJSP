function [Z,makespan,machine_load,machine_weight,pvals] = fitness(chroms,num_machine,e,num_job,num_op)
sizepop=size(chroms,1);
pvals=cell(1,sizepop);
makespan=zeros(1,sizepop);
machine_load=makespan;
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
    makespan(k)=max(machine);
    machine_weight=machine_time;
    machine_load(k)=max(machine_weight)-min(machine_weight);
    pvals{k}=pval;
end
Z=e*makespan+(1-e)*machine_load;