clear all;
load data.mat;
data1 = p1(1).d(:,1);
fb = cwtfilterbank('SignalLength',numel(data1));
[cfs,f,coi] = wt(fb,data1);
t = 0:numel(data1)-1;
pcolor(t,f,abs(cfs))
shading flat
set(gca,'YScale','log')
hold on
plot(t,coi,'w-','LineWidth',3)
xlabel('Time (Samples)')
ylabel('Normalized Frequency (cycles/sample)')
title('Scalogram')