close all
hold on
useROS = false;
X_BASE_DISTANCE = 0.5;
if ~useROS
    disp('TODO: the assignment');
    ned = Ned(transl(-X_BASE_DISTANCE/2,0,0));
    ned.robot.model.faces
    elle = Elle(transl(X_BASE_DISTANCE/2,0,0));
end

PlaceObject("Grow_Flat_Deep.ply",[0,0,0]);
PlaceObject("Grow_Flat.ply",[0,0,0]);
PlaceObject("Net_Pot.ply",[1,0,0]);
PlaceObject("30mm_Substrate.ply",[1,0,0]);




