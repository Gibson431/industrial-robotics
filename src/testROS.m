robot = Ned();
robot.controller = TM5Controller;
robot.hasROS = true;
robot.controller.Connect('127.0.0.113111');

while true
    robot.doStep();
end