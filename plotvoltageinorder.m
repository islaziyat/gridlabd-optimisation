function plotvoltageinorder(x)

    p=load('p.mat');
    p=p.p;
    vout =  measure_performance(x);

    set(gcf, 'Position',  [200, 200, 1100, 700])
    subplot(3,1,1);
    plot(1:length(p),vout(p,1))
    xline(7)
    xline(12)
    xline(17)
    xline(20)
    xline(26)
    xline(30)
    xline(32)
    xline(35)
    xline(41)
    yline(1)
    hold on

    subplot(3,1,2);
    plot(1:length(p),vout(p,2))
    xline(7)
    xline(12)
    xline(17)
    xline(20)
    xline(26)
    xline(30)
    xline(32)
    xline(35)
    xline(41)
    yline(1)
    hold on

    subplot(3,1,3);
    plot(1:length(p),vout(p,3))

    xticks(1:length(p))
    xticklabels(p)

    xline(7)
    xline(12)
    xline(17)
    xline(20)
    xline(26)
    xline(30)
    xline(32)
    xline(35)
    xline(41)
    yline(1)
    hold on
end