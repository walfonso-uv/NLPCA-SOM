function TagName = SOM_ClusterDefinition(net,P,Value)
% Define the number of cluster based on threshold value which is determined
% by the user. If 'Value' (segregation value) is not defined, the default
% is 1.
% 
% TagName = SOM_ClusterDefinition(net,P,Value)
% 
% where net is the neural network trained using selforgmap function, P are
% the patterns, and Value is the threshold to split clusters.
% 
% TagName is the name added per cluster based on the threshold value. Each
% data is labeled with tags like: 'Cluster #1', 'Cluster #2', and so on; if
% a neuron does not have any data associated then it is labeled as
% 'Inactive Neurons'.

if (nargin<3)
    Value = 1;
end

aux00 = dist(net.IW{1},net.IW{1}');
aux01 = net.layers{1}.distances;
maxdistnet = max(aux00(aux01<=1));
aux00(aux01>1) = Inf;
aux00(aux00>maxdistnet) = Inf;
aux02 = sum(net(P),2);
aux00(aux02==0,:) = Inf;
aux00(:,aux02==0) = Inf;
aux00(aux02==0,aux02==0) = 0;

% New neighborhood matrix adding segregation value
aux03 = aux00<maxdistnet*Value;
% R is an auxiliar variable to build new neighborhoods based on the
% segregation value.
R = false(size(aux00));

for m=1:net.layers{1}.size
    R = (boolean(single(aux03(:,m))*single(aux03(:,m)'))|R);
    R = (boolean(single(R(:,m))*single(R(:,m)'))|R);
end

% Random color assignation to paint neurons with similar features based on
% the value segragation
Colors = zeros(net.layers{1}.size,3);
Colors(R(:,1)==true,1) = rand(1);
Colors(R(:,1)==true,2) = rand(1);
Colors(R(:,1)==true,3) = rand(1);

aux04 = single(R(:,1));
Num   = 1:net.layers{1}.size;
Vec   = Num(aux04==1);
numCl = 0;

if aux02(Vec(1))~=0
    numCl = numCl+1;
    TagName(R(:,Vec(1))) = {strcat('Cluster #',num2str(numCl))};
    ClusterColor(numCl,:) = Colors(Vec(1),:);
else
    TagName(R(:,Vec(1))) = {'Inactive Neurons'};
    InactiveColor(1,:) = Colors(Vec(1),:);
end

while sum(aux04)<net.layers{1}.size
    Vec = Num(aux04==0);
    Colors(R(:,Vec(1))==true,1) = rand(1);
    Colors(R(:,Vec(1))==true,2) = rand(1);
    Colors(R(:,Vec(1))==true,3) = rand(1);
    aux04(R(:,Vec(1))==true) = 1;
    if aux02(Vec(1))~=0
        numCl = numCl+1;
        TagName(R(:,Vec(1))) = {strcat('Cluster #',num2str(numCl))};
        ClusterColor(numCl,:) = Colors(Vec(1),:);
    else
        TagName(R(:,Vec(1))) = {'Inactive Neurons'};
        InactiveColor(1,:) = Colors(Vec(1),:);
    end
end

numNeurons = net.layers{1}.size;
topologyFcn = net.layers{1}.topologyFcn;

if strcmp(topologyFcn,'gridtop')
    shapex = [-1 1 1 -1]*0.5;
    shapey = [1 1 -1 -1]*0.5;
    dx = 1;
    dy = 1;
elseif strcmp(topologyFcn,'hextop')
    z = sqrt(0.75);
    shapex = [-1 0 1 1 0 -1]*0.5;
    shapey = [1 2 1 -1 -2 -1]*(z/3);
    dx = 1;
    dy = sqrt(0.75);
end

pos = net.layers{1}.positions;
dim = net.layers{1}.dimensions;
dim1 = dim(1);
dim2 = dim(2);

a = axes;

set(a,'dataaspectratio',[1 1 1],'box','on','color',[1 1 1])
hold on
patches = zeros(1,numNeurons);
text_out = zeros(1,numNeurons);
for i=1:numNeurons
    fill(pos(1,i)+shapex,pos(2,i)+shapey,[1 1 1],...
        'EdgeColor',[1 1 1]*0.8,'FaceColor',[1 1 1]*0.5);
end

for i=1:numNeurons
    patches(i) = fill(pos(1,i)+shapex,pos(2,i)+shapey,Colors(i,:),...
        'EdgeColor',[0.4 0.4 0.6]*0.5);
end

for i=1:numNeurons
    text_out(i) = text(pos(1,i),pos(2,i),'',...
        'HorizontalAlignment','center','VerticalAlignment','middle',...
        'FontWeight','bold','color',[1 1 1],'FontSize',9);
end

set(a,'xlim',[-1 (dim1-0.5)*dx + 1]);
set(a,'ylim',[-1 (dim2-0.5)*dy + 0.5]);
title(a,'Hits');
set(gcf,'Name','Classification Result');
set(a,'Visible','off');

[Tags, idx] = unique(TagName);
legend(patches(idx),Tags,'Location','southoutside','Orientation',...
    'horizontal','Color','none','EdgeColor','none');