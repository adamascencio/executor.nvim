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
