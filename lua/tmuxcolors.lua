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

    local fg = color_from_syntax("Normal", "fg");
    local bg = color_from_syntax("Normal", "bg");
    local highlight_fg = color_from_syntax("lualine_a_normal", "fg");
    local highlight_bg = color_from_syntax("lualine_a_normal", "bg");

    local status_style = 'set -g status-style "bg=' .. bg .. ',fg=' .. fg .. '"'
    local status_left = 'set -g status-left "#[bg=' .. bg .. ']#[fg=' .. fg .. '] #I #[bg=default]#[fg=default] "'
    local status_right = 'set -g status-right ""'

    local window_status_style = 'setw -g window-status-style fg="' .. fg .. '",bg="' .. bg .. '"'
    local window_status_current_style = 'setw -g window-status-current-style fg="' .. highlight_bg .. '",bg="' .. highlight_fg .. '"'
    local window_status_format = 'setw -g window-status-format " #I #W "'
    local window_status_current_format = 'setw -g window-status-current-format " #I #W "'

    return {
        instruction,
        status_style,
        status_left,
        status_right,
        window_status_style,
        window_status_current_style,
        window_status_format,
        window_status_current_format
    }
end

local function tmuxcolors()
    -- Generate output buffer
    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(buf, "Termcolors")
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
