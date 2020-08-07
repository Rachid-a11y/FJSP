function chroms=generate_neigh(chrom,neigh_size,total_op_num,num_job,num_op)
chroms=[];
flag=0;  % �����ж��Ƿ�������ѭ��
tau=randi([2,4]);  % �������tauֵ
for i=1:neigh_size
    % ѡ��tau����ͬλ�á�����ͬ�����Ļ���
    job=randperm(num_job,tau);  % ѡ��Ĺ���
    job_ind=zeros(1,tau);  % ������λ��
    for j=1:tau
        temp=find(chrom(1:total_op_num)==job(j));
        jj=randperm(num_op(job(tau)),1);
        job_ind(j)=temp(jj);
    end
    % tau��λ�õ�ȫ���У�������
    ind=perms(1:tau);
    for j=1:length(ind)
        chrom1=chrom;
        chrom1(job_ind)=job(ind(j,:));
        chrom1(total_op_num+job_ind)=chrom(total_op_num+job_ind(ind(j,:)));
        chrom1(total_op_num*2+job_ind)=chrom(total_op_num*2+job_ind(ind(j,:)));
        chroms=[chroms;chrom1];
        % ֻ��Ҫ����neigh_size�������
        if size(chroms,1)>=neigh_size
            flag=1;
            break;
        end
    end
    % �ﵽ���������������������ѭ��
    if flag==1
        break;
    end
end