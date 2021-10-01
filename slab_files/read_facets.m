fileID = fopen('facets10.fac');
data = cell2mat(textscan(fileID,'%f%f%f%f'));
fclose(fileID);

tmp = diff(data(:,1));
[val, idx] = min(tmp);

elem = data(1:idx,2:4);
tri = data(idx+1:end,2:4);
tri = tri+1;

figure
trimesh(tri, elem(:,1), elem(:,2), elem(:,3))
axis equal

area=zeros(length(tri),1);

for ii = 1:length(tri)

    p1=elem(tri(ii,1),:);
    p2=elem(tri(ii,2),:);
    p3=elem(tri(ii,3),:);
    area(ii,1) = 1/2*norm(cross(p2-p3,p3-p1));

end