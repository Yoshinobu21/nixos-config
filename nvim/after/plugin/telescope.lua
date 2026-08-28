local ok, telescope = pcall(require, "telescope")
if not ok then
    return
end

local actions = require("telescope.actions")

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            },
        },
    },
    extensions = {
        file_browser = {
            theme = "ivy",
            hijack_netrw = false,
            grouped = true,
            hidden = true,
            respect_gitignore = false,
            initial_mode = "insert",
        },
    },
})

pcall(telescope.load_extension, "file_browser")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fq", builtin.quickfix, { desc = "Quickfix list" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fm", function()
    builtin.man_pages({ sections = { "ALL" } })
end, { desc = "Man pages" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Open buffers" })
vim.keymap.set("n", "<leader>fg", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Grep search" })
vim.keymap.set("n", "<leader>fc", function()
    builtin.grep_string({ search = vim.fn.expand("%:t:r") })
end, { desc = "Find current file" })
vim.keymap.set("n", "<leader>fs", function()
    builtin.grep_string({})
end, { desc = "Find string under cursor" })
vim.keymap.set("n", "<leader>fi", function()
    builtin.find_files({ cwd = "~/.config/nvim/" })
end, { desc = "Find files in nvim config" })

-- Telescope File Browser keymaps
vim.keymap.set("n", "<leader>fe", function()
    telescope.extensions.file_browser.file_browser({
        path = "%:p:h",
        select_buffer = true,
    })
end, { desc = "File browser (current file dir)" })

vim.keymap.set("n", "<leader>fE", function()
    telescope.extensions.file_browser.file_browser()
end, { desc = "File browser (project root)" })
