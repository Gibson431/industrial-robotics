close all
hold on
useROS = false;
X_BASE_DISTANCE = 0.6;
if ~useROS
    disp('TODO: the assignment');
    ned = Ned(transl(-X_BASE_DISTANCE/2,0,0));
    ned.robot.model.faces
    elle = Elle(transl(X_BASE_DISTANCE/2,0,0));
end

tr = ned.robot.model.base;
x_pos = tr.t(1);
y_pos = tr.t(2);
z_pos = tr.t(3);

flats = PlaceObject("2_Flats.ply",[x_pos+0.2,y_pos-0,z_pos+0]);
rotate(flats, [0,0,1], 90, [0,0,0]);
% 
% PlaceObject("Net_Pot.ply",[x_pos+0,y_pos+0,z_pos+0]);
% 
% PlaceObject("30mm_Substrate.ply",[x_pos+0,y_pos+0,z_pos+0]);
table = PlaceObject("table.ply",[x_pos-0.2,y_pos+0.8,z_pos-0.95]);
rotate(table, [0,0,1], 90, [0,0,0]);





