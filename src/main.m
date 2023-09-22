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



