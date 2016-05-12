function [j,o,m] = break_num(digits)

j=floor(digits/100);

digits=mod(digits,100);

o=floor(digits/10);

m=mod(digits,10);

end

