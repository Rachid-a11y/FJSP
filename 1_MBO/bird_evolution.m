function [chrom,Z_chrom,share,Z_share]=bird_evolution(chrom,Z_chrom,share,Z_share,neigh_size,share_size,total_op_num,num_machine,e,num_job,num_op)
% ��������Ⲣ��������Ӧ��
neigh=generate_neigh(chrom,neigh_size,total_op_num,num_job,num_op);
[Z_neigh,~,~,~,~] = fitness(neigh,num_machine,e,num_job,num_op);
% ����������⡢������뵱ǰ��ϲ�
neigh=[neigh;share;chrom];
Z_neigh=[Z_neigh,Z_share,Z_chrom];
% ѡ�����Ž⣬���µ�ǰ����
[~,ind]=sort(Z_neigh);
chrom=neigh(ind(1),:);
Z_chrom=Z_neigh(ind(1));
% ���¹�������⼯
share=neigh(2:share_size+1,:);
Z_share=Z_neigh(2:share_size+1);