function T = DVS_activity_time(Nsamples,timing,Tmax,Tmin)

    Log_min = 20/log10(10000000);
    Log_max = 20/log10(10000);
    t1 = timing(2:Nsamples)/1000000;
    t2 = timing(1:Nsamples-1)/1000000;
    t = t1-t2;
    t(t==0) = [];% to avoid infinities
    f = 1./t;
    fmean = sum(f)/Nsamples;
    Log = 20/log10(fmean); 
    T = (((Tmax-Tmin)/(Log_max-Log_min))*(Log-Log_min)+Tmin);
%     Fmax = 10000000;
%     Fmin = 10000;
%     t1 = timing(2:Nsamples)/1000000;
%     t2 = timing(1:Nsamples-1)/1000000;
%     t = t1-t2;
%     t(t==0) = [];% to avoid infinities
%     F = 1./t;
%     F = mean(F);
%     T = ((Tmax-Tmin)/(Fmin-Fmax))*(F - Fmax) + Tmin;
    
end