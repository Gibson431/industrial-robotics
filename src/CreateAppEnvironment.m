function app = CreateAppEnvironment(app, origin)
% hold on;
app.NedRobot = Ned(origin.T); %* transl(0.75,0.5,0));
app.ElleRobot = Elle(origin.T); % * transl(1.75,-0.25,0));

x_pos = origin.t(1);
y_pos = origin.t(2);
z_pos = origin.t(3);

surface = surf([-2,-2;+2,+2] ,[-3.25,+0.75;-3.25,+0.75] ,[z_pos-0.9,z_pos-0.9;...
    z_pos-0.9,z_pos-0.9],'CData',imread('concrete.jpg'),'FaceColor','texturemap');
app.environment = [app.environment, surface];


flats = PlaceObject("2_Flats.ply",[x_pos+1.5,y_pos+0.3,z_pos]);
% rotate(flats, [0,0,1], 90, [0,0,0]);
app.environment = [app.environment, flats];

table = PlaceObject("table.ply",[x_pos,y_pos+0.4,z_pos-0.95]);
rotate(table, [0,0,1], 90, [0,0,0]);
app.environment = [app.environment, table];

table = PlaceObject("table.ply",[x_pos+1.15,y_pos+0.75,z_pos-0.95]);
% rotate(table, [0,0,1], 90, [0,0,0]);
app.environment = [app.environment, table];


% app.environment = [app.environment, PlaceObject("table.ply",[x_pos+0.4,y_pos+0.4,z_pos-0.95])];

app.environment = [app.environment, PlaceObject("Security_Fence.ply",[x_pos-0.75,y_pos-1.75,z_pos-0.9])];
app.environment = [app.environment, PlaceObject("Security_Fence.ply",[x_pos+0.75,y_pos-1.75,z_pos-0.9])];

app.environment = [app.environment, PlaceObject("wall.ply",[x_pos,y_pos+0.75,z_pos+0.1])];
wall = PlaceObject("wall.ply",[x_pos-1.25,y_pos-2,z_pos+0.1]);
rotate(wall, [0,0,1], 90, [0,0,0]);
app.environment = [app.environment, wall];

security_cam = PlaceObject("SecurityCam.ply",[x_pos+1.2,y_pos-0.75,z_pos+0.8]);
rotate(security_cam, [0,0,1], 180, [0,0,0]);
app.environment = [app.environment, security_cam];

e_stop = PlaceObject("e-stop.ply",[x_pos-1.5,y_pos+0.4,z_pos-0.75]);
rotate(e_stop, [1,0,0], 90, [0,0,0]);
app.environment = [app.environment, e_stop];

person = PlaceObject("person.ply",[x_pos-0.3,y_pos+1.6,z_pos-0.9]);
rotate(person, [0,0,1], 135, [0,0,0]);
app.environment = [app.environment, person];

app.environment = [app.environment, PlaceObject("FireExtinguisher.ply",[x_pos+0.9,y_pos-1.5,z_pos-0.9])];

end