classdef CustomJointControl
    properties (Access = public)
        GridLayout matlab.ui.container.GridLayout

        Link0Label matlab.ui.control.Label
        Link0 matlab.ui.control.Slider
        
        Link1Label matlab.ui.control.Label
        Link1 matlab.ui.control.Slider
        
        Link2Label matlab.ui.control.Label
        Link2 matlab.ui.control.Slider
        
        Link3Label matlab.ui.control.Label
        Link3 matlab.ui.control.Slider
        
        Link4Label matlab.ui.control.Label
        Link4 matlab.ui.control.Slider
        
        Link5Label matlab.ui.control.Label
        Link5 matlab.ui.control.Slider

    end

    methods (Access = public)
        function self = CustomJointControl(parent)
            self.GridLayout = uigridlayout(parent);
            self.GridLayout.ColumnWidth = {'1x','4x'};
            self.GridLayout.RowHeight = {'1x','1x','1x','1x','1x','1x',};

            self.Link0Label = uilabel(self.GridLayout);
            self.Link0Label.Text = "Link 0";
            self.Link0Label.Layout.Column = 1;
            self.Link0Label.Layout.Row = 1;
            self.Link0 = uislider(self.GridLayout);
            self.Link0.Layout.Column = 2;
            self.Link0.Layout.Row = 1;

            self.Link1Label = uilabel(self.GridLayout);
            self.Link1Label.Text = "Link 1";
            self.Link1Label.Layout.Column = 1;
            self.Link1Label.Layout.Row = 2;
            self.Link1 = uislider(self.GridLayout);
            self.Link1.Layout.Column = 2;
            self.Link1.Layout.Row = 2;

            self.Link2Label = uilabel(self.GridLayout);
            self.Link2Label.Text = "Link 2";
            self.Link2Label.Layout.Column = 1;
            self.Link2Label.Layout.Row = 3;
            self.Link2 = uislider(self.GridLayout);
            self.Link2.Layout.Column = 2;
            self.Link2.Layout.Row = 3;

            self.Link3Label = uilabel(self.GridLayout);
            self.Link3Label.Text = "Link 3";
            self.Link3Label.Layout.Column = 1;
            self.Link3Label.Layout.Row = 4;
            self.Link3 = uislider(self.GridLayout);
            self.Link3.Layout.Column = 2;
            self.Link3.Layout.Row = 4;
            
            self.Link4Label = uilabel(self.GridLayout);
            self.Link4Label.Text = "Link 4";
            self.Link4Label.Layout.Column = 1;
            self.Link4Label.Layout.Row = 5;
            self.Link4 = uislider(self.GridLayout);
            self.Link4.Layout.Column = 2;
            self.Link4.Layout.Row = 5;
            
            self.Link5Label = uilabel(self.GridLayout);
            self.Link5Label.Text = "Link 5";
            self.Link5Label.Layout.Column = 1;
            self.Link5Label.Layout.Row = 6;
            self.Link5 = uislider(self.GridLayout);
            self.Link5.Layout.Column = 2;
            self.Link5.Layout.Row = 6;
            
        end
    end
end