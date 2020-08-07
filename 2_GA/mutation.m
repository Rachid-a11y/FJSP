function chroms = mutation(chroms,total_op_num,Pm,num_machine,e,num_job,num_op,operation_machine,operation_time)
%% ��Թ����룬��Ʊ��������
for i=1:size(chroms,1)
    if Pm>rand
        chrom=chroms(i,:);
        chrom_best=[];
        Z_best=[];
        tau_min=2;
        tau_max=4;
        for tau=tau_min:tau_max
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
            % ���۵�ǰ���������Ÿ���
            Z=zeros(1,length(ind));
            chrom_neigh=[];  % �����
            for k=1:length(ind)
                chrom1=chrom;
                chrom1(job_ind)=job(ind(k,:));
                chrom1(total_op_num+job_ind)=chrom(total_op_num+job_ind(ind(k,:)));
                chrom1(total_op_num*2+job_ind)=chrom(total_op_num*2+job_ind(ind(k,:)));
                chrom_neigh=[chrom_neigh;chrom1];
                [Z(k),~,~] = fitness(chrom1,num_machine,e,num_job,num_op);
            end
            % ���µ�ǰ��
            [val,ii]=min(Z);
            Z_best=[Z_best,val];
            chrom_best=[chrom_best;chrom_neigh(ii,:)];
        end
        [~,ii]=min(Z_best);
        chroms(i,:)=chrom_best(ii,:);
    end
end
%% ��Ի����룬��Ƶ������,���滻��ѡ����
for i=1:size(chroms,1)
    if Pm>rand
        chrom=chroms(i,:);
        ind=randperm(total_op_num,1);  % ���ѡ���λ��
        job=chrom(ind);  % ��ѡ����
        job_ind=find(chrom(1:total_op_num)==job);
        op=find(job_ind==ind);  % ��ѡλ�õĹ���
        machines=operation_machine{job}{op};  % ��Ӧ�ļӹ�������
        times=operation_time{job}{op}; %  ��Ӧ�ļӹ�ʱ�伯
        if length(machines)>1
            ii=randperm(length(machines)-1,1);
            ind1=find(machines==chrom(total_op_num+ind));
            machines(ind1)=[];
            times(ind1)=[];
            chrom(total_op_num+ind)=machines(ii);
            chrom(total_op_num*2+ind)=times(ii);
        end
        chroms(i,:)=chrom;
    end
end