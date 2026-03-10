
resize = function(win, amt, dir)
    return function()
        require("winresize").resize(win, amt, dir)
    end
end
