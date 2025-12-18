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

local function open_float(lines, title)
    -- create buffer to hold file output
    local buf = api.nvim_create_buf(false, true)
    api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
    api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- create window to view file output
    local ui = api.nvim_list_uis()[1]
    local width = math.floor(ui.width * 0.8)
    local height = math.floor(ui.height * 0.8)
    local row = math.floor((ui.height - height) / 2)
    local col = math.floor((ui.width - width) / 2)
    local opts = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        border = "rounded",
        title = title or "Output",
        title_pos = "center",
        style = "minimal",
    }
    local win = api.nvim_open_win(buf, true, opts)

    -- close helper
    vim.keymap.set("n", "q", function()
        if api.nvim_win_is_valid(win) then
            api.nvim_win_close(win, true)
        end
    end, { buffer = buf, nowait = true, silent = true, desc = "Close output" })

    return buf, win
end

local function run_cmd(cmd_table, buf)
    local on_exit = function(res)
        local out = {}

        local function add_block(label, text)
            if text and text ~= "" then
                table.insert(out, label)
                for line in (text .. "\n"):gmatch("(.-)\n") do
                    table.insert(out, line)
                end
                table.insert(out, "")
            end
        end

        add_block("=== STDOUT ===", res.stdout)
        add_block("=== STDERR ===", res.stderr)
        add_block("=== EXIT CODE ===", res.code)

        vim.schedule(function()
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
        end)
    end

    vim.system(cmd_table, { text = true }, on_exit)
end
