local M = {}
local api = vim.api

local function get_curr_file()
    local filepath = vim.api.nvim_buf_get_name(0)
    local filetype = vim.bo.filetype
    local file = {
        ft = filetype,
        fp = filepath,
    }
    return file
end

local function get_run_cmd(filepath, filetype)
    local ft_cmd = {
        python = { "python", filepath },
        lua = { "lua", filepath },
        javascript = { "node", filepath },
        typescript = { "node", filepath },
        go = { "go", "run", filepath },
    }
    return ft_cmd[filetype]
end
