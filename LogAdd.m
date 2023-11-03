function Lc = LogAdd(La,Lb)

 Lc = max(La , Lb)+ log (1+exp(-abs(La-Lb))) ; 