function [fidtxt,fidtxt2]=MakingFolders (new)
% making ...
rmdir([new,'\Waves\'          ],'s');
mkdir([new,'\Waves\'          ]);

% making ...
rmdir([new,'\EnhancedWaves\'  ],'s');
mkdir([new,'\EnhancedWaves\'  ]);

% making ...
rmdir([new,'\Features\'       ],'s');
mkdir([new,'\Features\'       ]);

% making ...
textFileName  = [new '\A3.LST'];
fidtxt        = fopen(textFileName,'w');

% making ...
textFileName2 = [new '\A2.LST'];
fidtxt2       = fopen(textFileName2,'w');