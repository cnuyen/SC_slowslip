fileID = fopen('slab_contours.txt');
tmp = cell2mat(textscan(fileID,'%f%f%f', 'HeaderLine', 1, 'Delimiter', ','));

contours = llh2local([tmp(:,1)'; tmp(:,2)'],[-119.6250, 49.3226]);
contours = contours';
contours(:,3) = tmp(:,3);

% Find indices for the top and bottom edges. These indices are used in the long all function calls.
top = [];
bottom = [];
row = 1;

for ii=-100:5:-5

   idx = find(contours(:,3) == ii);
   lat = contours(idx,2);
   [B,I] = sort(lat);
   bottom(row)= idx(I(end));
   top(row) = idx(I(1));
   row = row +1;
end

dt = delaunayTriangulation(contours(:,1),contours(:,2));

%plot before removing edge connections
triplot(dt,contours(:,1),contours(:,2),'r.');
hold on
plot(contours(:,1),contours(:,2),'r.')

%remove any triangles where all vertices lie alone the 5 or 100km contour,
%or the bottom or top edge of the fault model
tri = dt.ConnectivityList;
tri(all(tri <= 215,2),:) = [];
tri(all(tri >= 758 & tri <= 929,2),:) = [];
tri(all(tri == 929 | tri == 3147 | tri == 1711 | tri == 2976 | tri == 757 | tri == 2806 | tri == 1541 | tri == 2639 | tri == 589 ...
     | tri == 2473 | tri == 1375 | tri == 2310 | tri == 425 | tri == 2150 | tri == 1214 | tri == 1997 | tri == 268  | tri == 1847 ...
      | tri == 1061 | tri == 1,2),:) = [];
tri(all(tri == 758 | tri == 2977 | tri == 1542 | tri == 2807 | tri == 590 | tri == 2640 | tri == 1376 | tri == 2474 | tri == 426 ...
     | tri == 2311 | tri == 1215 | tri == 2151 | tri == 269 | tri == 1998 | tri == 1062 | tri == 1848 | tri == 126  | tri == 1712 ...
      | tri == 930 | tri == 125,2),:) = [];

%plot after removing edge connections
figure  
triplot(tri,dt.Points(:,1), dt.Points(:,2))
hold on 
plot(contours(:,1),contours(:,2),'r.')


%% Create facet file, format can be found at coreform.com/cubit_help/geometry/import/importing_facet.htm

n=length(contours);
m=length(tri);

fileID = fopen('facet.fac','w');
fprintf(fileID,'%d %d\n',n,m);

for ii=1:length(contours)
    fprintf(fileID,'%d %10f %10f %d\n',ii, contours(ii,1),contours(ii,2),contours(ii,3));
end

for ii=1:length(tri)
    fprintf(fileID,'%d %d %d %d\n',ii, tri(ii,1),tri(ii,2),tri(ii,3));
end

