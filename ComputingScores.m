function ComputingScores(ProgramsPath,new,GMMpath,LAN,nt,NewDim)


q1 = [' --featureFilesPath ',new,'\Features\'];
q2 = [' --mixtureFilesPath ',GMMpath,'\'      ];
q3 = [' --lstPath '         ,ProgramsPath,'\Test\'        ];
q4 = [' --labelFilesPath '  ,new,'\Labels\'  ];
q5 = [' --featureServerMask	0-',num2str(NewDim-1)];
q6 = [' --vectSize ',num2str(NewDim)];


dos(['ComputeTest.exe --config computeTest.cfg --ndxFilename ',new, '\A3.LST',...
    ' --inputWorldFilename UBM --outputFilename ', new, '\TestResults\',...
    LAN,'-',num2str(nt),'.res',q1,q2,q3,q4,q5,q6]);