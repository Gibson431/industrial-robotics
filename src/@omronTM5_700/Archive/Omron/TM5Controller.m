classdef TM5Controller < handle

    properties
        jointStateSubscriber;
        currentJointState_123456;
        nextJointState;
        jointNames;
        controlClient;
        goal;
        seq;
    end

    methods
        function Connect(self, ip_add)
            default_ip = 'http://127.0.0.1:11311/';
            if nargin > 1
                default_ip = ip_add;
            end 

            try
                rosshutdown
            catch
                disp('no ros active yet');
            end

            rosinit(default_ip)
            self.jointStateSubscriber = rossubscriber('joint_states','sensor_msgs/JointState');

            while isempty(self.jointStateSubscriber.LatestMessage)
                pause(0.2);
                disp('waiting for joint state');
            end
            disp('joint state recieved')

            pause(2); % Pause to give time for a message to appear
            self.currentJointState_123456 = (self.jointStateSubscriber.LatestMessage.Position)';
            self.jointNames = {'shoulder_1_joint','shoulder_2_joint', 'elbow_joint', 'wrist_1_joint', 'wrist_2_joint', 'wrist_3_joint'};

            [self.controlClient, self.goal] = rosactionclient('/follow_joint_trajectory');
            self.seq = 1;

        end

        function actuate_gripper(self)
            gripperClient = rossvcclient('/gripper_serv', 'std_srvs/Trigger');
            resp = call(gripperClient);
        end

        function SetGoal(self, duration, joints, reset)
            joints(5) = -joints(5);
            self.goal.Trajectory.JointNames = self.jointNames;
            self.seq = self.seq + 1;
            self.goal.Trajectory.Header.Seq = self.seq;
            self.goal.Trajectory.Header.Stamp = rostime('Now','system');
            self.goal.GoalTimeTolerance = rosduration(0.1);
            bufferSeconds = 1; % This allows for the time taken to send the message. If the network is fast, this could be reduced.

            if reset == 1
                self.currentJointState_123456 = (self.jointStateSubscriber.LatestMessage.Position)';
            end

            startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
            startJointSend.Positions = self.currentJointState_123456;
            startJointSend.Velocities = zeros(1,6);
            startJointSend.TimeFromStart = rosduration(0);

            endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
            self.nextJointState = joints;
            endJointSend.Positions = joints;
            endJointSend.Velocities = zeros(1,6);
            endJointSend.TimeFromStart = rosduration(duration);

            self.goal.Trajectory.Points = [startJointSend; endJointSend];

            self.goal.Trajectory.Header.Stamp = self.jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds);
        end

        function doGoal(self)
            sendGoal(self.controlClient,self.goal);
        end

        function done = checkGoal(self)
            if strcmp(self.controlClient.GoalState, 'active')
                done = 0;
            else
                done = 1;
            end
        end

        function cancelGoal(self)
            cancelGoal(self.controlClient);
        end
    end
end