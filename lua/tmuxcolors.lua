local function color_from_syntax(name, type)
    type = type or "fg"
    local result = vim.api.nvim_eval('synIDattr(synIDtrans(hlID("' .. name .. '")), "' .. type .. '#")')
    if result == "" then
        return nil
    else
        return result
    end
end

local function build_tmux_config()
    local instruction = "# Copy this to your tmux.conf"

    local a_fg = color_from_syntax("lualine_a_normal", "fg");
    local a_bg = color_from_syntax("lualine_a_normal", "bg");
    local b_fg = color_from_syntax("lualine_b_normal", "fg");
    local b_bg = color_from_syntax("lualine_b_normal", "bg");
    local c_fg = color_from_syntax("lualine_c_normal", "fg");
    local c_bg = color_from_syntax("lualine_c_normal", "bg");

    local status_style = 'set -g status-style "bg=' .. c_bg .. ',fg=' .. c_fg .. '"'
    local status_left = 'set -g status-left "#[bg=' .. c_fg .. ']#[fg=' .. c_bg .. '] #S "'
    local status_left_length = 'set -g status-left-length 100'
    local status_right = 'set -g status-right "#[bg=' .. c_fg .. ']#[fg=' .. c_bg .. '] #(date) "'

    local window_status_style = 'setw -g window-status-style fg="' .. c_fg .. '",bg="' .. c_bg .. '"'
    local window_status_current_style = 'setw -g window-status-current-style fg="' .. c_bg .. '",bg="' .. c_fg .. '"'
    local window_status_format = 'setw -g window-status-format " #I #W "'
    local window_status_current_format = 'setw -g window-status-current-format " #I #W "'
    local window_status_separator = 'setw -g window-status-separator ""'

    return {
        instruction,
        status_style,
        status_left,
        status_left_length,
        status_right,
        window_status_style,
        window_status_current_style,
        window_status_format,
        window_status_current_format,
        window_status_separator
    }
end

local function tmuxcolors()
    -- Generate output buffer
    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(buf, "tmuxcolors")
    vim.api.nvim_buf_set_lines(buf, 0, 1, true, build_tmux_config())
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "readonly", true)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "filetype", "conf")
    vim.cmd("buffer " .. buf)
end

return {
    tmuxcolors = tmuxcolors
}
