function [logical physical] = parse_list_new(filename)

rec = textread(filename, '%s');
n = regexp(rec,'(?<logical>.*)_(?<physical>.*)', 'names');

nrec = size(n,1);
logical   = cell(nrec,1);
physical  = cell(nrec,1);

for ii = 1:nrec
  logical{ii,1}   = n{ii}.logical;
  physical{ii,1}  = n{ii}.physical;
end
