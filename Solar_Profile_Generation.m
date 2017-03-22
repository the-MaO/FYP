
%Generates Solar profile from hourly solar irradiation data

Sun = [0	0	0	0	0	39.618	71.714	143.13	441.75	640.72	1263.1	1527.1	1614	1426.2	1516.6	1500.1	1268.7	1052.8	551.85	149.69	40.352	2.6816	0	0 ];

Sun = Sun/ max(Sun)*1000;

 SUN_f=fit([1:24]',Sun','gauss2');
for ii = 1:1:1440;
  
    
    SUN(ii) = SUN_f(ii/60);
%     
%     if( rem(ii,60) == 0)
%     SUN(ii) = Sun(ii/60);
%     end
%        
end

SUN = 3.5*SUN;
plot(SUN_f)