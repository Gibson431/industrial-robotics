classdef CustomSlider
    properties (Access = public)
        Slider matlab.ui.control.Slider
        Label matlab.ui.control.Label
    end

    methods (Access = public)
        function self = CustomSlider(parent)
            self.Label = uilabel(parent);
            self.Slider = uislider(parent);

            self.Label.Layout.Column = 1;
            self.Slider.Layout.Column = 2;
        end
    end
end