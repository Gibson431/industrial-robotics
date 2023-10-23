classdef NedAndElleApp < matlab.apps.AppBase

    properties (Access = public)
        UIFigure matlab.ui.Figure
        GridLayout matlab.ui.container.GridLayout

        LeftPanel  matlab.ui.container.Panel
        LeftGrid matlab.ui.container.GridLayout
        Button matlab.ui.control.Button
        LeftSlider1 CustomSlider
        LeftSlider2 CustomSlider
        LeftSlider3 CustomSlider

        CentrePanel matlab.ui.container.Panel
        CentreGrid matlab.ui.container.GridLayout
        UIAxes matlab.ui.control.UIAxes
        EStopSwitch matlab.ui.control.Switch
        EStopSwitchLabel matlab.ui.control.Label

        RightPanel  matlab.ui.container.Panel
        RightGrid matlab.ui.container.GridLayout
        RightSlider1 CustomSlider
        RightSlider2 CustomSlider
        RightSlider3 CustomSlider

        NedRobot
        ElleRobot
    end

    properties (Access = private)
        onePanelWidth = 576;
        twoPanelWidth = 768;
        eStop = false;
        environment;
    end
    methods (Access = private)
        function Slider1ValueChanged(app, event)
            value = event.Value;
            disp(value);
        end

        function Slider2ValueChanged(app, event)
            value = app.LeftSlider2.Slider.Value;
            disp(event);
        end

        function Slider3ValueChanged(app, event)
            value = app.LeftSlider3.Slider.Value;
            disp(event);
        end

        function EStopValueChanged(app, event)
            app.eStop = event.Value;
        end

        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)

                % Change to a 3x1 grid
                app.GridLayout.RowHeight = {480,480,480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.CentrePanel.Layout.Row = 1;
                app.CentrePanel.Layout.Column = 1;
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 3;
                app.RightPanel.Layout.Column = 1;
            elseif(currentFigureWidth > app.onePanelWidth && currentFigureWidth <= app.twoPanelWidth)

                % Change to a 2x2 grid
                app.GridLayout.RowHeight = {480,480};
                app.GridLayout.ColumnWidth = {'1x', '1x'};
                app.CentrePanel.Layout.Row = 1;
                app.CentrePanel.Layout.Column = [1,2];
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 2;
            else

                % Change to a 1x3 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {'1x','2x','1x'};
                app.LeftPanel.Layout.Row = 1;
                app.LeftPanel.Layout.Column = 1;
                app.CentrePanel.Layout.Row = 1;
                app.CentrePanel.Layout.Column = 2;
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 3;
            end
        end
    end

    % Component initialisation
    methods (Access = private)

        % Create UIFigure and components
        function creatComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible','off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 860 480];
            app.UIFigure.Name = 'Ned and Elle App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create grid layout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {220, '1x', 220};
            app.GridLayout.RowHeight = {'2x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'off';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create LeftGrid
            app.LeftGrid = uigridlayout(app.LeftPanel);
            app.LeftGrid.ColumnWidth = {'1x', '2x'};
            app.LeftGrid.RowHeight = {'1x','1x','1x','3x'};
            app.LeftGrid.ColumnSpacing = 2.5;
            app.LeftGrid.Padding = [10 10 10 10];

            % Create CustomSlider1
            app.LeftSlider1 = CustomSlider(app.LeftGrid);
            app.LeftSlider1.Label.Text = 'Slider';
            app.LeftSlider1.Slider.ValueChangedFcn = createCallbackFcn(app, @Slider1ValueChanged, true);

            % Create CustomSlider2
            app.LeftSlider2 = CustomSlider(app.LeftGrid);
            app.LeftSlider2.Label.Text = 'Slider';
            app.LeftSlider2.Slider.ValueChangedFcn = createCallbackFcn(app, @Slider2ValueChanged, true);

            % Create CustomSlider3
            app.LeftSlider3 = CustomSlider(app.LeftGrid);
            app.LeftSlider3.Label.Text = 'Slider';
            app.LeftSlider3.Slider.ValueChangedFcn = createCallbackFcn(app, @Slider3ValueChanged, true);

            % Create Button
            % app.Button = uibutton(app.LeftGrid, 'push');
            % app.Button.Position = [60 219 100 3];

            % Create CentrePanel
            app.CentrePanel = uipanel(app.GridLayout);
            app.CentrePanel.Layout.Row = 1;
            app.CentrePanel.Layout.Column = 2;

            % Create CentreGrid
            app.CentreGrid = uigridlayout(app.CentrePanel);
            app.CentreGrid.ColumnWidth = {'1x'};
            app.CentreGrid.RowHeight = {'7x','1x','1x'};
            app.CentreGrid.Padding = [10 10 10 10];


            % Create UIAxes
            % app.UIAxes = uiaxes(app.CentreGrid);
            % view(app.UIAxes, [1 1 1]);
            % axis(app.UIAxes, 'tight');
            % grid(app.UIAxes, "on");
            % hold(app.UIAxes, "on");
            % title(app.UIAxes, 'Title');
            % app.UIAxes.Layout.Row = 1;
            % app.UIAxes.Layout.Column = 1;

            % axes(app.UIAxes);
            % xlabel(app.UIAxes, 'X');

            % Create EStopSwitchLabel
            app.EStopSwitchLabel = uilabel(app.CentreGrid);
            app.EStopSwitchLabel.Text = 'E-Stop';
            app.EStopSwitchLabel.HorizontalAlignment = 'center';
            % app.EStopSwitchLabel.Position = [0 0 40 22];
            app.EStopSwitchLabel.Layout.Row = 2;
            app.EStopSwitchLabel.Layout.Column = 1;

            % Create EStopSwitch
            app.EStopSwitch = uiswitch(app.CentreGrid, 'slider');
            % app.EStopSwitch.HorizontalAlignment = 'center';
            % app.EStopSwitch.Position = [0 0 45 20];
            app.EStopSwitch.Layout.Row = 3;
            app.EStopSwitch.Layout.Column = 1;
            app.EStopSwitch.ValueChangedFcn = createCallbackFcn(app, @EStopValueChanged, true);

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 1;

            % Create RightGrid
            app.RightGrid = uigridlayout(app.RightPanel);
            app.RightGrid.ColumnWidth = {'1x', '2x'};
            app.RightGrid.RowHeight = {'1x','1x','1x','3x'};
            app.RightGrid.ColumnSpacing = 2.5;
            app.RightGrid.Padding = [10 10 10 10];

            % Create CustomSlider1
            app.RightSlider1 = CustomSlider(app.RightGrid);
            app.RightSlider1.Label.Text = 'Slider';
            app.RightSlider1.Slider.ValueChangedFcn = createCallbackFcn(app, @Slider1ValueChanged, true);

            % Create CustomSlider2
            app.RightSlider2 = CustomSlider(app.RightGrid);
            app.RightSlider2.Label.Text = 'Slider';
            app.RightSlider2.Slider.ValueChangedFcn = createCallbackFcn(app, @Slider2ValueChanged, true);

            % Create CustomSlider3
            app.RightSlider3 = CustomSlider(app.RightGrid);
            app.RightSlider3.Label.Text = 'Slider';
            app.RightSlider3.Slider.ValueChangedFcn = createCallbackFcn(app, @Slider3ValueChanged, true);

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';

        end

        function app = createEnvironment(app)
            origin = SE3(transl(0,0,0));
            hold on;
            % app.NedRobot = Ned(origin.T * transl(0.5,-0.25,0));
            app.ElleRobot = Elle(origin.T * transl(-0.25,0.35,0));

            x_pos = origin.t(1);
            y_pos = origin.t(2);
            z_pos = origin.t(3);
            
            surface = surf([-2,-2;+2,+2] ,[-2,+2;-2,+2] ,[z_pos-0.9,z_pos-0.9;...
                z_pos-0.9,z_pos-0.9],'CData',imread('concrete.jpg'),'FaceColor','texturemap');
            app.environment = [app.environment, surface];


            flats = PlaceObject("2_Flats.ply",[x_pos+0.35,y_pos,z_pos]);
            rotate(flats, [0,0,1], 90, [0,0,0]);
            app.environment = [app.environment, flats];

            table = PlaceObject("table.ply",[x_pos,y_pos+0.5,z_pos-0.95]);
            rotate(table, [0,0,1], 90, [0,0,0]);
            app.environment = [app.environment, table];
            
            table = PlaceObject("table.ply",[x_pos+1.05,y_pos+0.75,z_pos-0.95]);
            % rotate(table, [0,0,1], 90, [0,0,0]);
            app.environment = [app.environment, table];


%             app.environment = [app.environment, PlaceObject("table.ply",[x_pos+0.4,y_pos+0.4,z_pos-0.95])];

            app.environment = [app.environment, PlaceObject("Security_Fence.ply",[x_pos-0.75,y_pos-1.75,z_pos-0.9])];
            app.environment = [app.environment, PlaceObject("Security_Fence.ply",[x_pos+0.75,y_pos-1.75,z_pos-0.9])];

            app.environment = [app.environment, PlaceObject("wall.ply",[x_pos,y_pos+2,z_pos+0.1])];
            wall = PlaceObject("wall.ply",[x_pos,y_pos-2,z_pos+0.1]);
            rotate(wall, [0,0,1], 90, [0,0,0]);
            app.environment = [app.environment, wall];

            security_cam = PlaceObject("SecurityCam.ply",[x_pos+1.2,y_pos-2,z_pos+0.8]);
            rotate(security_cam, [0,0,1], 180, [0,0,0]);
            app.environment = [app.environment, security_cam];

            e_stop = PlaceObject("e-stop.ply",[x_pos-1.5,y_pos+0.4,z_pos-2]);
            rotate(e_stop, [1,0,0], 90, [0,0,0]);
            app.environment = [app.environment, e_stop];

            person = PlaceObject("person.ply",[x_pos-0.3,y_pos+1.6,z_pos-0.9]);
            rotate(person, [0,0,1], 135, [0,0,0]);
            app.environment = [app.environment, person];

            app.environment = [app.environment, PlaceObject("FireExtinguisher.ply",[x_pos+0.9,y_pos-1.5,z_pos-0.9])];

        end
    end

    % App creation and deletion
    methods (Access = public)
        function app = NedAndElleApp

            % Create UIFigure and components
            creatComponents(app)


            % Register the app with App Designer
            registerApp(app, app.UIFigure)


            % Create Environment
            % pause(5);
            app.createEnvironment();

            app.processLoop();
            
            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end

        function app = processLoop(app)
            while (true)
                disp(app.environment);
                if (app.EStopSwitch.Value == "Off")
                    % app.NedRobot.doStep();
                    app.ElleRobot.doStep();
                else
                    pause(0.1);
                end
            end
        end
    end
end