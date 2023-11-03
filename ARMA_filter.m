
function y1 = ARMA_filter(b,a,x)

num_ord = size(b,2);
den_ord = size(a,2);
xx      = [x(end-33:end) x ];
y       = xx;

if (num_ord==3 && den_ord==3)    
    for cnt=3:size(xx,2)        
        Num  =  b(1)*xx(cnt)+ b(2)*xx(cnt-1) + b(3)*xx(cnt-2) ;
        Den  =  a(2)*y(cnt-1) + a(3)*y(cnt-2) ;
        y(cnt)=(Num-Den)/a(1);
    end    
end
y1=y(35:end);
end
